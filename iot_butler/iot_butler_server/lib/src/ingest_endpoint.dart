import 'package:serverpod/serverpod.dart';
import 'generated/ingest_request.dart';
import 'generated/ingest_response.dart';
import 'generated/sensor_reading.dart';
import 'services/device_registry_service.dart';
import 'services/alert_integration_service.dart';

/// Secure HTTPS endpoint for IoT device data ingestion
class IngestEndpoint extends Endpoint {
  @override
  bool get requireLogin => false; // Uses custom authentication
  
  /// Ingests sensor data from authenticated IoT devices
  Future<IngestResponse> ingest(
    Session session,
    IngestRequest request,
  ) async {
    try {
      // Validate request payload
      final validationError = _validateRequest(request);
      if (validationError != null) {
        session.log('Ingest validation failed: $validationError', 
                   level: LogLevel.warning);
        throw BadRequestException(validationError);
      }
      
      // Get authorization header from HTTP request
      // Note: In Serverpod 3.x, we'll implement authentication directly in the endpoint
      // For now, we'll extract the API key from the request parameters or headers
      // This is a simplified approach that can be enhanced later
      
      // For testing purposes, we'll expect the API key to be passed as a parameter
      // In production, this should come from the Authorization header
      // TODO: Implement proper HTTP header access for Serverpod 3.x
      
      // Temporary: Extract API key from device ID format "deviceId:apiKey"
      final parts = request.deviceId.split(':');
      if (parts.length != 2) {
        throw UnauthorizedException('Invalid device ID format. Expected: deviceId:apiKey');
      }
      
      final deviceIdStr = parts[0];
      final apiKey = parts[1];
      
      if (apiKey.isEmpty) {
        throw UnauthorizedException('Empty API key');
      }
      
      // Find device by API key and device ID
      final device = await DeviceRegistryService.findDeviceByApiKey(
        session,
        apiKey,
        deviceIdStr,
      );
      
      if (device == null) {
        session.log('Authentication failed: Device not found for API key and device ID', 
                   level: LogLevel.warning);
        throw UnauthorizedException('Invalid authentication');
      }
      
      final deviceId = device.id!;
      final timestamp = DateTime.now();
      
      // Store sensor reading
      final sensorReading = SensorReading(
        deviceId: deviceId,
        type: request.type,
        value: request.value,
        timestamp: timestamp,
        alertTriggered: false, // Will be updated if alert triggers
      );
      
      final insertedReading = await SensorReading.db.insertRow(
        session, 
        sensorReading,
      );
      
      // Update device status to online and lastSeen
      await DeviceRegistryService.updateDeviceStatus(
        session,
        deviceId,
        'online',
      );
      
      await DeviceRegistryService.updateLastSeen(
        session,
        deviceId,
        timestamp,
      );
      
      // Evaluate alert thresholds
      final alertTriggered = await AlertIntegrationService.evaluateThresholds(
        session,
        deviceId.toString(),
        request.type,
        request.value,
      );
      
      // Update sensor reading with alert status
      if (alertTriggered) {
        await SensorReading.db.updateById(
          session,
          insertedReading.id!,
          columnValues: (t) => [t.alertTriggered(true)],
        );
        
        // Update device status to warning when alert triggers
        await DeviceRegistryService.updateDeviceStatus(
          session,
          deviceId,
          'warning',
        );
      }
      
      session.log('Sensor data ingested successfully: Device $deviceId, Type: ${request.type}, Value: ${request.value}', 
                 level: LogLevel.info);
      
      return IngestResponse(
        status: 'ok',
        alertTriggered: alertTriggered,
      );
      
    } on BadRequestException catch (e) {
      return IngestResponse(
        status: 'error',
        alertTriggered: false,
        errorMessage: e.message,
      );
    } on UnauthorizedException catch (e) {
      return IngestResponse(
        status: 'error',
        alertTriggered: false,
        errorMessage: e.message,
      );
    } on NotFoundException catch (e) {
      return IngestResponse(
        status: 'error',
        alertTriggered: false,
        errorMessage: e.message,
      );
    } catch (e, stackTrace) {
      session.log('Ingest error: $e', 
                 level: LogLevel.error, 
                 exception: e, 
                 stackTrace: stackTrace);
      
      return IngestResponse(
        status: 'error',
        alertTriggered: false,
        errorMessage: 'Internal server error',
      );
    }
  }
  
  /// Validates the ingest request payload
  String? _validateRequest(IngestRequest request) {
    if (request.deviceId.isEmpty) {
      return 'Missing required field: deviceId';
    }
    
    if (request.type.isEmpty) {
      return 'Missing required field: type';
    }
    
    // Validate sensor type
    const validTypes = ['temperature', 'voltage', 'humidity', 'custom'];
    if (!validTypes.contains(request.type)) {
      return 'Invalid sensor type: ${request.type}. Valid types: ${validTypes.join(', ')}';
    }
    
    // Validate value is a finite number
    if (!request.value.isFinite) {
      return 'Invalid field type for value: must be a finite number';
    }
    
    return null;
  }
}

/// Exception for bad request errors (HTTP 400)
class BadRequestException implements Exception {
  final String message;
  BadRequestException(this.message);
}

/// Exception for unauthorized errors (HTTP 401)
class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);
}

/// Exception for not found errors (HTTP 404)
class NotFoundException implements Exception {
  final String message;
  NotFoundException(this.message);
}