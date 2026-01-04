import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';
import '../generated/device.dart';
import '../generated/device_with_api_key.dart';

/// Service for managing device registration and API key operations
class DeviceRegistryService {
  /// Creates a new device with a secure API key
  static Future<DeviceWithApiKey> createDevice(
    Session session, {
    required String name,
    required String type,
    required String location,
  }) async {
    // Generate cryptographically secure API key
    final apiKey = _generateSecureApiKey();
    final apiKeyHash = _hashApiKey(apiKey);
    
    final now = DateTime.now();
    
    // Create device record
    final device = Device(
      name: name,
      type: type,
      location: location,
      apiKeyHash: apiKeyHash,
      status: 'offline',
      lastSeen: null,
      createdAt: now,
      updatedAt: now,
    );
    
    // Insert device into database
    final insertedDevice = await Device.db.insertRow(session, device);
    
    // Return device with plain text API key (only returned once)
    return DeviceWithApiKey(
      device: insertedDevice,
      apiKey: apiKey,
    );
  }
  
  /// Finds a device by API key and device ID combination
  static Future<Device?> findDeviceByApiKey(
    Session session,
    String apiKey,
    String deviceId,
  ) async {
    final apiKeyHash = _hashApiKey(apiKey);
    
    // Parse device ID to integer
    final deviceIdInt = int.tryParse(deviceId);
    if (deviceIdInt == null) {
      return null;
    }
    
    // Find device by API key hash and device ID
    return await Device.db.findFirstRow(
      session,
      where: (t) => t.apiKeyHash.equals(apiKeyHash) & t.id.equals(deviceIdInt),
    );
  }

  /// Finds a device by ID or name (for string identifiers)
  static Future<Device?> findDeviceByIdentifier(
    Session session,
    String deviceId,
  ) async {
    final deviceIdInt = int.tryParse(deviceId);
    if (deviceIdInt != null) {
      return await Device.db.findById(session, deviceIdInt);
    }

    return await Device.db.findFirstRow(
      session,
      where: (t) => t.name.equals(deviceId),
    );
  }
  
  /// Updates device status
  static Future<void> updateDeviceStatus(
    Session session,
    int deviceId,
    String status,
  ) async {
    final now = DateTime.now();
    
    await Device.db.updateById(
      session,
      deviceId,
      columnValues: (t) => [
        t.status(status),
        t.updatedAt(now),
      ],
    );
  }
  
  /// Updates device lastSeen timestamp
  static Future<void> updateLastSeen(
    Session session,
    int deviceId,
    DateTime timestamp,
  ) async {
    final now = DateTime.now();
    
    await Device.db.updateById(
      session,
      deviceId,
      columnValues: (t) => [
        t.lastSeen(timestamp),
        t.updatedAt(now),
      ],
    );
  }
  
  /// Generates a cryptographically secure API key
  static String _generateSecureApiKey() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (i) => random.nextInt(256));
    return base64Url.encode(bytes).replaceAll('=', '');
  }
  
  /// Hashes an API key for secure storage
  static String _hashApiKey(String apiKey) {
    final bytes = utf8.encode(apiKey);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
