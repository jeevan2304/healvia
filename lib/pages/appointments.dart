import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Appointment {
  final String doctor;
  final String date;
  final String purpose;
  final String location;

  Appointment({
    required this.doctor,
    required this.date,
    required this.purpose,
    required this.location,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      doctor: json['doctor'],
      date: json['date'],
      purpose: json['purpose'],
      location: json['location'],
    );
  }
}

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  late Future<List<Appointment>> _appointmentsFuture;

  @override
  void initState() {
    super.initState();
    _appointmentsFuture = fetchAppointments();
  }

  Future<List<Appointment>> fetchAppointments() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/health/appointments/'));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((item) => Appointment.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load appointments');
    }
  }

  String formatDateTime(String isoString) {
    final dateTime = DateTime.parse(isoString).toLocal();
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Appointments', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Appointment>>(
          future: _appointmentsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.black));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No appointments available'));
            }

            final appointments = snapshot.data!;
            return ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: const CircleAvatar(
                      backgroundColor: Colors.black,
                      child: Icon(Icons.calendar_today, color: Colors.white),
                    ),
                    title: Text(
                      appointment.doctor,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                        Text('Purpose: ${appointment.purpose}'),
                        Text('Date: ${formatDateTime(appointment.date)}'),
                        Text('Location: ${appointment.location}'),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // TODO: Implement details dialog/page
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      child: const Text('Details'),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
