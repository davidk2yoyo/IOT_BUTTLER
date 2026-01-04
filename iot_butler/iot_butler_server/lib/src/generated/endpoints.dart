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
import '../alert_endpoint.dart' as _i2;
import '../api_endpoint.dart' as _i3;
import '../device_endpoint.dart' as _i4;
import '../greeting_endpoint.dart' as _i5;
import '../ingest_endpoint.dart' as _i6;
import '../sensor_endpoint.dart' as _i7;
import 'package:iot_butler_server/src/generated/ingest_request.dart' as _i8;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'alert': _i2.AlertEndpoint()
        ..initialize(
          server,
          'alert',
          null,
        ),
      'api': _i3.ApiEndpoint()
        ..initialize(
          server,
          'api',
          null,
        ),
      'device': _i4.DeviceEndpoint()
        ..initialize(
          server,
          'device',
          null,
        ),
      'greeting': _i5.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
      'ingest': _i6.IngestEndpoint()
        ..initialize(
          server,
          'ingest',
          null,
        ),
      'sensor': _i7.SensorEndpoint()
        ..initialize(
          server,
          'sensor',
          null,
        ),
    };
    connectors['alert'] = _i1.EndpointConnector(
      name: 'alert',
      endpoint: endpoints['alert']!,
      methodConnectors: {
        'getDeviceAlerts': _i1.MethodConnector(
          name: 'getDeviceAlerts',
          params: {
            'deviceId': _i1.ParameterDescription(
              name: 'deviceId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['alert'] as _i2.AlertEndpoint).getDeviceAlerts(
                    session,
                    params['deviceId'],
                  ),
        ),
        'resolveAlert': _i1.MethodConnector(
          name: 'resolveAlert',
          params: {
            'alertId': _i1.ParameterDescription(
              name: 'alertId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['alert'] as _i2.AlertEndpoint).resolveAlert(
                session,
                params['alertId'],
              ),
        ),
      },
    );
    connectors['api'] = _i1.EndpointConnector(
      name: 'api',
      endpoint: endpoints['api']!,
      methodConnectors: {
        'ingest': _i1.MethodConnector(
          name: 'ingest',
          params: {
            'deviceId': _i1.ParameterDescription(
              name: 'deviceId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'type': _i1.ParameterDescription(
              name: 'type',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'alert': _i1.ParameterDescription(
              name: 'alert',
              type: _i1.getType<bool?>(),
              nullable: true,
            ),
            'alertMessage': _i1.ParameterDescription(
              name: 'alertMessage',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['api'] as _i3.ApiEndpoint).ingest(
                session,
                deviceId: params['deviceId'],
                type: params['type'],
                value: params['value'],
                alert: params['alert'],
                alertMessage: params['alertMessage'],
              ),
        ),
      },
    );
    connectors['device'] = _i1.EndpointConnector(
      name: 'device',
      endpoint: endpoints['device']!,
      methodConnectors: {
        'createDevice': _i1.MethodConnector(
          name: 'createDevice',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'type': _i1.ParameterDescription(
              name: 'type',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'location': _i1.ParameterDescription(
              name: 'location',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['device'] as _i4.DeviceEndpoint).createDevice(
                    session,
                    name: params['name'],
                    type: params['type'],
                    location: params['location'],
                  ),
        ),
        'getAllDevices': _i1.MethodConnector(
          name: 'getAllDevices',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['device'] as _i4.DeviceEndpoint)
                  .getAllDevices(session),
        ),
        'getDevice': _i1.MethodConnector(
          name: 'getDevice',
          params: {
            'deviceId': _i1.ParameterDescription(
              name: 'deviceId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['device'] as _i4.DeviceEndpoint).getDevice(
                session,
                params['deviceId'],
              ),
        ),
      },
    );
    connectors['greeting'] = _i1.EndpointConnector(
      name: 'greeting',
      endpoint: endpoints['greeting']!,
      methodConnectors: {
        'hello': _i1.MethodConnector(
          name: 'hello',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['greeting'] as _i5.GreetingEndpoint).hello(
                session,
                params['name'],
              ),
        ),
      },
    );
    connectors['ingest'] = _i1.EndpointConnector(
      name: 'ingest',
      endpoint: endpoints['ingest']!,
      methodConnectors: {
        'ingest': _i1.MethodConnector(
          name: 'ingest',
          params: {
            'request': _i1.ParameterDescription(
              name: 'request',
              type: _i1.getType<_i8.IngestRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['ingest'] as _i6.IngestEndpoint).ingest(
                session,
                params['request'],
              ),
        ),
      },
    );
    connectors['sensor'] = _i1.EndpointConnector(
      name: 'sensor',
      endpoint: endpoints['sensor']!,
      methodConnectors: {
        'getDeviceReadings': _i1.MethodConnector(
          name: 'getDeviceReadings',
          params: {
            'deviceId': _i1.ParameterDescription(
              name: 'deviceId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'since': _i1.ParameterDescription(
              name: 'since',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['sensor'] as _i7.SensorEndpoint).getDeviceReadings(
                    session,
                    params['deviceId'],
                    since: params['since'],
                  ),
        ),
      },
    );
  }
}
