# IoT Device Integration - cURL Examples

This document provides working examples for testing the IoT Device Integration feature using cURL commands.

## Prerequisites

1. Ensure the Serverpod server is running on `http://localhost:8093`
2. Database migrations have been applied
3. Docker containers for PostgreSQL are running

## Example 1: Create a Device

First, create a device to get an API key:

```bash
curl -X POST http://localhost:8093/device/createDevice \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Judge Test Device",
    "type": "temperature", 
    "location": "Demo Lab"
  }'
```

**Expected Response:**
```json
{
  "device": {
    "id": 1,
    "name": "Judge Test Device",
    "type": "temperature",
    "location": "Demo Lab",
    "status": "offline",
    "lastSeen": null,
    "createdAt": "2026-01-03T07:00:00.000Z",
    "updatedAt": "2026-01-03T07:00:00.000Z"
  },
  "apiKey": "GP9ZwgPkMpiVmairXYZ123..."
}
```

**Important:** Copy the `apiKey` value - you'll need it for data ingestion.

## Example 2: Send Sensor Data

Use the device ID and API key from the previous step:

```bash
curl -X POST http://localhost:8093/ingest/ingest \
  -H "Content-Type: application/json" \
  -d '{
    "request": {
      "deviceId": "1:GP9ZwgPkMpiVmairXYZ123...",
      "type": "temperature",
      "value": 23.5
    }
  }'
```

**Expected Response:**
```json
{
  "status": "ok",
  "alertTriggered": false
}
```

This request will:
- Mark the device as `online`
- Update the `lastSeen` timestamp
- Store the sensor reading in the database
- Evaluate alert thresholds

## Example 3: Trigger an Alert

Send a value that exceeds the temperature threshold (>50°C):

```bash
curl -X POST http://localhost:8093/ingest/ingest \
  -H "Content-Type: application/json" \
  -d '{
    "request": {
      "deviceId": "1:GP9ZwgPkMpiVmairXYZ123...",
      "type": "temperature",
      "value": 85.5
    }
  }'
```

**Expected Response:**
```json
{
  "status": "ok",
  "alertTriggered": true
}
```

This request will:
- Mark the device status as `warning`
- Trigger an alert in the system
- Update charts in the Flutter app
- Store the reading with `alertTriggered: true`

## Example 4: Check Device Status

Verify the device status after sending data:

```bash
curl -X POST http://localhost:8093/device/getDevice \
  -H "Content-Type: application/json" \
  -d '{
    "deviceId": 1
  }'
```

**Expected Response:**
```json
{
  "id": 1,
  "name": "Judge Test Device",
  "type": "temperature",
  "location": "Demo Lab",
  "status": "warning",
  "lastSeen": "2026-01-03T07:02:36.059247Z",
  "createdAt": "2026-01-03T07:00:00.000Z",
  "updatedAt": "2026-01-03T07:02:36.059247Z"
}
```

## Error Examples

### Invalid API Key
```bash
curl -X POST http://localhost:8093/ingest/ingest \
  -H "Content-Type: application/json" \
  -d '{
    "request": {
      "deviceId": "1:invalid-api-key",
      "type": "temperature",
      "value": 25.0
    }
  }'
```

**Response (HTTP 200):**
```json
{
  "status": "error",
  "alertTriggered": false,
  "errorMessage": "Invalid authentication"
}
```

### Missing Required Fields
```bash
curl -X POST http://localhost:8093/ingest/ingest \
  -H "Content-Type: application/json" \
  -d '{
    "request": {
      "deviceId": "1:GP9ZwgPkMpiVmairXYZ123...",
      "type": "temperature"
    }
  }'
```

**Response (HTTP 200):**
```json
{
  "status": "error",
  "alertTriggered": false,
  "errorMessage": "Missing required field: value"
}
```

## Sensor Types and Thresholds

The system supports the following sensor types with default alert thresholds:

- **temperature**: -10°C to 50°C
- **humidity**: 10% to 90%
- **voltage**: 3.0V to 5.5V
- **custom**: 0 to 100 (generic range)

## Integration Notes

1. **Device ID Format**: Currently using `deviceId:apiKey` format for simplicity. In production, this would use proper HTTP Authorization headers.

2. **Real-time Updates**: The Flutter dashboard automatically reflects device status changes when data is ingested.

3. **Multi-environment**: The same endpoints work on both `http://localhost:8093` and `https://iot-buttler.serverpod.space` (production).

4. **Security**: API keys are cryptographically secure and hashed in the database. Each device gets a unique key during registration.

## Testing Checklist

- [ ] Device creation returns unique API key
- [ ] Sensor data ingestion updates device status to "online"
- [ ] Alert thresholds trigger status change to "warning"
- [ ] Invalid API keys are rejected
- [ ] Missing fields return appropriate error messages
- [ ] Device status can be retrieved after data ingestion
- [ ] Flutter dashboard reflects real-time changes