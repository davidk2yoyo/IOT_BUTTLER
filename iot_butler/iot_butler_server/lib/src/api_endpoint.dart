import 'package:serverpod/serverpod.dart';
import 'generated/ingest_request.dart';
import 'generated/ingest_response.dart';
import 'services/ingest_service.dart';

/// Public API endpoint for IoT device ingestion.
class ApiEndpoint extends Endpoint {
  @override
  bool get requireLogin => false;

  /// Ingests sensor data from authenticated IoT devices.
  Future<IngestResponse> ingest(
    Session session,
    {
      required String deviceId,
      required String type,
      required double value,
      bool? alert,
      String? alertMessage,
    }
  ) async {
    final request = IngestRequest(
      deviceId: deviceId,
      type: type,
      value: value,
      alert: alert,
      alertMessage: alertMessage,
    );
    return IngestService.ingest(session, request);
  }
}
