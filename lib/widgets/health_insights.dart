import 'package:flutter/material.dart';

class HealthInsights extends StatelessWidget {
  const HealthInsights({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            "AI Insights",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        const SizedBox(height: 16),
        _insightCard(
          icon: Icons.restaurant_menu_rounded,
          title: "Diet Tip",
          description: "Reduce sodium intake. Add bananas, spinach, and avocados to your meals.",
          imageAsset: "assets/images/diet.png",
          timestamp: "2 hours ago",
          badgeText: "New",
        ),
        _insightCard(
          icon: Icons.nightlight_round,
          title: "Sleep Update",
          description: "You've had 7.5 hours average sleep this week. Great improvement!",
          imageAsset: "assets/images/sleep.png",
          timestamp: "Today",
          badgeText: "Improved",
        ),
        _insightCard(
          icon: Icons.event_available_rounded,
          title: "Health Reminder",
          description: "Your annual checkup is due in 2 weeks. Book your appointment today.",
          imageAsset: "assets/images/reminder.png",
          timestamp: "Yesterday",
          badgeText: "Reminder",
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              // navigate to full insights if needed
            },
            child: const Text("View All Insights"),
          ),
        ),
      ],
    );
  }

  Widget _insightCard({
    required IconData icon,
    required String title,
    required String description,
    required String imageAsset,
    required String timestamp,
    String? badgeText,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imageAsset,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon, size: 20, color: Colors.deepPurple),
                      const SizedBox(width: 6),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const Spacer(),
                      if (badgeText != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            badgeText,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    timestamp,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
