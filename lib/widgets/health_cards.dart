import 'package:flutter/material.dart';

class HealthCards extends StatelessWidget {
  const HealthCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // First Row: Heart Rate + Blood Pressure
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Expanded(child: _HealthCard(icon: Icons.favorite, label: 'Heart Rate', value: '72 BPM')),
            SizedBox(width: 10),
            Expanded(child: _HealthCard(icon: Icons.monitor_heart, label: 'Blood Pressure', value: '120/80')),
          ],
        ),
        const SizedBox(height: 10),

        // Second Row: Medication + Next Checkup
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Expanded(child: _HealthCard(icon: Icons.medication, label: 'Medication', value: '2 Today')),
            SizedBox(width: 10),
            Expanded(child: _HealthCard(icon: Icons.calendar_month, label: 'Next Checkup', value: 'May 15')),
          ],
        ),
      ],
    );
  }
}

class _HealthCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _HealthCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(0xFFFCEEEE),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 28, color: Colors.redAccent),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
