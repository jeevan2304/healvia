import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../widgets/health_cards.dart';
import '../widgets/health_insights.dart';
import '../widgets/recent_records.dart';
import '../pages/appointments.dart'; // Make sure the path is correct

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
    "Messages",
    "Emergency"
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildDashboardContent(),
      const Center(child: Text("Health Records")),
      const AppointmentsPage(),
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
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'Records'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Appointments'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'AI Insights'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),

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
