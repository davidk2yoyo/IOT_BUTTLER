# IoT Butler - Implementation TODOs

## Prerequisites Setup
- [ ] Install Flutter SDK
- [ ] Install Dart SDK  
- [ ] Install Serverpod CLI: `dart pub global activate serverpod_cli`
- [ ] Install Docker for PostgreSQL

## Backend Setup (Serverpod)
- [ ] Run `./setup.sh` to create Serverpod project
- [ ] Copy models from `serverpod_models/` to `iot_butler_server/lib/src/protocol/`
- [ ] Copy endpoints from `serverpod_implementation/` to `iot_butler_server/lib/src/endpoints/`
- [ ] Copy services from `serverpod_implementation/` to `iot_butler_server/lib/src/services/`
- [ ] Update `iot_butler_server/lib/server.dart` to register endpoints
- [ ] Run `serverpod generate` to generate protocol files
- [ ] Start PostgreSQL: `docker-compose up -d`
- [ ] Run database migration: `dart bin/main.dart --create-migration`
- [ ] Start server: `dart bin/main.dart`

## Frontend Setup (Flutter)
- [ ] Copy Flutter files from `flutter_implementation/` to `iot_butler_flutter/lib/`
- [ ] Add dependencies to `pubspec.yaml`:
  ```yaml
  dependencies:
    flutter:
      sdk: flutter
    http: ^1.1.0
    iot_butler_client:
      path: ../iot_butler_client
  ```
- [ ] Update API service to use Serverpod client instead of mock data
- [ ] Test Flutter app: `flutter run`

## AI Integration (Optional)
- [ ] Get Gemini API key from Google AI Studio
- [ ] Set environment variable: `export GEMINI_API_KEY=your_key_here`
- [ ] Update `butler_service.dart` with your API key
- [ ] Test AI explanations

## Demo Preparation
- [ ] Verify all devices show in Flutter app
- [ ] Confirm sensor data is being generated
- [ ] Test alert creation and Butler explanations
- [ ] Practice 3-minute demo flow

## Production Considerations
- [ ] Add proper error handling
- [ ] Implement authentication
- [ ] Add logging and monitoring
- [ ] Set up proper environment configuration
- [ ] Add unit tests
- [ ] Optimize database queries
- [ ] Add data retention policies

## Demo Script
1. **Open app** → Show device list with status indicators
2. **Wait for alert** → Temperature/voltage threshold exceeded  
3. **Tap device** → Show detail screen with charts and alerts
4. **Tap "Ask Butler"** → AI explains issue and suggests action
5. **Show resolution** → Mark alert as resolved

## Key Features Implemented
✅ Device monitoring dashboard  
✅ Real-time sensor readings with charts  
✅ Smart alerts with threshold detection  
✅ AI-powered explanations (with fallback)  
✅ Clean, professional UI  
✅ Background data simulation  
✅ PostgreSQL data persistence  

## Architecture Highlights
- **Flutter**: Cross-platform mobile/web frontend
- **Serverpod 3**: Type-safe backend with auto-generated client
- **PostgreSQL**: Reliable data storage with ORM
- **Gemini AI**: Natural language explanations (optional)
- **Docker**: Easy database setup and deployment