import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

class HealthOverview extends StatelessWidget {
  const HealthOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Health Overview",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            _OverviewCard(icon: Icons.directions_walk, label: 'Steps', value: '8,456'),
            _OverviewCard(icon: Icons.directions_bike, label: 'Distance', value: '5.2 km'),
            _OverviewCard(icon: Icons.local_fire_department, label: 'Calories', value: '320 kcal'),
          ],
        ),
        const SizedBox(height: 20),
        _HealthLineChart(),
      ],
    );
  }
}

class _OverviewCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _OverviewCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon, size: 28, color: Colors.blueAccent),
              const SizedBox(height: 8),
              Text(label, style: GoogleFonts.poppins(fontSize: 13)),
              const SizedBox(height: 4),
              Text(value, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}

class _HealthLineChart extends StatelessWidget {
  const _HealthLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: 6,
              minY: 0,
              maxY: 250,
              titlesData: FlTitlesData(show: false),
              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  isCurved: true,
                  color: Colors.blueAccent,
                  barWidth: 4,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        Colors.blueAccent.withOpacity(0.3),
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  spots: const [
                    FlSpot(0, 80),
                    FlSpot(1, 100),
                    FlSpot(2, 120),
                    FlSpot(3, 150),
                    FlSpot(4, 130),
                    FlSpot(5, 180),
                    FlSpot(6, 160),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
