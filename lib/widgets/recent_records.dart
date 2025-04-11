import 'package:flutter/material.dart';

class RecentRecords extends StatelessWidget {
  const RecentRecords({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Recent Records", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        _recordTile("Annual physical report", "March 26, 2025"),
        _recordTile("Annual physical report", "March 26, 2025"),
        _recordTile("Full body check up", "March 26, 2025"),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(onPressed: () {}, child: const Text("View All Records")),
        ),
      ],
    );
  }

  Widget _recordTile(String title, String date) {
    return ListTile(
      title: Text(title),
      subtitle: Text(date),
      trailing: const Text("View", style: TextStyle(color: Colors.blue)),
      contentPadding: EdgeInsets.zero,
    );
  }
}
