import 'package:flutter/material.dart';


class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundImage: AssetImage('assets/images/img.png'), // Update with your image path
                ),
                SizedBox(height: 12),
                Text(
                  'HealthTrack',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Overview'),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
          ),
          const ListTile(
            leading: Icon(Icons.message),
            title: Text('Messages'),
          ),
          const ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ],
      ),
    );
  }
}
