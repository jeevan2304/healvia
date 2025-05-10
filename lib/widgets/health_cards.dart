import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HealthCards extends StatelessWidget {
  const HealthCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         Text(
          "DashBoard",
          style:GoogleFonts.poppins(fontSize: 24,fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _HealthCard(
                icon: Icons.favorite,
                label: 'Heart Rate',
                value: '72 BPM',
                backgroundColor: const Color(0xFF333333), // Light black
                iconColor: Colors.redAccent,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _HealthCard(
                icon: Icons.monitor_heart,
                label: 'Blood Pressure',
                value: '120/80',
                backgroundColor: const Color(0xFF333333), // Light black
                iconColor: Colors.blueAccent,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _HealthCard(
                icon: Icons.medication,
                label: 'Medication',
                value: '2 Today',
                backgroundColor: const Color(0xFF333333), // Light black
                iconColor: Colors.greenAccent,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _HealthCard(
                icon: Icons.calendar_month,
                label: 'Next Checkup',
                value: 'May 15',
                backgroundColor: const Color(0xFF333333), // Light black
                iconColor: Colors.orangeAccent,
              ),
            ),
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
  final Color backgroundColor;
  final Color iconColor;

  const _HealthCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.backgroundColor,
    required this.iconColor,
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

    _scale = Tween<double>(begin: 1.0, end: 1.05).animate(
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
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: widget.backgroundColor,
      shadowColor: Colors.white.withOpacity(0.2),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              widget.backgroundColor,
              widget.backgroundColor.withOpacity(0.8),
            ],
          ),
        ),
        child: Column(
          children: [
            ScaleTransition(
              scale: _scale,
              child: Icon(
                widget.icon,
                size: 32,
                color: widget.iconColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.label,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              widget.value,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
