import 'dart:async';
import 'dart:math';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class DataSimulator {
  static DataSimulator? _instance;
  Timer? _timer;
  final Random _random = Random();

  DataSimulator._();

  static DataSimulator get instance {
    _instance ??= DataSimulator._();
    return _instance!;
  }

  /// Start the data simulation
  void start(Session session) {
    stop(); // Stop any existing timer
    
    print('Starting IoT data simulator...');
    
    // Generate data every 30 seconds
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _generateSensorData(session);
    });
    
    // Generate initial data
    _generateSensorData(session);
  }

  /// Stop the data simulation
  void stop() {
    _timer?.cancel();
    _timer = null;
    print('Data simulator stopped');
  }

  /// Generate realistic sensor data for all devices
  Future<void> _generateSensorData(Session session) async {
    try {
      final devices = await Device.db.find(session);
      
      for (final device in devices) {
        await _generateDeviceReadings(session, device);
        await _updateDeviceStatus(session, device);
      }
    } catch (e) {
      print('Error generating sensor data: $e');
    }
  }

  /// Generate sensor readings for a specific device
  Future<void> _generateDeviceReadings(Session session, Device device) async {
    // Generate temperature reading
    final temperature = _generateTemperature(device);
    await _addReading(session, device.id!, 'temperature', temperature, '°C');

    // Generate voltage reading  
    final voltage = _generateVoltage(device);
    await _addReading(session, device.id!, 'voltage', voltage, 'V');

    // Occasionally generate humidity reading
    if (_random.nextDouble() < 0.3) {
      final humidity = _generateHumidity();
      await _addReading(session, device.id!, 'humidity', humidity, '%');
    }
  }

  /// Generate realistic temperature based on device type and time
  double _generateTemperature(Device device) {
    final baseTemp = device.name.toLowerCase().contains('server') ? 45.0 : 35.0;
    final variation = _random.nextGaussian() * 5.0;
    final timeVariation = sin(DateTime.now().hour * pi / 12) * 3.0;
    
    // Simulate occasional temperature spikes
    final spike = _random.nextDouble() < 0.05 ? _random.nextDouble() * 30.0 : 0.0;
    
    return (baseTemp + variation + timeVariation + spike).clamp(20.0, 120.0);
  }

  /// Generate realistic voltage readings
  double _generateVoltage(Device device) {
    final baseVoltage = device.name.toLowerCase().contains('solar') ? 12.0 : 11.5;
    final variation = _random.nextGaussian() * 0.5;
    
    // Simulate occasional voltage drops
    final drop = _random.nextDouble() < 0.08 ? _random.nextDouble() * 3.0 : 0.0;
    
    return (baseVoltage + variation - drop).clamp(8.0, 15.0);
  }

  /// Generate humidity readings
  double _generateHumidity() {
    final baseHumidity = 50.0;
    final variation = _random.nextGaussian() * 10.0;
    
    return (baseHumidity + variation).clamp(10.0, 95.0);
  }

  /// Add sensor reading and trigger alert checking
  Future<void> _addReading(
    Session session,
    int deviceId,
    String type,
    double value,
    String unit,
  ) async {
    final reading = SensorReading(
      deviceId: deviceId,
      type: type,
      value: value,
      unit: unit,
    );

    await SensorReading.db.insertRow(session, reading);
    
    // Check for alerts based on thresholds
    await _checkThresholds(session, deviceId, type, value);
  }

  /// Check sensor thresholds and create alerts
  Future<void> _checkThresholds(
    Session session,
    int deviceId,
    String type,
    double value,
  ) async {
    String? alertMessage;
    String severity = 'info';

    switch (type.toLowerCase()) {
      case 'temperature':
        if (value > 100) {
          alertMessage = 'Critical temperature: ${value.toStringAsFixed(1)}°C exceeds safe operating limit';
          severity = 'critical';
        } else if (value > 80) {
          alertMessage = 'Temperature warning: ${value.toStringAsFixed(1)}°C exceeds normal operating range';
          severity = 'warning';
        }
        break;
        
      case 'voltage':
        if (value < 9) {
          alertMessage = 'Critical voltage: ${value.toStringAsFixed(1)}V below minimum operating voltage';
          severity = 'critical';
        } else if (value < 10) {
          alertMessage = 'Voltage warning: ${value.toStringAsFixed(1)}V below normal operating range';
          severity = 'warning';
        }
        break;
        
      case 'humidity':
        if (value > 90) {
          alertMessage = 'High humidity warning: ${value.toStringAsFixed(1)}% may cause condensation';
          severity = 'warning';
        } else if (value < 15) {
          alertMessage = 'Low humidity warning: ${value.toStringAsFixed(1)}% may cause static buildup';
          severity = 'warning';
        }
        break;
    }

    if (alertMessage != null) {
      // Check if similar alert already exists and is unresolved
      final existingAlert = await Alert.db.findFirstRow(
        session,
        where: (t) => t.deviceId.equals(deviceId) & 
                     t.resolved.equals(false) &
                     t.severity.equals(severity) &
                     t.message.like('%${type}%'),
      );

      if (existingAlert == null) {
        final alert = Alert(
          deviceId: deviceId,
          severity: severity,
          message: alertMessage,
          resolved: false,
        );
        
        await Alert.db.insertRow(session, alert);
        print('Alert created: $alertMessage');
      }
    }
  }

  /// Update device status based on recent readings and alerts
  Future<void> _updateDeviceStatus(Session session, Device device) async {
    // Get recent alerts
    final recentAlerts = await Alert.db.find(
      session,
      where: (t) => t.deviceId.equals(device.id!) & t.resolved.equals(false),
    );

    // Determine status based on alerts
    String newStatus = 'online';
    
    if (recentAlerts.any((alert) => alert.severity == 'critical')) {
      newStatus = 'offline';
    } else if (recentAlerts.any((alert) => alert.severity == 'warning')) {
      newStatus = 'warning';
    }

    // Simulate occasional random offline status
    if (_random.nextDouble() < 0.02) { // 2% chance
      newStatus = 'offline';
      
      // Create offline alert
      final offlineAlert = Alert(
        deviceId: device.id!,
        severity: 'critical',
        message: 'Device offline: Communication lost with ${device.name}',
        resolved: false,
      );
      await Alert.db.insertRow(session, offlineAlert);
    }

    // Update device status if changed
    if (device.status != newStatus) {
      final updatedDevice = device.copyWith(
        status: newStatus,
        updatedAt: DateTime.now(),
      );
      
      await Device.db.updateRow(session, updatedDevice);
      print('Device ${device.name} status updated to: $newStatus');
    }
  }

  /// Create initial demo devices if none exist
  Future<void> createDemoDevices(Session session) async {
    final existingDevices = await Device.db.find(session);
    
    if (existingDevices.isEmpty) {
      print('Creating demo devices...');
      
      final demoDevices = [
        Device(
          name: 'Solar Inverter #1',
          location: 'Rooftop Panel A',
          status: 'online',
        ),
        Device(
          name: 'Temperature Sensor',
          location: 'Server Room',
          status: 'online',
        ),
        Device(
          name: 'Voltage Monitor',
          location: 'Main Electrical Panel',
          status: 'online',
        ),
        Device(
          name: 'Humidity Sensor',
          location: 'Data Center',
          status: 'online',
        ),
      ];

      for (final device in demoDevices) {
        await Device.db.insertRow(session, device);
      }
      
      print('Demo devices created');
    }
  }
}

/// Extension to generate Gaussian random numbers
extension RandomGaussian on Random {
  double nextGaussian() {
    // Box-Muller transform
    static double? spare;
    if (spare != null) {
      final result = spare!;
      spare = null;
      return result;
    }
    
    final u = nextDouble();
    final v = nextDouble();
    final mag = sqrt(-2.0 * log(u));
    spare = mag * cos(2.0 * pi * v);
    return mag * sin(2.0 * pi * v);
  }
}