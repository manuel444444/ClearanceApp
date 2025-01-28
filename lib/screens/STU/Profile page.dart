import 'package:flutter/material.dart';

class StudentProfilePage extends StatelessWidget {
  final String studentName;
  final String studentId;
  final String email;
  final String profilePictureUrl;
  final String clearanceStatus;

  StudentProfilePage({
    required this.studentName,
    required this.studentId,
    required this.email,
    required this.profilePictureUrl,
    required this.clearanceStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Profile'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(profilePictureUrl),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Name: $studentName',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Student ID: $studentId',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Email: $email',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Clearance Status: $clearanceStatus',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                // Add functionality for button press
              },
              child: Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
