import 'package:serverpod/serverpod.dart';
import '../services/device_registry_service.dart';

/// Custom authentication handler for IoT devices using Bearer token authentication
Future<AuthenticationInfo?> iotDeviceAuthHandler(
  Session session,
  String token,
) async {
  try {
    // Log authentication attempt for security monitoring
    session.log('IoT device authentication attempt', level: LogLevel.debug);
    
    // Extract device ID from session context (will be set by endpoint)
    final deviceId = session.serverpod.getFromContext('deviceId') as String?;
    
    if (deviceId == null) {
      session.log('Authentication failed: Missing device ID in context', 
                 level: LogLevel.warning);
      return null;
    }
    
    // Validate Bearer token format
    if (!token.startsWith('Bearer ')) {
      session.log('Authentication failed: Invalid Bearer token format', 
                 level: LogLevel.warning);
      return null;
    }
    
    // Extract API key from Bearer token
    final apiKey = token.substring(7); // Remove 'Bearer ' prefix
    
    if (apiKey.isEmpty) {
      session.log('Authentication failed: Empty API key', 
                 level: LogLevel.warning);
      return null;
    }
    
    // Lookup device by API key and device ID
    final device = await DeviceRegistryService.findDeviceByApiKey(
      session,
      apiKey,
      deviceId,
    );
    
    if (device == null) {
      session.log('Authentication failed: Device not found for API key and device ID', 
                 level: LogLevel.warning);
      return null;
    }
    
    session.log('IoT device authenticated successfully: ${device.name} (ID: ${device.id})', 
               level: LogLevel.info);
    
    // Return authentication info with device details
    return AuthenticationInfo(
      device.id!,
      {
        'deviceId': device.id!,
        'deviceName': device.name,
        'deviceType': device.type,
      },
    );
    
  } catch (e, stackTrace) {
    session.log('Authentication error: $e', 
               level: LogLevel.error, 
               exception: e, 
               stackTrace: stackTrace);
    return null;
  }
}