import 'package:serverpod/serverpod.dart';
import 'generated/sensor_reading.dart';

/// Endpoint for reading sensor data.
class SensorEndpoint extends Endpoint {
  /// Get sensor readings for a device (last 24h by default).
  Future<List<SensorReading>> getDeviceReadings(
    Session session,
    int deviceId, {
    DateTime? since,
  }) async {
    final sinceTime = since ?? DateTime.now().subtract(const Duration(hours: 24));

    return SensorReading.db.find(
      session,
      where: (t) => t.deviceId.equals(deviceId) & (t.timestamp > sinceTime),
      orderBy: (t) => t.timestamp,
      orderDescending: true,
    );
  }
}
