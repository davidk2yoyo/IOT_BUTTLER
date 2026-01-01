# IoT Butler Project Structure

## Prerequisites
1. Install Flutter SDK: https://docs.flutter.dev/get-started/install
2. Install Dart SDK (comes with Flutter)
3. Install Serverpod CLI: `dart pub global activate serverpod_cli`

## Generated Structure (after running setup.sh)
```
iot_butler/
├── iot_butler_server/           # Serverpod backend
│   ├── lib/
│   │   ├── src/
│   │   │   ├── endpoints/       # API endpoints
│   │   │   │   ├── device_endpoint.dart
│   │   │   │   ├── sensor_endpoint.dart  
│   │   │   │   ├── alert_endpoint.dart
│   │   │   │   └── butler_endpoint.dart
│   │   │   ├── generated/       # Auto-generated models
│   │   │   └── services/        # Business logic
│   │   │       ├── data_simulator.dart
│   │   │       ├── alert_engine.dart
│   │   │       └── butler_service.dart
│   │   └── server.dart
│   ├── migrations/              # Database migrations
│   ├── config/                  # Server configuration
│   └── pubspec.yaml
├── iot_butler_flutter/          # Flutter frontend
│   ├── lib/
│   │   ├── main.dart
│   │   ├── screens/
│   │   │   ├── device_list_screen.dart
│   │   │   └── device_detail_screen.dart
│   │   ├── widgets/
│   │   │   ├── device_card.dart
│   │   │   ├── sensor_chart.dart
│   │   │   ├── alert_card.dart
│   │   │   └── butler_dialog.dart
│   │   ├── services/
│   │   │   └── api_service.dart
│   │   └── models/              # Local models
│   └── pubspec.yaml
├── iot_butler_client/           # Generated client library
└── docker-compose.yaml         # PostgreSQL setup
```

## Key Files to Implement

### Backend (Serverpod)
1. **Data Models** (`lib/src/protocol/`)
   - device.spy
   - sensor_reading.spy  
   - alert.spy
   - butler_explanation.spy

2. **Endpoints** (`lib/src/endpoints/`)
   - Device CRUD operations
   - Sensor data management
   - Alert handling
   - Butler AI integration

3. **Services** (`lib/src/services/`)
   - Background data simulation
   - Alert threshold monitoring
   - Gemini API integration

### Frontend (Flutter)
1. **Screens**
   - Device list with status indicators
   - Device detail with charts and alerts
   
2. **Widgets**
   - Reusable components for clean UI
   
3. **Services**
   - API client for Serverpod communication