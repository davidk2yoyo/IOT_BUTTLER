import 'package:serverpod/serverpod.dart';

/// Service for integrating with the existing alert system
class AlertIntegrationService {
  /// Evaluates sensor readings against configured thresholds
  static Future<bool> evaluateThresholds(
    Session session,
    String deviceId,
    String sensorType,
    double value,
  ) async {
    try {
      // Define threshold values for different sensor types
      final thresholds = _getThresholds(sensorType);
      
      if (thresholds == null) {
        // No thresholds configured for this sensor type
        return false;
      }
      
      final alertTriggered = value > thresholds['max']! || value < thresholds['min']!;
      
      if (alertTriggered) {
        session.log('Alert threshold exceeded: Device $deviceId, Type: $sensorType, Value: $value', 
                   level: LogLevel.warning);
        
        // Trigger alert using existing alert engine
        await _triggerAlert(
          session,
          deviceId,
          sensorType,
          value,
          thresholds,
        );
      }
      
      return alertTriggered;
      
    } catch (e, stackTrace) {
      session.log('Alert evaluation error: $e', 
                 level: LogLevel.error, 
                 exception: e, 
                 stackTrace: stackTrace);
      return false;
    }
  }
  
  /// Triggers an alert using the existing alert engine
  static Future<void> _triggerAlert(
    Session session,
    String deviceId,
    String sensorType,
    double value,
    Map<String, double> thresholds,
  ) async {
    // This integrates with the existing alert system
    // For now, we'll log the alert - this can be extended to integrate
    // with the actual alert engine when available
    
    final alertType = value > thresholds['max']! ? 'HIGH_THRESHOLD' : 'LOW_THRESHOLD';
    final threshold = value > thresholds['max']! ? thresholds['max']! : thresholds['min']!;
    
    session.log(
      'ALERT TRIGGERED: Device $deviceId, Sensor: $sensorType, '
      'Value: $value, Threshold: $threshold, Type: $alertType',
      level: LogLevel.warning,
    );
    
    // TODO: Integrate with existing alert engine
    // This could call existing alert methods or store alert records
    // await ExistingAlertEngine.triggerAlert(deviceId, alertType, {
    //   'sensorType': sensorType,
    //   'value': value,
    //   'threshold': threshold,
    //   'timestamp': DateTime.now().toIso8601String(),
    // });
  }
  
  /// Gets threshold configuration for different sensor types
  static Map<String, double>? _getThresholds(String sensorType) {
    // Define default thresholds for different sensor types
    // These could be made configurable in the future
    switch (sensorType) {
      case 'temperature':
        return {'min': -10.0, 'max': 50.0}; // Celsius
      case 'humidity':
        return {'min': 10.0, 'max': 90.0}; // Percentage
      case 'voltage':
        return {'min': 3.0, 'max': 5.5}; // Volts
      case 'custom':
        return {'min': 0.0, 'max': 100.0}; // Generic range
      default:
        return null; // No thresholds for unknown types
    }
  }
}