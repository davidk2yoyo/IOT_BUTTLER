import 'package:flutter/material.dart';
import '../models/device.dart';
import 'device_detail_screen.dart';

class HouseMapScreen extends StatelessWidget {
  final List<Device> devices;

  const HouseMapScreen({
    super.key,
    required this.devices,
  });

  @override
  Widget build(BuildContext context) {
    final grouped = _groupByLocation(devices);
    final rooms = grouped.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF667EEA),
                Color(0xFF764BA2),
              ],
            ),
          ),
        ),
        title: const Text(
          'House Map',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: rooms.isEmpty
          ? const Center(
              child: Text('No devices to map yet'),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsRow(rooms),
                  const SizedBox(height: 16),
                  _buildFloorPlan(context, rooms),
                ],
              ),
            ),
    );
  }

  Map<String, List<Device>> _groupByLocation(List<Device> devices) {
    final grouped = <String, List<Device>>{};
    for (final device in devices) {
      final location = device.location.trim();
      final key = location.isEmpty ? 'Unassigned' : location;
      grouped.putIfAbsent(key, () => []).add(device);
    }
    return grouped;
  }

  Widget _buildStatsRow(List<MapEntry<String, List<Device>>> rooms) {
    final deviceCount =
        rooms.fold<int>(0, (sum, entry) => sum + entry.value.length);
    return Row(
      children: [
        const Text(
          'Rooms',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        const Spacer(),
        _buildStatPill('${rooms.length} rooms'),
        const SizedBox(width: 8),
        _buildStatPill('$deviceCount devices'),
      ],
    );
  }

  Widget _buildStatPill(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF667EEA).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF667EEA),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildFloorPlan(
    BuildContext context,
    List<MapEntry<String, List<Device>>> rooms,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF1F5F9),
            Color(0xFFE2E8F0),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth > 700 ? 3 : 2;
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
            ),
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              final entry = rooms[index];
              return _RoomCard(
                roomName: entry.key,
                devices: entry.value,
                onDeviceTap: (device) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DeviceDetailScreen(
                        deviceId: device.id,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _RoomCard extends StatelessWidget {
  final String roomName;
  final List<Device> devices;
  final ValueChanged<Device> onDeviceTap;

  const _RoomCard({
    required this.roomName,
    required this.devices,
    required this.onDeviceTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.room, size: 18, color: Color(0xFF667EEA)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  roomName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '${devices.length}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: devices.map((device) {
                return InkWell(
                  onTap: () => onDeviceTap(device),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _statusColor(device.status).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _statusColor(device.status),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          device.name,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E293B),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'online':
        return const Color(0xFF10B981);
      case 'warning':
        return const Color(0xFFF59E0B);
      case 'offline':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }
}
