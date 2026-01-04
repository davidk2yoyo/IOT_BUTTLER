import 'package:serverpod/serverpod.dart';
import 'generated/device.dart';
import 'generated/device_with_api_key.dart';
import 'services/device_registry_service.dart';

/// Endpoint for device management operations
class DeviceEndpoint extends Endpoint {
  /// Creates a new device with a secure API key
  Future<DeviceWithApiKey> createDevice(
    Session session, {
    required String name,
    required String type,
    required String location,
  }) async {
    try {
      // Validate input parameters
      if (name.trim().isEmpty) {
        throw ArgumentError('Device name cannot be empty');
      }
      
      if (type.trim().isEmpty) {
        throw ArgumentError('Device type cannot be empty');
      }
      
      if (location.trim().isEmpty) {
        throw ArgumentError('Device location cannot be empty');
      }
      
      // Validate device type
      const validTypes = [
        'sensor',
        'solar',
        'voltage',
        'camera',
        'light',
        'door',
        'other',
        'temperature',
        'humidity',
      ];
      if (!validTypes.contains(type)) {
        throw ArgumentError('Invalid device type: $type. Valid types: ${validTypes.join(', ')}');
      }
      
      // Create device using registry service
      final deviceWithApiKey = await DeviceRegistryService.createDevice(
        session,
        name: name.trim(),
        type: type.trim(),
        location: location.trim(),
      );
      
      session.log('Device created successfully: ${deviceWithApiKey.device.name} (ID: ${deviceWithApiKey.device.id})', 
                 level: LogLevel.info);
      
      return deviceWithApiKey;
      
    } catch (e, stackTrace) {
      session.log('Device creation error: $e', 
                 level: LogLevel.error, 
                 exception: e, 
                 stackTrace: stackTrace);
      rethrow;
    }
  }
  
  /// Gets all devices
  Future<List<Device>> getAllDevices(Session session) async {
    try {
      final devices = await Device.db.find(session);
      
      session.log('Retrieved ${devices.length} devices', level: LogLevel.debug);
      
      return devices;
      
    } catch (e, stackTrace) {
      session.log('Error retrieving devices: $e', 
                 level: LogLevel.error, 
                 exception: e, 
                 stackTrace: stackTrace);
      rethrow;
    }
  }
  
  /// Gets a device by ID
  Future<Device?> getDevice(Session session, int deviceId) async {
    try {
      final device = await Device.db.findById(session, deviceId);
      
      if (device != null) {
        session.log('Retrieved device: ${device.name} (ID: ${device.id})', level: LogLevel.debug);
      } else {
        session.log('Device not found: ID $deviceId', level: LogLevel.warning);
      }
      
      return device;
      
    } catch (e, stackTrace) {
      session.log('Error retrieving device: $e', 
                 level: LogLevel.error, 
                 exception: e, 
                 stackTrace: stackTrace);
      rethrow;
    }
  }
}
