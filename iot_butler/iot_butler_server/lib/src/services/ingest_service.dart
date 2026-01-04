import 'package:serverpod/serverpod.dart';
import '../generated/alert.dart';
import '../generated/ingest_request.dart';
import '../generated/ingest_response.dart';
import '../generated/sensor_reading.dart';
import 'alert_integration_service.dart';
import 'device_registry_service.dart';

/// Shared logic for ingesting IoT sensor data.
class IngestService {
  static Future<IngestResponse> ingest(
    Session session,
    IngestRequest request,
  ) async {
    try {
      final validationError = _validateRequest(request);
      if (validationError != null) {
        session.log('Ingest validation failed: $validationError',
            level: LogLevel.warning);
        throw BadRequestException(validationError);
      }

      final authHeader =
          session.request?.getAuthorizationHeaderValue(true);
      if (authHeader == null || authHeader.trim().isEmpty) {
        throw UnauthorizedException('Missing Authorization header');
      }

      if (!authHeader.startsWith('Bearer ')) {
        throw UnauthorizedException('Invalid Authorization header');
      }

      final apiKey = authHeader.substring(7).trim();
      if (apiKey.isEmpty) {
        throw UnauthorizedException('Empty API key');
      }

      final device = await DeviceRegistryService.findDeviceByApiKey(
        session,
        apiKey,
        request.deviceId,
      );

      if (device == null) {
        final deviceById = await DeviceRegistryService.findDeviceByIdentifier(
          session,
          request.deviceId,
        );

        if (deviceById == null) {
          throw NotFoundException('Device not found');
        }

        throw UnauthorizedException('Invalid authentication');
      }

      final deviceId = device.id!;
      final timestamp = DateTime.now();

      final sensorReading = SensorReading(
        deviceId: deviceId,
        type: request.type,
        value: request.value,
        timestamp: timestamp,
        alertTriggered: false,
      );

      final insertedReading = await SensorReading.db.insertRow(
        session,
        sensorReading,
      );

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

      var alertTriggered = await AlertIntegrationService.evaluateThresholds(
        session,
        deviceId.toString(),
        request.type,
        request.value,
      );

      if (request.alert == true) {
        alertTriggered = true;
        if (request.alertMessage != null &&
            request.alertMessage!.trim().isNotEmpty) {
          session.log(
            'Device-supplied alert: ${request.alertMessage}',
            level: LogLevel.warning,
          );
        }
      }

      if (alertTriggered) {
        await SensorReading.db.updateById(
          session,
          insertedReading.id!,
          columnValues: (t) => [t.alertTriggered(true)],
        );

        await DeviceRegistryService.updateDeviceStatus(
          session,
          deviceId,
          'warning',
        );

        final message = (request.alertMessage != null &&
                request.alertMessage!.trim().isNotEmpty)
            ? request.alertMessage!.trim()
            : 'Threshold exceeded for ${request.type}: ${request.value}';

        final alert = Alert(
          deviceId: deviceId,
          severity: 'warning',
          message: message,
          resolved: false,
          createdAt: timestamp,
          resolvedAt: null,
        );

        await Alert.db.insertRow(session, alert);
      }

      session.log(
        'Sensor data ingested successfully: Device $deviceId, '
        'Type: ${request.type}, Value: ${request.value}',
        level: LogLevel.info,
      );

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
      session.log(
        'Ingest error: $e',
        level: LogLevel.error,
        exception: e,
        stackTrace: stackTrace,
      );

      return IngestResponse(
        status: 'error',
        alertTriggered: false,
        errorMessage: 'Internal server error',
      );
    }
  }

  static String? _validateRequest(IngestRequest request) {
    if (request.deviceId.isEmpty) {
      return 'Missing required field: deviceId';
    }

    if (request.type.isEmpty) {
      return 'Missing required field: type';
    }

    const validTypes = ['temperature', 'voltage', 'humidity', 'custom'];
    if (!validTypes.contains(request.type)) {
      return 'Invalid sensor type: ${request.type}. '
          'Valid types: ${validTypes.join(', ')}';
    }

    if (!request.value.isFinite) {
      return 'Invalid field type for value: must be a finite number';
    }

    return null;
  }
}

class BadRequestException implements Exception {
  final String message;
  BadRequestException(this.message);
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException(this.message);
}
