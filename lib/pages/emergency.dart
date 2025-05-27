import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class EmergencyMap extends StatefulWidget {
  const EmergencyMap({super.key});

  @override
  State<EmergencyMap> createState() => _EmergencyMapState();
}

class _EmergencyMapState extends State<EmergencyMap> {
  late final WebViewController _controller;
  List<Map<String, dynamic>> emergencyContacts = [];

  @override
  void initState() {
    super.initState();

    // Initialize WebView
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadFlutterAsset('assets/leaflet_map.html');

    // Fetch emergency contacts
    fetchEmergencyContacts();
  }

  // Fetch emergency contacts from the API
  Future<void> fetchEmergencyContacts() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/users/emergency-contacts/'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          emergencyContacts = data.map((contact) {
            return {
              'id': contact['id'],
              'name': contact['name'],
              'relationship': contact['relationship'],
              'phone_number': contact['phone_number'],
              'email': contact['email'],
            };
          }).toList();
        });
      } else {
        print('Failed to load contacts');
      }
    } catch (e) {
      print('Error fetching contacts: $e');
    }
  }

  // Function to make a call using phone number
  void _makeCall(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          // WebView to display the map
          Expanded(
            child: WebViewWidget(controller: _controller),
          ),

          // Emergency contacts list at the bottom
          Container(
            height: 200,
            padding: const EdgeInsets.all(8),
            child: emergencyContacts.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: emergencyContacts.length,
              itemBuilder: (context, index) {
                final contact = emergencyContacts[index];
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(contact['name']),
                    subtitle: Text('${contact['relationship']} - ${contact['phone_number']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.call, color: Colors.green),
                      onPressed: () => _makeCall(contact['phone_number']),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
