import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../widgets/health_cards.dart';
import '../widgets/health_insights.dart';
import '../widgets/recent_records.dart';
import '../pages/appointments.dart';
import '../pages/health_records.dart';
import 'package:iconsax/iconsax.dart'; // Make sure the path is correct

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  final List<String> _titles = [
    "Dashboard",
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
      const Center(child: Text("AI Insights")),
      const Center(child: Text("Messages")),
      const Center(child: Text("Emergency")),
    ];

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        actions: _currentIndex == 0
            ? [
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('Add Record'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
        ]
            : null,
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Iconsax.category), // dashboard
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.folder_open), // health records
            label: 'Records',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.calendar), // appointments
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.activity), // ai insights
            label: 'AI Insights',
          ),

          BottomNavigationBarItem(
            icon: Icon(Iconsax.warning_2), // emergency
            label: 'Emergency',
          ),
        ],
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
                    HealthInsights(),
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
              HealthInsights(),
              SizedBox(height: 20),
              RecentRecords(),
            ],
          ),
        );
      },
    );
  }
}
