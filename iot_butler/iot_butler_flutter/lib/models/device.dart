class Device {
  final int id;
  final String name;
  final String location;
  final String status; // online, warning, offline
  final DateTime createdAt;
  final DateTime updatedAt;

  Device({
    required this.id,
    required this.name,
    required this.location,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'] as int,
      name: json['name'] as String,
      location: json['location'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class SensorReading {
  final int id;
  final int deviceId;
  final String type; // temperature, voltage, humidity
  final double value;
  final String unit; // °C, V, %
  final DateTime timestamp;

  SensorReading({
    required this.id,
    required this.deviceId,
    required this.type,
    required this.value,
    required this.unit,
    required this.timestamp,
  });

  factory SensorReading.fromJson(Map<String, dynamic> json) {
    return SensorReading(
      id: json['id'] as int,
      deviceId: json['deviceId'] as int,
      type: json['type'] as String,
      value: (json['value'] as num).toDouble(),
      unit: json['unit'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}

class Alert {
  final int id;
  final int deviceId;
  final String severity; // info, warning, critical
  final String message;
  final bool resolved;
  final DateTime createdAt;
  final DateTime? resolvedAt;

  Alert({
    required this.id,
    required this.deviceId,
    required this.severity,
    required this.message,
    required this.resolved,
    required this.createdAt,
    this.resolvedAt,
  });

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      id: json['id'] as int,
      deviceId: json['deviceId'] as int,
      severity: json['severity'] as String,
      message: json['message'] as String,
      resolved: json['resolved'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      resolvedAt: json['resolvedAt'] != null 
          ? DateTime.parse(json['resolvedAt'] as String)
          : null,
    );
  }
}

class ButlerExplanation {
  final int id;
  final int alertId;
  final String explanation;
  final String suggestion;
  final DateTime createdAt;

  ButlerExplanation({
    required this.id,
    required this.alertId,
    required this.explanation,
    required this.suggestion,
    required this.createdAt,
  });

  factory ButlerExplanation.fromJson(Map<String, dynamic> json) {
    return ButlerExplanation(
      id: json['id'] as int,
      alertId: json['alertId'] as int,
      explanation: json['explanation'] as String,
      suggestion: json['suggestion'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}