import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class SensorEndpoint extends Endpoint {
  
  /// Get sensor readings for a device
  Future<List<SensorReading>> getDeviceReadings(
    Session session,
    int deviceId, {
    DateTime? since,
  }) async {
    final sinceTime = since ?? DateTime.now().subtract(const Duration(hours: 24));
    
    return await SensorReading.db.find(
      session,
      where: (t) => t.deviceId.equals(deviceId) & t.timestamp.isAfter(sinceTime),
      orderBy: (t) => t.timestamp,
    );
  }

  /// Add new sensor reading
  Future<SensorReading> addReading(
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

    final savedReading = await SensorReading.db.insertRow(session, reading);
    
    // Trigger alert check after adding reading
    await _checkForAlerts(session, deviceId, type, value);
    
    return savedReading;
  }

  /// Get latest reading for device and type
  Future<SensorReading?> getLatestReading(
    Session session,
    int deviceId,
    String type,
  ) async {
    return await SensorReading.db.findFirstRow(
      session,
      where: (t) => t.deviceId.equals(deviceId) & t.type.equals(type),
      orderBy: (t) => t.timestamp.desc(),
    );
  }

  /// Internal method to check for alerts based on thresholds
  Future<void> _checkForAlerts(
    Session session,
    int deviceId,
    String type,
    double value,
  ) async {
    String? alertMessage;
    String severity = 'info';

    // Define thresholds
    switch (type.toLowerCase()) {
      case 'temperature':
        if (value > 100) {
          alertMessage = 'Critical temperature: ${value}°C exceeds safe operating limit';
          severity = 'critical';
        } else if (value > 80) {
          alertMessage = 'Temperature warning: ${value}°C exceeds normal operating range';
          severity = 'warning';
        }
        break;
        
      case 'voltage':
        if (value < 9) {
          alertMessage = 'Critical voltage: ${value}V below minimum operating voltage';
          severity = 'critical';
        } else if (value < 10) {
          alertMessage = 'Voltage warning: ${value}V below normal operating range';
          severity = 'warning';
        }
        break;
        
      case 'humidity':
        if (value > 90) {
          alertMessage = 'High humidity warning: ${value}% may cause condensation';
          severity = 'warning';
        } else if (value < 10) {
          alertMessage = 'Low humidity warning: ${value}% may cause static buildup';
          severity = 'warning';
        }
        break;
    }

    // Create alert if threshold exceeded
    if (alertMessage != null) {
      // Check if similar alert already exists
      final existingAlert = await Alert.db.findFirstRow(
        session,
        where: (t) => t.deviceId.equals(deviceId) & 
                     t.resolved.equals(false) &
                     t.message.equals(alertMessage),
      );

      if (existingAlert == null) {
        final alert = Alert(
          deviceId: deviceId,
          severity: severity,
          message: alertMessage,
          resolved: false,
        );
        
        await Alert.db.insertRow(session, alert);
      }
    }
  }
}