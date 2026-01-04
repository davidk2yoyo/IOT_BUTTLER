#!/usr/bin/env dart

import 'dart:convert';
import 'dart:io';

/// Simple test script to verify IoT Device Integration implementation
void main() async {
  print('🚀 Testing IoT Device Integration Implementation');
  print('=' * 50);
  
  const baseUrl = 'http://localhost:8093';
  
  try {
    // Test 1: Create a device
    print('\n📱 Test 1: Creating a test device...');
    final deviceResponse = await createDevice(baseUrl);
    if (deviceResponse == null) {
      print('❌ Failed to create device');
      return;
    }
    
    final deviceId = deviceResponse['device']['id'].toString();
    final apiKey = deviceResponse['apiKey'] as String;
    
    print('✅ Device created successfully!');
    print('   Device ID: $deviceId');
    print('   API Key: ${apiKey.substring(0, 8)}...');
    
    // Test 2: Send sensor data
    print('\n📊 Test 2: Sending sensor data...');
    final ingestResponse = await sendSensorData(baseUrl, deviceId, apiKey);
    if (ingestResponse == null) {
      print('❌ Failed to send sensor data');
      return;
    }
    
    print('✅ Sensor data sent successfully!');
    print('   Status: ${ingestResponse['status']}');
    print('   Alert Triggered: ${ingestResponse['alertTriggered']}');
    
    // Test 3: Send data that triggers alert
    print('\n🚨 Test 3: Sending data that triggers alert...');
    final alertResponse = await sendSensorData(baseUrl, deviceId, apiKey, value: 100.0);
    if (alertResponse == null) {
      print('❌ Failed to send alert-triggering data');
      return;
    }
    
    print('✅ Alert-triggering data sent successfully!');
    print('   Status: ${alertResponse['status']}');
    print('   Alert Triggered: ${alertResponse['alertTriggered']}');
    
    // Test 4: Get device info
    print('\n🔍 Test 4: Retrieving device information...');
    final deviceInfo = await getDevice(baseUrl, deviceId);
    if (deviceInfo == null) {
      print('❌ Failed to retrieve device information');
      return;
    }
    
    print('✅ Device information retrieved successfully!');
    print('   Name: ${deviceInfo['name']}');
    print('   Status: ${deviceInfo['status']}');
    print('   Last Seen: ${deviceInfo['lastSeen']}');
    
    print('\n🎉 All tests passed! IoT Device Integration is working correctly.');
    
  } catch (e) {
    print('❌ Test failed with error: $e');
  }
}

Future<Map<String, dynamic>?> createDevice(String baseUrl) async {
  try {
    final client = HttpClient();
    final request = await client.postUrl(Uri.parse('$baseUrl/device/createDevice'));
    request.headers.contentType = ContentType.json;
    
    final body = jsonEncode({
      'name': 'Test IoT Device',
      'type': 'temperature',
      'location': 'Test Lab'
    });
    
    request.write(body);
    final response = await request.close();
    
    if (response.statusCode == 200) {
      final responseBody = await response.transform(utf8.decoder).join();
      return jsonDecode(responseBody) as Map<String, dynamic>;
    } else {
      print('   HTTP ${response.statusCode}: ${await response.transform(utf8.decoder).join()}');
      return null;
    }
  } catch (e) {
    print('   Error: $e');
    return null;
  }
}

Future<Map<String, dynamic>?> sendSensorData(
  String baseUrl,
  String deviceId,
  String apiKey, {
  double value = 25.5,
}) async {
  try {
    final client = HttpClient();
    final request = await client.postUrl(Uri.parse('$baseUrl/api/ingest'));
    request.headers.contentType = ContentType.json;
    request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $apiKey');
    
    final body = jsonEncode({
      'deviceId': deviceId,
      'type': 'temperature',
      'value': value
    });
    
    request.write(body);
    final response = await request.close();
    
    if (response.statusCode == 200) {
      final responseBody = await response.transform(utf8.decoder).join();
      return jsonDecode(responseBody) as Map<String, dynamic>;
    } else {
      print('   HTTP ${response.statusCode}: ${await response.transform(utf8.decoder).join()}');
      return null;
    }
  } catch (e) {
    print('   Error: $e');
    return null;
  }
}

Future<Map<String, dynamic>?> getDevice(String baseUrl, String deviceId) async {
  try {
    final client = HttpClient();
    final request = await client.postUrl(Uri.parse('$baseUrl/device/getDevice'));
    request.headers.contentType = ContentType.json;
    
    final body = jsonEncode({
      'deviceId': int.parse(deviceId)
    });
    
    request.write(body);
    final response = await request.close();
    
    if (response.statusCode == 200) {
      final responseBody = await response.transform(utf8.decoder).join();
      return jsonDecode(responseBody) as Map<String, dynamic>;
    } else {
      print('   HTTP ${response.statusCode}: ${await response.transform(utf8.decoder).join()}');
      return null;
    }
  } catch (e) {
    print('   Error: $e');
    return null;
  }
}
