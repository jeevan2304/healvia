import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Add this import
import 'package:iconsax/iconsax.dart';

import '../widgets/app_drawer.dart';
import '../widgets/health_cards.dart';
import '../widgets/health_insights.dart';
import '../widgets/recent_records.dart';
import '../pages/appointments.dart';
import '..//pages/health_records.dart';
import '../widgets/health_overview.dart';

const Color kGreyishBlack = Color(0xFF1E1E1E);
const Color kIconInactiveColor = Colors.white70;
const Color kIconActiveColor = Colors.black;

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  final List<String> _titles = [
    "Welcome",
    "Health Records",
    "Appointments",
    "AI Insights",
    "Emergency"
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildDashboardContent(),
      HealthRecordsPage(),
      AppointmentsPage(),
      const Center(child: Text("AI Insights", style: TextStyle(color: Colors.white))),
      const Center(child: Text("Emergency", style: TextStyle(color: Colors.white))),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF333333), // Light black shade

      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: kGreyishBlack,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          _titles[_currentIndex],
          style: GoogleFonts.poppins( // Using Poppins font
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),""
        ),
        actions: _currentIndex == 0
            ? [
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text(''),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
          ),
          const SizedBox(width: 10),
        ]
            : null,
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: kGreyishBlack,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavIcon(Iconsax.category, 0),
            _buildNavIcon(Iconsax.folder_open, 1),
            _buildNavIcon(Iconsax.calendar, 2),
            _buildNavIcon(Iconsax.activity, 3),
            _buildNavIcon(Iconsax.warning_2, 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, int index) {
    final bool isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 26,
          color: isSelected ? kIconActiveColor : kIconInactiveColor,
        ),
      ),
    );
  }

  Widget _buildDashboardContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWide = constraints.maxWidth > 800;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: isWide
              ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    HealthCards(),
                    SizedBox(height: 20),
                    HealthOverview(),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              const Expanded(
                flex: 1,
                child: RecentRecords(),
              ),
            ],
          )
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              HealthCards(),
              SizedBox(height: 20),
              HealthOverview(),
            ],
          ),
        );
      },
    );
  }
}
