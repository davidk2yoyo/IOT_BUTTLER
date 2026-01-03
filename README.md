# IoT Butler - Smart Device Supervisor

A modern Flutter + Serverpod application for monitoring IoT devices with AI-powered explanations and beautiful UI.

## 🚀 Quick Start

### Prerequisites

- **Flutter SDK** (3.24.0 or higher)
- **Dart SDK** (3.5.0 or higher)
- **Docker** and **Docker Compose**
- **Serverpod CLI**: `dart pub global activate serverpod_cli`

### Installation & Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/davidk2yoyo/IOT_BUTTLER.git
   cd IOT_BUTTLER
   ```

2. **Start the database**
   ```bash
   docker compose up -d
   ```

3. **Set up the Serverpod project** (if not already done)
   ```bash
   ./setup.sh
   ```

4. **Start the backend server**
   ```bash
   cd iot_butler/iot_butler_server
   dart bin/main.dart --apply-migrations
   ```

5. **Start the Flutter app** (in a new terminal)
   ```bash
   cd iot_butler/iot_butler_flutter
   flutter pub get
   flutter run
   ```

6. **Choose your platform**
   - Select `2` for Chrome (web browser)
   - Select `1` for Linux desktop app

## 🏗️ Architecture

```
IoT Butler/
├── iot_butler_server/     # Serverpod backend (Dart)
├── iot_butler_flutter/    # Flutter frontend
├── iot_butler_client/     # Generated client library
└── docker-compose.yaml    # PostgreSQL & Redis
```

**Tech Stack:**
- **Frontend**: Flutter with Material 3 design
- **Backend**: Serverpod 3 (Dart server framework)
- **Database**: PostgreSQL
- **Cache**: Redis
- **AI**: Gemini API integration (optional)

## 🎯 Features

### Device Management
- ✅ Beautiful device dashboard with modern UI
- ✅ Add new IoT devices with form validation
- ✅ Real-time device status monitoring
- ✅ Device type categorization (sensors, solar, cameras, etc.)

### Monitoring & Alerts
- ✅ Live sensor readings with charts
- ✅ Smart alert system with severity levels
- ✅ AI-powered explanations for device issues
- ✅ Suggested actions for problem resolution

### Real IoT Device Integration
- ✅ **Secure HTTPS data ingest API** for real IoT devices
- ✅ **API-key based authentication** with cryptographic security
- ✅ **Vendor-agnostic integration** - works with any device that supports HTTP
- ✅ **Explicit device registration** - no auto-registration during data ingest
- ✅ **Real-time status updates** - devices show online/offline/warning states
- ✅ **Alert threshold monitoring** - automatic alerts when sensor values exceed limits
- ✅ **Multi-environment support** - works on localhost and production cloud

### User Experience
- ✅ Modern gradient design with smooth animations
- ✅ Responsive layout for web and desktop
- ✅ Empty states with clear call-to-actions
- ✅ Loading states and error handling

## 🌐 Real IoT Device Integration

IoT Butler uses a secure HTTPS ingest API that allows real IoT devices to send sensor data. Devices must be registered first and authenticate using an API key. Any IoT device, script, or vendor platform that supports HTTP requests can integrate without vendor-specific SDKs or direct network access.

### Key Features:
- **Secure Authentication**: Each device gets a unique, cryptographically secure API key
- **Vendor Agnostic**: Works with any device or service that can make HTTP requests
- **Real-time Updates**: Device status and sensor readings update immediately in the Flutter dashboard
- **Alert Integration**: Automatic threshold monitoring with configurable limits
- **Production Ready**: Same code works on localhost and cloud deployments

### Quick Integration Example:

1. **Register a device** through the Flutter app to get an API key
2. **Send sensor data** from your IoT device:

```bash
curl -X POST http://localhost:8093/ingest/ingest \
  -H "Content-Type: application/json" \
  -d '{
    "request": {
      "deviceId": "1:YOUR_API_KEY_HERE",
      "type": "temperature",
      "value": 23.5
    }
  }'
```

3. **See real-time updates** in the Flutter dashboard - device status changes to "online" and charts update with new data

### Supported Sensor Types:
- **Temperature** (-10°C to 50°C alert thresholds)
- **Humidity** (10% to 90% alert thresholds)  
- **Voltage** (3.0V to 5.5V alert thresholds)
- **Custom** (0 to 100 generic range)

### Error Handling:
- Invalid API keys return HTTP 401
- Missing fields return HTTP 400 with descriptive messages
- Device not found returns HTTP 404
- All errors include JSON responses with error details

For complete integration examples and testing commands, see [curl_examples.md](curl_examples.md).

## 🖥️ Screenshots

The app features a modern, professional interface with:
- Gradient app bars with custom logo
- Beautiful device cards with status indicators
- Comprehensive device detail views
- AI-powered butler explanations
- Intuitive add device workflow

## 🔧 Development

### Running in Development Mode

1. **Backend** (Terminal 1):
   ```bash
   cd iot_butler/iot_butler_server
   dart bin/main.dart
   ```

2. **Frontend** (Terminal 2):
   ```bash
   cd iot_butler/iot_butler_flutter
   flutter run
   ```

### Database Management

- **View logs**: `docker compose logs postgres`
- **Reset database**: `docker compose down -v && docker compose up -d`
- **Access database**: `docker exec -it iot_butler_db psql -U postgres -d iot_butler`

### Adding New Features

1. **Backend endpoints**: Add to `iot_butler_server/lib/src/endpoints/`
2. **Data models**: Define in `iot_butler_server/lib/src/protocol/`
3. **Frontend screens**: Add to `iot_butler_flutter/lib/screens/`
4. **Widgets**: Create in `iot_butler_flutter/lib/widgets/`

## 🌐 Deployment

### Local Development
- Backend runs on `http://localhost:8090`
- Frontend connects automatically to local backend

### Production Deployment
1. Deploy Serverpod server to cloud provider (GCP, AWS, etc.)
2. Update Flutter app's server URL
3. Build Flutter for web: `flutter build web`

## 🛠️ Troubleshooting

### Common Issues

**Port 8080 already in use:**
- The app now uses port 8090 by default
- Check `iot_butler_server/config/development.yaml`

**Database connection failed:**
- Ensure Docker is running: `docker ps`
- Check database password in `config/passwords.yaml`

**Flutter compilation errors:**
- Run `flutter clean && flutter pub get`
- Ensure Flutter SDK is up to date

**Serverpod command not found:**
- Install: `dart pub global activate serverpod_cli`
- Add to PATH: `export PATH="$PATH":"$HOME/.pub-cache/bin"`

## 📱 Supported Platforms

- ✅ **Web** (Chrome, Firefox, Safari)
- ✅ **Linux Desktop**
- ✅ **macOS Desktop** (with Flutter desktop support)
- ✅ **Windows Desktop** (with Flutter desktop support)
- 🔄 **Mobile** (iOS/Android - requires additional setup)

## 🤝 Contributing

This is a hackathon project. Feel free to:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📄 License

This project is open source and available under the MIT License.

---

**Built for hackathons and IoT enthusiasts** 🚀