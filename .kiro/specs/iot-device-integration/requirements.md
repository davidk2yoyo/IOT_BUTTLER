# Requirements Document

## Introduction

IoT Butler currently uses simulated sensor data and lacks real IoT device integration. This feature will implement a secure, vendor-agnostic IoT integration system that allows real devices to send data to the Serverpod backend through explicit device registration and API-key based authentication. The system must maintain strict architectural boundaries where IoT devices communicate only with the backend, never directly with the Flutter application.

## Glossary

- **IoT_Device**: A physical or virtual device that collects sensor data and sends it to the system
- **Device_Registry**: The system component that manages registered devices and their API keys
- **Ingest_API**: The HTTPS endpoint that receives sensor data from registered IoT devices
- **API_Key**: A unique authentication token generated for each registered device
- **Sensor_Reading**: A data point containing device ID, sensor type, value, and timestamp
- **Device_Status**: The current operational state of a device (offline, online, warning)
- **Alert_Engine**: The system component that evaluates sensor readings against thresholds

## Requirements

### Requirement 1: Device Registration Management

**User Story:** As a user, I want to register IoT devices through the Flutter app, so that I can securely connect real devices to send sensor data.

#### Acceptance Criteria

1. WHEN a user adds a device through the Flutter app, THE Device_Registry SHALL create a new device record with a unique API key
2. WHEN a device is created, THE Device_Registry SHALL generate a cryptographically secure API key for authentication
3. WHEN a device is registered, THE Device_Registry SHALL set the initial device status to offline
4. WHEN an API key is generated, THE Device_Registry SHALL return it once to the client for device configuration
5. THE Device_Registry SHALL store device information including id, name, type, location, apiKey, status, and lastSeen timestamp

### Requirement 2: Secure Data Ingest API

**User Story:** As an IoT device, I want to send sensor data securely to the backend, so that my readings are recorded and processed for monitoring.

#### Acceptance Criteria

1. THE Ingest_API SHALL accept POST requests at the /api/ingest endpoint with HTTPS protocol
2. WHEN receiving a request, THE Ingest_API SHALL validate the Authorization header contains a Bearer token
3. WHEN processing ingest requests, THE Ingest_API SHALL validate JSON payload structure contains deviceId, type, and value fields
4. THE Ingest_API SHALL authenticate requests using the provided API key against registered devices
5. WHEN authentication succeeds, THE Ingest_API SHALL store the sensor reading in PostgreSQL database

### Requirement 3: Device Authentication and Authorization

**User Story:** As a system administrator, I want only registered devices to send data, so that unauthorized devices cannot inject false sensor readings.

#### Acceptance Criteria

1. WHEN an ingest request is received, THE Ingest_API SHALL verify the API key matches a registered device
2. WHEN an API key is invalid, THE Ingest_API SHALL reject the request with HTTP 401 status
3. WHEN a device is not found for the provided deviceId and API key combination, THE Ingest_API SHALL reject the request with HTTP 404 status
4. THE Ingest_API SHALL never automatically create devices during data ingest
5. WHEN authentication fails, THE Ingest_API SHALL log the failed attempt for security monitoring

### Requirement 4: Device Status Management

**User Story:** As a user, I want to see real-time device status updates, so that I can monitor which devices are actively sending data.

#### Acceptance Criteria

1. WHEN a device successfully sends data, THE Ingest_API SHALL update the device status to online
2. WHEN sensor data is received, THE Ingest_API SHALL update the device lastSeen timestamp
3. WHEN sensor readings exceed alert thresholds, THE Ingest_API SHALL update device status to warning
4. THE Ingest_API SHALL maintain device status consistency across all ingest operations
5. WHEN device status changes, THE Flutter_App SHALL reflect the updated status in the dashboard

### Requirement 5: Error Handling and Response Management

**User Story:** As an IoT device developer, I want clear error responses from the API, so that I can troubleshoot integration issues effectively.

#### Acceptance Criteria

1. WHEN JSON payload is malformed or missing required fields, THE Ingest_API SHALL return HTTP 400 with descriptive error message
2. WHEN API key authentication fails, THE Ingest_API SHALL return HTTP 401 with authentication error
3. WHEN a device is not found, THE Ingest_API SHALL return HTTP 404 with device not found error
4. WHEN internal server errors occur, THE Ingest_API SHALL return HTTP 500 with generic error message
5. WHEN ingest succeeds, THE Ingest_API SHALL return HTTP 200 with success status and alert information

### Requirement 6: Alert Processing Integration

**User Story:** As a user, I want alerts to trigger immediately when devices send readings that exceed thresholds, so that I can respond quickly to critical conditions.

#### Acceptance Criteria

1. WHEN sensor data is ingested, THE Alert_Engine SHALL evaluate the reading against configured thresholds
2. WHEN thresholds are exceeded, THE Alert_Engine SHALL trigger appropriate alerts in the system
3. WHEN alerts are triggered, THE Ingest_API SHALL include alert status in the response to the device
4. THE Alert_Engine SHALL process alerts using the existing alert logic without modification
5. WHEN alerts are generated, THE Flutter_App SHALL display them immediately in the user interface

### Requirement 7: Multi-Environment Compatibility

**User Story:** As a developer, I want the same IoT integration code to work in both local development and production environments, so that testing and deployment are consistent.

#### Acceptance Criteria

1. THE Ingest_API SHALL work identically on localhost:8090 and iot-buttler.serverpod.space
2. WHEN environment changes, THE Ingest_API SHALL require only base URL configuration changes
3. THE Ingest_API SHALL maintain the same endpoint paths and authentication across all environments
4. WHEN deployed to different environments, THE Ingest_API SHALL preserve all security and validation behaviors
5. THE Flutter_App SHALL connect to the appropriate backend environment without code changes

### Requirement 8: Testing and Documentation Support

**User Story:** As a judge or evaluator, I want working examples and clear documentation, so that I can easily test the IoT integration functionality.

#### Acceptance Criteria

1. THE System SHALL provide working curl command examples for testing the ingest API
2. WHEN test requests are sent, THE System SHALL demonstrate device status updates in the Flutter dashboard
3. WHEN test data exceeds thresholds, THE System SHALL show alert triggering functionality
4. THE Documentation SHALL include clear instructions for IoT device integration
5. THE System SHALL support testing without requiring physical IoT hardware