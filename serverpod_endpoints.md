# Serverpod 3 Endpoints

## Device Management

### `GET /devices`
Returns list of all devices with current status
```dart
Future<List<Device>> getDevices()
```

### `GET /device/{id}`  
Returns device details with latest sensor readings
```dart
Future<Device?> getDevice(int deviceId)
```

### `POST /device`
Register new device
```dart
Future<Device> createDevice(String name, String location)
```

## Sensor Data

### `GET /device/{id}/readings`
Get sensor readings for device (last 24h by default)
```dart
Future<List<SensorReading>> getDeviceReadings(
  int deviceId, 
  {DateTime? since}
)
```

### `POST /reading`
Add new sensor reading (for simulation)
```dart
Future<SensorReading> addReading(
  int deviceId,
  String type, 
  double value,
  String unit
)
```

## Alerts

### `GET /device/{id}/alerts`
Get active alerts for device
```dart
Future<List<Alert>> getDeviceAlerts(int deviceId)
```

### `POST /alert/{id}/resolve`
Mark alert as resolved
```dart
Future<void> resolveAlert(int alertId)
```

## Butler AI

### `POST /butler/explain`
Get AI explanation for alert
```dart
Future<ButlerExplanation> explainAlert(
  int alertId,
  {String? context}
)
```

## Background Services

### Data Simulator
Periodically generates sensor readings and triggers alerts
- Runs every 30 seconds
- Creates realistic temperature/voltage data
- Triggers alerts based on thresholds

### Alert Engine  
Monitors sensor readings and creates alerts
- Temperature > 80°C → Warning
- Temperature > 100°C → Critical
- Voltage < 10V → Warning