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

abstract class IngestResponse
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  IngestResponse._({
    required this.status,
    required this.alertTriggered,
    this.errorMessage,
  });

  factory IngestResponse({
    required String status,
    required bool alertTriggered,
    String? errorMessage,
  }) = _IngestResponseImpl;

  factory IngestResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return IngestResponse(
      status: jsonSerialization['status'] as String,
      alertTriggered: jsonSerialization['alertTriggered'] as bool,
      errorMessage: jsonSerialization['errorMessage'] as String?,
    );
  }

  /// Status of the ingest operation ("ok" or "error")
  String status;

  /// Whether an alert was triggered by this reading
  bool alertTriggered;

  /// Error message if status is "error"
  String? errorMessage;

  /// Returns a shallow copy of this [IngestResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  IngestResponse copyWith({
    String? status,
    bool? alertTriggered,
    String? errorMessage,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'IngestResponse',
      'status': status,
      'alertTriggered': alertTriggered,
      if (errorMessage != null) 'errorMessage': errorMessage,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'IngestResponse',
      'status': status,
      'alertTriggered': alertTriggered,
      if (errorMessage != null) 'errorMessage': errorMessage,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _IngestResponseImpl extends IngestResponse {
  _IngestResponseImpl({
    required String status,
    required bool alertTriggered,
    String? errorMessage,
  }) : super._(
         status: status,
         alertTriggered: alertTriggered,
         errorMessage: errorMessage,
       );

  /// Returns a shallow copy of this [IngestResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  IngestResponse copyWith({
    String? status,
    bool? alertTriggered,
    Object? errorMessage = _Undefined,
  }) {
    return IngestResponse(
      status: status ?? this.status,
      alertTriggered: alertTriggered ?? this.alertTriggered,
      errorMessage: errorMessage is String? ? errorMessage : this.errorMessage,
    );
  }
}
