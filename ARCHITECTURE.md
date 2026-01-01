# IoT Butler - System Architecture

## Overview
IoT Butler is a smart device monitoring system built with Flutter (frontend) and Serverpod 3 (backend). It provides real-time device monitoring, intelligent alerting, and AI-powered explanations.

## Architecture Diagram (Textual)
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Flutter App   │    │  Serverpod 3    │    │   PostgreSQL    │
│                 │    │    Backend      │    │    Database     │
│ ┌─────────────┐ │    │ ┌─────────────┐ │    │ ┌─────────────┐ │
│ │Device List  │ │◄──►│ │Device       │ │◄──►│ │devices      │ │
│ │Screen       │ │    │ │Endpoint     │ │    │ │table        │ │
│ └─────────────┘ │    │ └─────────────┘ │    │ └─────────────┘ │
│ ┌─────────────┐ │    │ ┌─────────────┐ │    │ ┌─────────────┐ │
│ │Device Detail│ │◄──►│ │Sensor       │ │◄──►│ │sensor_      │ │
│ │Screen       │ │    │ │Endpoint     │ │    │ │readings     │ │
│ └─────────────┘ │    │ └─────────────┘ │    │ └─────────────┘ │
│ ┌─────────────┐ │    │ ┌─────────────┐ │    │ ┌─────────────┐ │
│ │Butler Dialog│ │◄──►│ │Butler       │ │◄──►│ │alerts       │ │
│ │             │ │    │ │Endpoint     │ │    │ │table        │ │
│ └─────────────┘ │    │ └─────────────┘ │    │ └─────────────┘ │
└─────────────────┘    │ ┌─────────────┐ │    │ ┌─────────────┐ │
                       │ │Data         │ │    │ │butler_      │ │
┌─────────────────┐    │ │Simulator    │ │    │ │explanations │ │
│   Gemini API    │◄──►│ │Service      │ │    │ └─────────────┘ │
│                 │    │ └─────────────┘ │    └─────────────────┘
└─────────────────┘    └─────────────────┘
```

## Component Details

### Frontend (Flutter)
**Technology**: Flutter 3.x with Material Design 3
**Responsibilities**:
- Device list and detail views
- Real-time sensor data visualization
- Alert management interface
- Butler AI interaction

**Key Screens**:
- `DeviceListScreen`: Overview of all devices with status
- `DeviceDetailScreen`: Detailed view with charts and alerts
- `ButlerDialog`: AI explanation interface

### Backend (Serverpod 3)
**Technology**: Serverpod 3.x with PostgreSQL
**Responsibilities**:
- Device registry and management
- Sensor data collection and storage
- Alert generation and management
- AI integration for explanations

**Key Endpoints**:
- `DeviceEndpoint`: CRUD operations for devices
- `SensorEndpoint`: Sensor data management
- `AlertEndpoint`: Alert handling
- `ButlerEndpoint`: AI explanation service

### Database (PostgreSQL)
**Technology**: PostgreSQL 15+ via Serverpod ORM
**Tables**:
- `devices`: Device registry with status
- `sensor_readings`: Time-series sensor data
- `alerts`: Alert management with severity
- `butler_explanations`: AI-generated explanations

### AI Integration (Optional)
**Technology**: Google Gemini API
**Fallback**: Rule-based explanations
**Purpose**: Generate human-readable explanations for alerts

## Data Flow

### 1. Device Monitoring
```
Data Simulator → Sensor Readings → Database → Flutter Charts
```

### 2. Alert Generation
```
Sensor Thresholds → Alert Creation → Database → Flutter Notifications
```

### 3. Butler Explanations
```
Alert Context → Gemini API → AI Response → Butler Dialog
```

## Key Design Decisions

### 1. Serverpod 3 Choice
- **Type Safety**: Auto-generated client ensures type consistency
- **Real-time**: Built-in WebSocket support for live updates
- **Developer Experience**: Hot reload for both frontend and backend
- **Scalability**: Production-ready with clustering support

### 2. Data Simulation
- **No Hardware Dependency**: Works without physical IoT devices
- **Realistic Patterns**: Gaussian distribution with time-based variations
- **Configurable Thresholds**: Easy to trigger alerts for demos

### 3. AI Integration Strategy
- **Optional Dependency**: Works with or without AI
- **Graceful Fallback**: Rule-based explanations when AI unavailable
- **Context-Aware**: Includes device info and sensor history

### 4. Flutter Architecture
- **Clean Separation**: Services handle API communication
- **Reusable Widgets**: Modular components for consistency
- **State Management**: Simple setState for demo simplicity

## Performance Considerations

### Backend
- **Database Indexing**: Optimized queries for time-series data
- **Connection Pooling**: Efficient database connections
- **Background Tasks**: Non-blocking data simulation

### Frontend
- **Lazy Loading**: Charts load data on demand
- **Efficient Updates**: Minimal rebuilds with targeted setState
- **Caching**: API responses cached for offline viewing

## Security Features

### Authentication (Future)
- JWT tokens for API access
- Role-based permissions
- Secure API key management

### Data Protection
- Input validation on all endpoints
- SQL injection prevention via ORM
- Rate limiting for AI API calls

## Deployment Architecture

### Development
```
Local Flutter → Local Serverpod → Local PostgreSQL
```

### Production (Recommended)
```
Flutter Web/Mobile → Cloud Serverpod → Managed PostgreSQL
```

## Monitoring and Observability

### Logging
- Structured logging with Serverpod
- Error tracking and alerting
- Performance metrics

### Health Checks
- Database connectivity monitoring
- API endpoint health checks
- AI service availability

## Scalability Considerations

### Horizontal Scaling
- Stateless Serverpod instances
- Load balancer distribution
- Database read replicas

### Data Management
- Time-series data partitioning
- Automated data archival
- Efficient indexing strategies

This architecture provides a solid foundation for a hackathon demo while being extensible for production use.