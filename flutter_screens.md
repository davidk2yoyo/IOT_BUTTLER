# Flutter Screen Structure

## 1. Device List Screen (`DeviceListScreen`)
**Path**: `/`

**Layout**:
```
AppBar: "IoT Butler"
Body:
  - RefreshIndicator
  - ListView of DeviceCard widgets
  
DeviceCard:
  - Device name
  - Location  
  - Status indicator (green/yellow/red dot)
  - Last seen timestamp
  - Tap → Navigate to DeviceDetailScreen
```

## 2. Device Detail Screen (`DeviceDetailScreen`) 
**Path**: `/device/:id`

**Layout**:
```
AppBar: Device name + back button
Body:
  - Device status header
  - Sensor readings section
    - Live values (temp, voltage)
    - Simple line chart (last 24h)
  - Active alerts section
    - Alert cards with severity colors
    - "Ask Butler" button per alert
  - FloatingActionButton: Refresh data
```

## 3. Butler Explanation Dialog (`ButlerDialog`)
**Triggered by**: "Ask Butler" button

**Layout**:
```
Dialog:
  - Butler avatar/icon
  - Explanation text
  - Suggested action
  - "Got it" button
```

## Key Widgets
- `DeviceCard`: Reusable device list item
- `SensorChart`: Simple line chart for readings  
- `AlertCard`: Alert display with severity styling
- `StatusIndicator`: Colored dot for device status