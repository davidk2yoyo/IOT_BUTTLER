import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class DeviceEndpoint extends Endpoint {
  
  /// Get all devices
  Future<List<Device>> getDevices(Session session) async {
    return await Device.db.find(session);
  }

  /// Get device by ID
  Future<Device?> getDevice(Session session, int deviceId) async {
    return await Device.db.findById(session, deviceId);
  }

  /// Create new device
  Future<Device> createDevice(
    Session session,
    String name,
    String location,
  ) async {
    final device = Device(
      name: name,
      location: location,
      status: 'online',
    );
    
    return await Device.db.insertRow(session, device);
  }

  /// Update device status
  Future<Device?> updateDeviceStatus(
    Session session,
    int deviceId,
    String status,
  ) async {
    final device = await Device.db.findById(session, deviceId);
    if (device == null) return null;

    final updatedDevice = device.copyWith(
      status: status,
      updatedAt: DateTime.now(),
    );

    return await Device.db.updateRow(session, updatedDevice);
  }

  /// Delete device
  Future<bool> deleteDevice(Session session, int deviceId) async {
    final device = await Device.db.findById(session, deviceId);
    if (device == null) return false;

    await Device.db.deleteRow(session, device);
    return true;
  }
}