import 'dart:convert';
import 'package:http/http.dart' as http;
import '../generated/protocol.dart';

class ExplanationResult {
  final String explanation;
  final String suggestion;

  ExplanationResult({
    required this.explanation,
    required this.suggestion,
  });
}

class ButlerService {
  static const String _geminiApiKey = 'YOUR_GEMINI_API_KEY'; // TODO: Set from environment
  static const String _geminiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';

  /// Generate AI explanation for an alert
  Future<ExplanationResult> generateExplanation({
    required Alert alert,
    required Device device,
    required List<SensorReading> recentReadings,
    String? additionalContext,
  }) async {
    // Try AI first, fallback to rule-based
    try {
      if (_geminiApiKey != 'YOUR_GEMINI_API_KEY' && _geminiApiKey.isNotEmpty) {
        return await _generateAIExplanation(
          alert: alert,
          device: device,
          recentReadings: recentReadings,
          additionalContext: additionalContext,
        );
      }
    } catch (e) {
      print('AI explanation failed, using fallback: $e');
    }

    // Fallback to rule-based explanations
    return _generateRuleBasedExplanation(
      alert: alert,
      device: device,
      recentReadings: recentReadings,
    );
  }

  /// Generate AI-powered explanation using Gemini
  Future<ExplanationResult> _generateAIExplanation({
    required Alert alert,
    required Device device,
    required List<SensorReading> recentReadings,
    String? additionalContext,
  }) async {
    final prompt = _buildPrompt(
      alert: alert,
      device: device,
      recentReadings: recentReadings,
      additionalContext: additionalContext,
    );

    final response = await http.post(
      Uri.parse('$_geminiUrl?key=$_geminiApiKey'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'contents': [{
          'parts': [{'text': prompt}]
        }],
        'generationConfig': {
          'temperature': 0.7,
          'maxOutputTokens': 500,
        }
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final text = data['candidates'][0]['content']['parts'][0]['text'] as String;
      
      return _parseAIResponse(text);
    } else {
      throw Exception('Gemini API error: ${response.statusCode}');
    }
  }

  /// Generate rule-based explanation as fallback
  ExplanationResult _generateRuleBasedExplanation({
    required Alert alert,
    required Device device,
    required List<SensorReading> recentReadings,
  }) {
    final message = alert.message.toLowerCase();
    final severity = alert.severity.toLowerCase();

    String explanation;
    String suggestion;

    if (message.contains('temperature')) {
      if (severity == 'critical') {
        explanation = "The ${device.name} at ${device.location} is experiencing critical overheating. "
                     "Temperatures above 100°C can cause permanent hardware damage and system failure. "
                     "This requires immediate attention to prevent equipment loss.";
        suggestion = "IMMEDIATE ACTION: Shut down the device if possible. Check cooling systems, "
                    "clear any obstructions, and ensure proper ventilation. Contact maintenance immediately.";
      } else {
        explanation = "The ${device.name} is running warmer than normal operating conditions. "
                     "Extended operation at high temperatures can reduce equipment lifespan and performance. "
                     "This is typically caused by increased workload, poor ventilation, or cooling system issues.";
        suggestion = "Check air conditioning and ventilation systems. Monitor workload and consider "
                    "reducing non-essential operations. Schedule maintenance check if issue persists.";
      }
    } else if (message.contains('voltage')) {
      if (severity == 'critical') {
        explanation = "The ${device.name} is experiencing critically low voltage levels. "
                     "Voltage below 9V can cause system instability, data corruption, and unexpected shutdowns. "
                     "This indicates a serious power supply or electrical system problem.";
        suggestion = "IMMEDIATE ACTION: Check power connections and electrical panel. "
                    "Contact electrician if voltage issues persist. Consider backup power if available.";
      } else {
        explanation = "The ${device.name} is receiving lower than optimal voltage. "
                     "This can cause reduced performance and potential reliability issues over time. "
                     "May indicate power supply degradation or electrical load issues.";
        suggestion = "Check power connections and electrical panel. Monitor voltage trends and "
                    "schedule electrical system inspection if levels continue to drop.";
      }
    } else if (message.contains('offline')) {
      explanation = "The ${device.name} has lost communication and appears offline. "
                   "This could be due to network connectivity issues, power failure, hardware malfunction, "
                   "or software problems. Extended offline periods prevent monitoring and control.";
      suggestion = "Check device power and network connections. Attempt to restart the device. "
                  "Verify network infrastructure and contact IT support if connectivity issues persist.";
    } else {
      explanation = "An issue has been detected with the ${device.name} that requires attention. "
                   "The system has flagged this as ${severity} priority based on current readings and thresholds.";
      suggestion = "Review device status and recent readings. Check physical connections and "
                  "contact support if the issue persists or worsens.";
    }

    return ExplanationResult(
      explanation: explanation,
      suggestion: suggestion,
    );
  }

  /// Build prompt for AI explanation
  String _buildPrompt({
    required Alert alert,
    required Device device,
    required List<SensorReading> recentReadings,
    String? additionalContext,
  }) {
    final readingsText = recentReadings.map((r) => 
      '${r.type}: ${r.value}${r.unit} at ${r.timestamp}'
    ).join('\n');

    return '''
You are an IoT Butler, an expert system for explaining device issues in plain language.

DEVICE INFO:
- Name: ${device.name}
- Location: ${device.location}
- Status: ${device.status}

ALERT:
- Severity: ${alert.severity}
- Message: ${alert.message}
- Time: ${alert.createdAt}

RECENT SENSOR READINGS:
$readingsText

${additionalContext != null ? 'ADDITIONAL CONTEXT:\n$additionalContext\n' : ''}

Please provide:
1. EXPLANATION: What is happening and why (2-3 sentences, technical but accessible)
2. SUGGESTION: Specific actionable steps to resolve the issue (2-3 sentences)

Format your response as:
EXPLANATION: [your explanation]
SUGGESTION: [your suggestion]

Keep it concise, practical, and focused on helping operators understand and act.
''';
  }

  /// Parse AI response into structured format
  ExplanationResult _parseAIResponse(String response) {
    final lines = response.split('\n');
    String explanation = '';
    String suggestion = '';

    String currentSection = '';
    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.startsWith('EXPLANATION:')) {
        currentSection = 'explanation';
        explanation = trimmed.substring('EXPLANATION:'.length).trim();
      } else if (trimmed.startsWith('SUGGESTION:')) {
        currentSection = 'suggestion';
        suggestion = trimmed.substring('SUGGESTION:'.length).trim();
      } else if (trimmed.isNotEmpty) {
        if (currentSection == 'explanation') {
          explanation += ' $trimmed';
        } else if (currentSection == 'suggestion') {
          suggestion += ' $trimmed';
        }
      }
    }

