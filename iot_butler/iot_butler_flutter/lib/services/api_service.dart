import 'package:iot_butler_client/iot_butler_client.dart' as sp;
import '../models/device.dart';
import '../main.dart'; // For accessing the global client

class CreateDeviceResult {
  final Device device;
  final String apiKey;

  CreateDeviceResult({
    required this.device,
    required this.apiKey,
  });
}

class ApiService {
  // Mock data for development/demo
  static final List<Device> _mockDevices = [
    Device(
      id: 1,
      name: 'Solar Inverter #1',
      location: 'Rooftop Panel A',
      status: 'online',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now().subtract(const Duration(minutes: 2)),
    ),
    Device(
      id: 2,
      name: 'Temperature Sensor',
      location: 'Server Room',
      status: 'warning',
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      updatedAt: DateTime.now().subtract(const Duration(minutes: 1)),
    ),
    Device(
      id: 3,
      name: 'Voltage Monitor',
      location: 'Main Electrical Panel',
      status: 'offline',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ];

  static final List<SensorReading> _mockReadings = [
    // Temperature readings for device 2
    SensorReading(
      id: 1,
      deviceId: 2,
      type: 'temperature',
      value: 85.5,
      unit: '°C',
      timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
    ),
    SensorReading(
      id: 2,
      deviceId: 2,
      type: 'temperature',
      value: 82.3,
      unit: '°C',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    // Voltage readings for device 1
    SensorReading(
      id: 3,
      deviceId: 1,
      type: 'voltage',
      value: 12.4,
      unit: 'V',
      timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
    ),
  ];

  static final List<Alert> _mockAlerts = [
    Alert(
      id: 1,
      deviceId: 2,
      severity: 'warning',
      message: 'Temperature exceeds normal operating range',
      resolved: false,
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    Alert(
      id: 2,
      deviceId: 3,
      severity: 'critical',
      message: 'Device offline for extended period',
      resolved: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ];

  // Device endpoints
  Future<List<Device>> getDevices() async {
    try {
      final devices = await client.device.getAllDevices();
      return devices.map(_mapDevice).toList();
    } catch (e) {
      await Future.delayed(const Duration(milliseconds: 200));
      return _mockDevices;
    }
  }

  Future<Device?> getDevice(int deviceId) async {
    try {
      final device = await client.device.getDevice(deviceId);
      return device == null ? null : _mapDevice(device);
    } catch (e) {
      await Future.delayed(const Duration(milliseconds: 200));
      try {
        return _mockDevices.firstWhere((device) => device.id == deviceId);
      } catch (_) {
        return null;
      }
    }
  }

  // Sensor data endpoints
  Future<List<SensorReading>> getDeviceReadings(int deviceId) async {
    final readings = await client.sensor.getDeviceReadings(deviceId);
    return readings.map(_mapReading).toList();
  }

  // Alert endpoints
  Future<List<Alert>> getDeviceAlerts(int deviceId) async {
    final alerts = await client.alert.getDeviceAlerts(deviceId);
    return alerts.map(_mapAlert).toList();
  }

  // Butler AI endpoint
  Future<ButlerExplanation> explainAlert(int alertId) async {
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate AI processing
    
    // Mock explanations based on alert
    final alert = _mockAlerts.firstWhere((a) => a.id == alertId);
    
    String explanation;
    String suggestion;
    
    if (alert.severity == 'warning' && alert.message.contains('Temperature')) {
      explanation = "The server room temperature is running high at 85.5°C. This is likely due to increased workload or insufficient cooling. High temperatures can reduce hardware lifespan and cause performance throttling.";
      suggestion = "Check air conditioning system and ensure proper ventilation. Consider reducing server load temporarily.";
    } else if (alert.severity == 'critical' && alert.message.contains('offline')) {
      explanation = "The voltage monitor has been offline for 2 hours. This could indicate a power supply issue, network connectivity problem, or hardware failure. Without monitoring, electrical issues may go undetected.";
      suggestion = "Check device power connection and network cable. If accessible, restart the device. Contact maintenance if issue persists.";
    } else {
      explanation = "An issue has been detected with this device that requires attention.";
      suggestion = "Please check the device status and contact support if needed.";
    }
    
    return ButlerExplanation(
      id: DateTime.now().millisecondsSinceEpoch,
      alertId: alertId,
      explanation: explanation,
      suggestion: suggestion,
      createdAt: DateTime.now(),
    );
  }

  Future<void> resolveAlert(int alertId) async {
    await client.alert.resolveAlert(alertId);
  }

  Future<CreateDeviceResult> createDevice({
    required String name,
    required String type,
    required String location,
  }) async {
    final result = await client.device.createDevice(
      name: name,
      type: type,
      location: location,
    );

    return CreateDeviceResult(
      device: _mapDevice(result.device),
      apiKey: result.apiKey,
    );
  }

  Device _mapDevice(sp.Device device) {
    return Device(
      id: device.id ?? 0,
      name: device.name,
      location: device.location,
      status: device.status,
      createdAt: device.createdAt,
      updatedAt: device.updatedAt,
    );
  }

  Alert _mapAlert(sp.Alert alert) {
    return Alert(
      id: alert.id ?? 0,
      deviceId: alert.deviceId,
      severity: alert.severity,
      message: alert.message,
      resolved: alert.resolved,
      createdAt: alert.createdAt,
      resolvedAt: alert.resolvedAt,
    );
  }

  SensorReading _mapReading(sp.SensorReading reading) {
    return SensorReading(
      id: reading.id ?? 0,
      deviceId: reading.deviceId,
      type: reading.type,
      value: reading.value,
      unit: _unitForType(reading.type),
      timestamp: reading.timestamp,
    );
  }

  String _unitForType(String type) {
    switch (type.toLowerCase()) {
      case 'temperature':
        return '°C';
      case 'voltage':
        return 'V';
      case 'humidity':
        return '%';
      default:
        return '';
    }
  }
}
