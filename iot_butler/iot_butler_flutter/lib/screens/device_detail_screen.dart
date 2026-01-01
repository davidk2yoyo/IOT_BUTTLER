import 'package:flutter/material.dart';
import '../models/device.dart';
import '../services/api_service.dart';
import '../widgets/sensor_chart.dart';
import '../widgets/alert_card.dart';
import '../widgets/butler_dialog.dart';

class DeviceDetailScreen extends StatefulWidget {
  final int deviceId;

  const DeviceDetailScreen({
    super.key,
    required this.deviceId,
  });

  @override
  State<DeviceDetailScreen> createState() => _DeviceDetailScreenState();
}

class _DeviceDetailScreenState extends State<DeviceDetailScreen> {
  final ApiService _apiService = ApiService();
  
  Device? _device;
  List<SensorReading> _readings = [];
  List<Alert> _alerts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDeviceData();
  }

  Future<void> _loadDeviceData() async {
    setState(() => _isLoading = true);
    
    try {
      final device = await _apiService.getDevice(widget.deviceId);
      final readings = await _apiService.getDeviceReadings(widget.deviceId);
      final alerts = await _apiService.getDeviceAlerts(widget.deviceId);
      
      setState(() {
        _device = device;
        _readings = readings;
        _alerts = alerts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading device data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Loading...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_device == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Device Not Found')),
        body: const Center(
          child: Text('Device not found'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_device!.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDeviceData,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadDeviceData,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Device Status Header
              _buildStatusHeader(),
              const SizedBox(height: 24),
              
              // Sensor Readings Section
              _buildSensorSection(),
              const SizedBox(height: 24),
              
              // Alerts Section
              _buildAlertsSection(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadDeviceData,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildStatusHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getStatusColor(_device!.status),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  _device!.status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(_device!.status),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Location: ${_device!.location}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              'Last updated: ${_formatDateTime(_device!.updatedAt)}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sensor Readings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // Current readings
        if (_readings.isNotEmpty) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: _readings.map((reading) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          reading.type.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${reading.value} ${reading.unit}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _getReadingColor(reading),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Chart
          SensorChart(readings: _readings),
        ] else
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('No sensor readings available'),
            ),
          ),
      ],
    );
  }

  Widget _buildAlertsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Active Alerts',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        if (_alerts.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 12),
                  Text('No active alerts'),
                ],
              ),
            ),
          )
        else
          ..._alerts.map((alert) => AlertCard(
                alert: alert,
                onAskButler: () => _showButlerExplanation(alert),
                onResolve: () => _resolveAlert(alert),
              )),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'online':
        return Colors.green;
      case 'warning':
        return Colors.orange;
      case 'offline':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getReadingColor(SensorReading reading) {
    if (reading.type == 'temperature') {
      if (reading.value > 80) return Colors.red;
      if (reading.value > 70) return Colors.orange;
      return Colors.green;
    }
    if (reading.type == 'voltage') {
      if (reading.value < 10) return Colors.red;
      if (reading.value < 11) return Colors.orange;
      return Colors.green;
    }
    return Colors.blue;
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _showButlerExplanation(Alert alert) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final explanation = await _apiService.explainAlert(alert.id);
      
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        showDialog(
          context: context,
          builder: (context) => ButlerDialog(explanation: explanation),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error getting explanation: $e')),
        );
      }
    }
  }

  Future<void> _resolveAlert(Alert alert) async {
    try {
      await _apiService.resolveAlert(alert.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alert resolved')),
      );
      _loadDeviceData(); // Refresh data
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error resolving alert: $e')),
      );
    }
  }
}