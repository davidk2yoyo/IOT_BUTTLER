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

abstract class IngestRequest
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  IngestRequest._({
    required this.deviceId,
    required this.type,
    required this.value,
    this.alert,
    this.alertMessage,
  });

  factory IngestRequest({
    required String deviceId,
    required String type,
    required double value,
    bool? alert,
    String? alertMessage,
  }) = _IngestRequestImpl;

  factory IngestRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return IngestRequest(
      deviceId: jsonSerialization['deviceId'] as String,
      type: jsonSerialization['type'] as String,
      value: (jsonSerialization['value'] as num).toDouble(),
      alert: jsonSerialization['alert'] as bool?,
      alertMessage: jsonSerialization['alertMessage'] as String?,
    );
  }

  /// The device ID sending the data
  String deviceId;

  /// The type of sensor reading (temperature, humidity, voltage, custom)
  String type;

  /// The sensor value
  double value;

  /// Optional alert flag provided by device
  bool? alert;

  /// Optional alert message provided by device
  String? alertMessage;

  /// Returns a shallow copy of this [IngestRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  IngestRequest copyWith({
    String? deviceId,
    String? type,
    double? value,
    bool? alert,
    String? alertMessage,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'IngestRequest',
      'deviceId': deviceId,
      'type': type,
      'value': value,
      if (alert != null) 'alert': alert,
      if (alertMessage != null) 'alertMessage': alertMessage,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'IngestRequest',
      'deviceId': deviceId,
      'type': type,
      'value': value,
      if (alert != null) 'alert': alert,
      if (alertMessage != null) 'alertMessage': alertMessage,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _IngestRequestImpl extends IngestRequest {
  _IngestRequestImpl({
    required String deviceId,
    required String type,
    required double value,
    bool? alert,
    String? alertMessage,
  }) : super._(
         deviceId: deviceId,
         type: type,
         value: value,
         alert: alert,
         alertMessage: alertMessage,
       );

  /// Returns a shallow copy of this [IngestRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  IngestRequest copyWith({
    String? deviceId,
    String? type,
    double? value,
    Object? alert = _Undefined,
    Object? alertMessage = _Undefined,
  }) {
    return IngestRequest(
      deviceId: deviceId ?? this.deviceId,
      type: type ?? this.type,
      value: value ?? this.value,
      alert: alert is bool? ? alert : this.alert,
      alertMessage: alertMessage is String? ? alertMessage : this.alertMessage,
    );
  }
}
