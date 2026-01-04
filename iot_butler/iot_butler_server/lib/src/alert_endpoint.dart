import 'package:serverpod/serverpod.dart';
import 'generated/alert.dart';

/// Endpoint for alert management.
class AlertEndpoint extends Endpoint {
  /// Get active alerts for a device.
  Future<List<Alert>> getDeviceAlerts(Session session, int deviceId) async {
    return Alert.db.find(
      session,
      where: (t) => t.deviceId.equals(deviceId) & t.resolved.equals(false),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// Resolve an alert by id.
  Future<void> resolveAlert(Session session, int alertId) async {
    await Alert.db.updateById(
      session,
      alertId,
      columnValues: (t) => [
        t.resolved(true),
        t.resolvedAt(DateTime.now()),
      ],
    );
  }
}
