import 'package:flutter/material.dart';
import 'screens/device_list_screen.dart';

void main() {
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