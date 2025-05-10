import 'package:flutter/material.dart';

class HealthInsights extends StatelessWidget {
  const HealthInsights({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("AI Insights", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold , color: Colors.black)),
        const SizedBox(height: 10),
        _insightCard("Based on your recent blood pressure readings, consider reducing sodium intake and increasing potassium-rich foods in your diet."),
        _insightCard("Your sleep pattern shows improvement. Continue with your current sleep hygiene practices."),
        _insightCard("Reminder: Your annual physical examination is due in 2 weeks. Schedule an appointment soon."),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(onPressed: () {}, child: const Text("View All Insights")),
        )
      ],
    );
  }

  Widget _insightCard(String text) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(text),
      ),
    );
  }
}
