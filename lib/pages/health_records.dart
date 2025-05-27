import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

const Color kGreyishBlack = Color(0xFF1E1E1E);
const Color kCardColor = Color(0xFF2E2E2E);
const Color kAccentColor = Colors.white;

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
          records =
              jsonData.map((item) => HealthRecord.fromJson(item)).toList();
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
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> showAddRecordDialog() async {
    final _formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final recordTypeController = TextEditingController();
    final doctorController = TextEditingController();
    final dateController = TextEditingController();
    final descriptionController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: kCardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Add Health Record',
            style: GoogleFonts.poppins(color: kAccentColor)),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                buildTextField(titleController, 'Title'),
                buildTextField(recordTypeController, 'Record Type'),
                buildTextField(doctorController, 'Doctor'),
                buildTextField(dateController, 'Date (YYYY-MM-DD)'),
                buildTextField(descriptionController, 'Description'),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                Navigator.pop(context);
                await submitRecord(
                  titleController.text,
                  recordTypeController.text,
                  doctorController.text,
                  dateController.text,
                  descriptionController.text,
                );
              }
            },
            child: const Text('Submit', style: TextStyle(color: kGreyishBlack)),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white54),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        validator: (value) =>
        value == null || value.isEmpty ? 'Please enter $label' : null,
      ),
    );
  }

  Future<void> submitRecord(String title, String recordType, String doctor,
      String date, String description) async {
    final url = Uri.parse('http://10.0.2.2:8000/api/health/records/');
    final body = {
      'title': title,
      'record_type': recordType,
      'doctor': doctor,
      'date': date,
      'description': description,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        fetchHealthRecords();
      } else {
        showError('Failed to add record');
      }
    } catch (e) {
      showError('Error posting record: $e');
    }
  }

  Widget buildRecordCard(HealthRecord record) {
    return Card(
      color: kCardColor,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              record.title,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: kAccentColor,
              ),
            ),
            const SizedBox(height: 10),
            buildInfoRow(Iconsax.document, record.recordType),
            buildInfoRow(Iconsax.user, record.doctor),
            buildInfoRow(Iconsax.calendar, record.date),
            const SizedBox(height: 10),
            Text(
              record.description,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.white70),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF333333),
      appBar: AppBar(
        backgroundColor: kGreyishBlack,
        title: const Text('Health Records', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: showAddRecordDialog,
            icon: const Icon(Icons.add, color: Colors.white),
            tooltip: 'Add Record',
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : RefreshIndicator(
        color: Colors.white,
        backgroundColor: kGreyishBlack,
        onRefresh: fetchHealthRecords,
        child: records.isEmpty
            ? const Center(
          child: Text(
            'No records available.',
            style: TextStyle(color: Colors.white),
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.only(top: 12),
          itemCount: records.length,
          itemBuilder: (context, index) =>
              buildRecordCard(records[index]),
        ),
      ),
    );
  }
}
