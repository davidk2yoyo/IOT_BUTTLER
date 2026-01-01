import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/butler_service.dart';

class ButlerEndpoint extends Endpoint {
  
  /// Get AI explanation for an alert
  Future<ButlerExplanation> explainAlert(
    Session session,
    int alertId, {
    String? additionalContext,
  }) async {
    // Get the alert
    final alert = await Alert.db.findById(session, alertId);
    if (alert == null) {
      throw Exception('Alert not found');
    }

    // Get device information
    final device = await Device.db.findById(session, alert.deviceId);
    if (device == null) {
      throw Exception('Device not found');
    }

    // Get recent sensor readings for context
    final recentReadings = await SensorReading.db.find(
      session,
      where: (t) => t.deviceId.equals(alert.deviceId),
      orderBy: (t) => t.timestamp.desc(),
      limit: 10,
    );

    // Check if explanation already exists
    final existingExplanation = await ButlerExplanation.db.findFirstRow(
      session,
      where: (t) => t.alertId.equals(alertId),
      orderBy: (t) => t.createdAt.desc(),
    );

    if (existingExplanation != null) {
      return existingExplanation;
    }

    // Generate new explanation using Butler service
    final butlerService = ButlerService();
    final explanationData = await butlerService.generateExplanation(
      alert: alert,
      device: device,
      recentReadings: recentReadings,
      additionalContext: additionalContext,
    );

    // Save explanation to database
    final explanation = ButlerExplanation(
      alertId: alertId,
      explanation: explanationData.explanation,
      suggestion: explanationData.suggestion,
    );

    return await ButlerExplanation.db.insertRow(session, explanation);
  }

  /// Get all explanations for a device
  Future<List<ButlerExplanation>> getDeviceExplanations(
    Session session,
    int deviceId,
  ) async {
    // Get alerts for device first
    final alerts = await Alert.db.find(
      session,
      where: (t) => t.deviceId.equals(deviceId),
    );

    final alertIds = alerts.map((a) => a.id!).toList();
    if (alertIds.isEmpty) return [];

    return await ButlerExplanation.db.find(
      session,
      where: (t) => t.alertId.inSet(alertIds),
      orderBy: (t) => t.createdAt.desc(),
    );
  }

  /// Ask Butler a custom question about a device
  Future<String> askButlerQuestion(
    Session session,
    int deviceId,
    String question,
  ) async {
    final device = await Device.db.findById(session, deviceId);
    if (device == null) {
      throw Exception('Device not found');
    }

    final recentReadings = await SensorReading.db.find(
      session,
      where: (t) => t.deviceId.equals(deviceId),
      orderBy: (t) => t.timestamp.desc(),
      limit: 20,
    );

    final alerts = await Alert.db.find(
      session,
      where: (t) => t.deviceId.equals(deviceId) & t.resolved.equals(false),
    );

    final butlerService = ButlerService();
    return await butlerService.answerQuestion(
      question: question,
      device: device,
      recentReadings: recentReadings,
      activeAlerts: alerts,
    );
  }
}