    // Fallback if parsing fails
    if (explanation.isEmpty || suggestion.isEmpty) {
      final parts = response.split('SUGGESTION:');
      if (parts.length >= 2) {
        explanation = parts[0].replaceAll('EXPLANATION:', '').trim();
        suggestion = parts[1].trim();
      } else {
        explanation = response.trim();
        suggestion = 'Please review the device status and contact support if needed.';
      }
    }

    return ExplanationResult(
      explanation: explanation,
      suggestion: suggestion,
    );
  }

  /// Answer custom questions about devices
  Future<String> answerQuestion({
    required String question,
    required Device device,
    required List<SensorReading> recentReadings,
    required List<Alert> activeAlerts,
  }) async {
    // Simple rule-based responses for common questions
    final q = question.toLowerCase();
    
    if (q.contains('status') || q.contains('how') && q.contains('doing')) {
      return _getDeviceStatusSummary(device, recentReadings, activeAlerts);
    } else if (q.contains('temperature')) {
      return _getTemperatureInfo(recentReadings);
    } else if (q.contains('voltage')) {
      return _getVoltageInfo(recentReadings);
    } else if (q.contains('alert') || q.contains('problem')) {
      return _getAlertSummary(activeAlerts);
    } else {
      return "I can help you understand device status, sensor readings, and alerts. "
             "Try asking about the device status, temperature, voltage, or current alerts.";
    }
  }

  String _getDeviceStatusSummary(Device device, List<SensorReading> readings, List<Alert> alerts) {
    final status = device.status;
    final alertCount = alerts.length;
    
    String summary = "The ${device.name} is currently $status";
    
    if (alertCount > 0) {
      summary += " with $alertCount active alert${alertCount > 1 ? 's' : ''}";
    } else {
      summary += " with no active alerts";
    }
    
    if (readings.isNotEmpty) {
      final latest = readings.first;
      summary += ". Latest reading: ${latest.type} at ${latest.value}${latest.unit}";
    }
    
    return "$summary.";
  }

  String _getTemperatureInfo(List<SensorReading> readings) {
    final tempReadings = readings.where((r) => r.type == 'temperature').toList();
    if (tempReadings.isEmpty) {
      return "No temperature readings available.";
    }
    
    final latest = tempReadings.first;
    return "Current temperature is ${latest.value}°C. "
           "${latest.value > 80 ? 'This is above normal operating range.' : 'This is within normal range.'}";
  }

  String _getVoltageInfo(List<SensorReading> readings) {
    final voltageReadings = readings.where((r) => r.type == 'voltage').toList();
    if (voltageReadings.isEmpty) {
      return "No voltage readings available.";
    }
    
    final latest = voltageReadings.first;
    return "Current voltage is ${latest.value}V. "
           "${latest.value < 10 ? 'This is below optimal operating voltage.' : 'This is within normal range.'}";
  }

  String _getAlertSummary(List<Alert> alerts) {
    if (alerts.isEmpty) {
      return "No active alerts. The device is operating normally.";
    }
    
    final critical = alerts.where((a) => a.severity == 'critical').length;
    final warning = alerts.where((a) => a.severity == 'warning').length;
    
    String summary = "There are ${alerts.length} active alert${alerts.length > 1 ? 's' : ''}";
    if (critical > 0) summary += " ($critical critical";
    if (warning > 0) summary += critical > 0 ? ", $warning warning)" : " ($warning warning)";
    if (critical == 0 && warning == 0) summary += ")";
    
    return "$summary. ${alerts.first.message}";
  }
}