import 'package:serverpod/serverpod.dart';
import 'generated/ingest_request.dart';
import 'generated/ingest_response.dart';
import 'services/ingest_service.dart';

/// Secure HTTPS endpoint for IoT device data ingestion
class IngestEndpoint extends Endpoint {
  @override
  bool get requireLogin => false; // Uses custom authentication
  
  /// Ingests sensor data from authenticated IoT devices
  Future<IngestResponse> ingest(
    Session session,
    IngestRequest request,
  ) async {
    return IngestService.ingest(session, request);
  }
}
