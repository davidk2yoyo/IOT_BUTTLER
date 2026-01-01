import 'package:flutter/material.dart';
import '../models/device.dart';

class SensorChart extends StatelessWidget {
  final List<SensorReading> readings;

  const SensorChart({
    super.key,
    required this.readings,
  });

  @override
  Widget build(BuildContext context) {
    if (readings.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No data available for chart'),
        ),
      );
    }

    // Group readings by type
    final Map<String, List<SensorReading>> groupedReadings = {};
    for (final reading in readings) {
      groupedReadings.putIfAbsent(reading.type, () => []).add(reading);
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sensor Trends (Last 24h)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            // Simple chart representation
            ...groupedReadings.entries.map((entry) {
              final type = entry.key;
              final typeReadings = entry.value;
              typeReadings.sort((a, b) => a.timestamp.compareTo(b.timestamp));
              
              return _buildSimpleChart(type, typeReadings);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleChart(String type, List<SensorReading> readings) {
    if (readings.isEmpty) return const SizedBox.shrink();
    
    final minValue = readings.map((r) => r.value).reduce((a, b) => a < b ? a : b);
    final maxValue = readings.map((r) => r.value).reduce((a, b) => a > b ? a : b);
    final range = maxValue - minValue;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${type.toUpperCase()} (${readings.first.unit})',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        
        // Chart area
        Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomPaint(
            painter: SimpleLinePainter(
              readings: readings,
              minValue: minValue,
              maxValue: maxValue,
              color: _getChartColor(type),
            ),
          ),
        ),
        const SizedBox(height: 8),
        
        // Value range
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Min: ${minValue.toStringAsFixed(1)}${readings.first.unit}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            Text(
              'Max: ${maxValue.toStringAsFixed(1)}${readings.first.unit}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Color _getChartColor(String type) {
    switch (type.toLowerCase()) {
      case 'temperature':
        return Colors.red;
      case 'voltage':
        return Colors.blue;
      case 'humidity':
        return Colors.green;
      default:
        return Colors.purple;
    }
  }
}

class SimpleLinePainter extends CustomPainter {
  final List<SensorReading> readings;
  final double minValue;
  final double maxValue;
  final Color color;

  SimpleLinePainter({
    required this.readings,
    required this.minValue,
    required this.maxValue,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (readings.length < 2) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final pointPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final range = maxValue - minValue;
    
    // Calculate points
    final points = <Offset>[];
    for (int i = 0; i < readings.length; i++) {
      final x = (i / (readings.length - 1)) * size.width;
      final normalizedValue = range > 0 ? (readings[i].value - minValue) / range : 0.5;
      final y = size.height - (normalizedValue * size.height);
      points.add(Offset(x, y));
    }

    // Draw line
    if (points.isNotEmpty) {
      path.moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      canvas.drawPath(path, paint);

      // Draw points
      for (final point in points) {
        canvas.drawCircle(point, 3, pointPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}