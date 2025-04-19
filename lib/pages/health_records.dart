import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HealthRecord {
  final int id;
  final String title;
  final String recordType;
  final String doctor;
  final String date;
  final String description;

  HealthRecord({
    required this.id,
    required this.title,
    required this.recordType,
    required this.doctor,
    required this.date,
    required this.description,
  });

  factory HealthRecord.fromJson(Map<String, dynamic> json) {
    return HealthRecord(
      id: json['id'],
      title: json['title'],
      recordType: json['record_type'],
      doctor: json['doctor'],
      date: json['date'],
      description: json['description'],
    );
  }
}

class HealthRecordsPage extends StatefulWidget {
  const HealthRecordsPage({Key? key}) : super(key: key);

  @override
  _HealthRecordsPageState createState() => _HealthRecordsPageState();
}

class _HealthRecordsPageState extends State<HealthRecordsPage> {
  List<HealthRecord> records = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchHealthRecords();
  }

  Future<void> fetchHealthRecords() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/health/records/'),
      );

      if (response.statusCode == 200) {
        List jsonData = jsonDecode(response.body);
        setState(() {
          records = jsonData.map((item) => HealthRecord.fromJson(item)).toList();
        });
      } else {
        showError('Failed to load health records');
      }
    } catch (e) {
      showError('Error fetching records: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget buildRecordCard(HealthRecord record) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(record.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.medical_services_outlined, size: 16),
                const SizedBox(width: 6),
                Text(record.recordType),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.person, size: 16),
                const SizedBox(width: 6),
                Text(record.doctor),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 6),
                Text(record.date),
              ],
            ),
            const SizedBox(height: 10),
            Text(record.description, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Health Records')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: fetchHealthRecords,
        child: records.isEmpty
            ? const Center(child: Text('No records available.'))
            : ListView.builder(
          padding: const EdgeInsets.only(top: 10),
          itemCount: records.length,
          itemBuilder: (context, index) => buildRecordCard(records[index]),
        ),
      ),
    );
  }
}
