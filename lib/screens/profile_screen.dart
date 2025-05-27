import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/users/profiles/'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          userData = data[0];
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white70, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[400],
                    )),
                const SizedBox(height: 4),
                Text(value,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : hasError
          ? const Center(
        child: Text(
          'Failed to load profile.',
          style: TextStyle(color: Colors.white),
        ),
      )
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(Icons.person, "Name", "${userData!['first_name']} ${userData!['last_name']}"),
              _buildInfoRow(Icons.email, "Email", userData!['email']),
              _buildInfoRow(Icons.phone, "Phone", userData!['phone_number']),
              _buildInfoRow(Icons.cake, "Date of Birth", userData!['date_of_birth']),
              _buildInfoRow(Icons.wc, "Gender", userData!['gender']),
              _buildInfoRow(Icons.opacity, "Blood Type", userData!['blood_type']),
              _buildInfoRow(Icons.height, "Height", userData!['height_display']),
              _buildInfoRow(Icons.monitor_weight, "Weight", userData!['weight_display']),
              _buildInfoRow(Icons.fitness_center, "BMI", "${userData!['bmi']} (${userData!['bmi_status']})"),
            ],
          ),
        ),
      ),
    );
  }
}
