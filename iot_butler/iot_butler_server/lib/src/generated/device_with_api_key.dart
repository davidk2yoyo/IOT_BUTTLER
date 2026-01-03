/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'device.dart' as _i2;
import 'package:iot_butler_server/src/generated/protocol.dart' as _i3;

abstract class DeviceWithApiKey
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  DeviceWithApiKey._({
    required this.device,
    required this.apiKey,
  });

  factory DeviceWithApiKey({
    required _i2.Device device,
    required String apiKey,
  }) = _DeviceWithApiKeyImpl;

  factory DeviceWithApiKey.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeviceWithApiKey(
      device: _i3.Protocol().deserialize<_i2.Device>(
        jsonSerialization['device'],
      ),
      apiKey: jsonSerialization['apiKey'] as String,
    );
  }

  /// The created device record
  _i2.Device device;

  /// The plain text API key (returned only once)
  String apiKey;

  /// Returns a shallow copy of this [DeviceWithApiKey]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DeviceWithApiKey copyWith({
    _i2.Device? device,
    String? apiKey,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeviceWithApiKey',
      'device': device.toJson(),
      'apiKey': apiKey,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeviceWithApiKey',
      'device': device.toJsonForProtocol(),
      'apiKey': apiKey,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _DeviceWithApiKeyImpl extends DeviceWithApiKey {
  _DeviceWithApiKeyImpl({
    required _i2.Device device,
    required String apiKey,
  }) : super._(
         device: device,
         apiKey: apiKey,
       );

  /// Returns a shallow copy of this [DeviceWithApiKey]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DeviceWithApiKey copyWith({
    _i2.Device? device,
    String? apiKey,
  }) {
    return DeviceWithApiKey(
      device: device ?? this.device.copyWith(),
      apiKey: apiKey ?? this.apiKey,
    );
  }
}
