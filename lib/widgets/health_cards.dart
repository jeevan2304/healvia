import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HealthCards extends StatelessWidget {
  const HealthCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _HealthCard(icon: Icons.favorite, label: 'Heart Rate', value: '72 BPM')),
            SizedBox(width: 12),
            Expanded(child: _HealthCard(icon: Icons.monitor_heart, label: 'Blood Pressure', value: '120/80')),
          ],
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _HealthCard(icon: Icons.medication, label: 'Medication', value: '2 Today')),
            SizedBox(width: 12),
            Expanded(child: _HealthCard(icon: Icons.calendar_month, label: 'Next Checkup', value: 'May 15')),
          ],
        ),
      ],
    );
  }
}

class _HealthCard extends StatefulWidget {
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
  State<_HealthCard> createState() => _HealthCardState();
}

class _HealthCardState extends State<_HealthCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _scale = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white,
      shadowColor: Colors.grey.withOpacity(0.2),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.grey.shade100,
            ],
          ),
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            ScaleTransition(
              scale: _scale,
              child: Icon(widget.icon, size: 32, color: Colors.redAccent),
            ),
            const SizedBox(height: 10),
            Text(
              widget.label,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              widget.value,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
