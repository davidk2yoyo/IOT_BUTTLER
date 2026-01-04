import 'package:iot_butler_client/iot_butler_client.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'screens/device_list_screen.dart';

/// Global client object for communicating with the Serverpod server
late final Client client;

void main() {
  // Update the port to match our server configuration (8093)
  const serverUrlFromEnv = String.fromEnvironment('SERVER_URL');
  final serverUrl =
      serverUrlFromEnv.isEmpty ? 'http://localhost:8093/' : serverUrlFromEnv;

  client = Client(serverUrl)
    ..connectivityMonitor = FlutterConnectivityMonitor();

  runApp(const IoTButlerApp());
}

class IoTButlerApp extends StatelessWidget {
  const IoTButlerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IoT Butler',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
      ),
      home: const DeviceListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
