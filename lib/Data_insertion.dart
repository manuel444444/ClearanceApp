import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickalert/quickalert.dart';

class SampleDataScreen extends StatelessWidget {
  Future<void> addSampleData(BuildContext context) async {
    try {
      // Sign up users to get their UIDs
      // UserCredential hodCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      //   email: 'panford@example.com',
      //   password: 'password123',
      // );
      // UserCredential studentCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      //   email: 'sam@example.com',
      //   password: 'password123',
      // );
      UserCredential registrarCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: 'bean@example.com',
        password: 'password123',
      );

      // String hodID = hodCredential.user!.uid;
      // String studentID = studentCredential.user!.uid;
      String registrarID = registrarCredential.user!.uid;

      // Add HOD data
      // await FirebaseFirestore.instance.collection('Users').doc(hodID).set({
      //   'Name': 'panford',
      //   'Email': hodCredential.user!.email,
      //   'Role': 'HOD',
      //   'DepartmentId': 'fr',
      //   'hodID': hodID,
      // });

      // Add student data
      // await FirebaseFirestore.instance.collection('Users').doc(studentID).set({
      //   'Name': 'sam kk',
      //   'Email': studentCredential.user!.email,
      //   'Role': 'Student',
      //   'DepartmentId': 'fr',
      //   'CollegeId':"cos",
      //   'studentID': studentID,
      // });

      //Add Registrar data
      await FirebaseFirestore.instance.collection('Users').doc(registrarID).set({
        'Name': 'panford',
        'Email': registrarCredential.user!.email,
        'Role': 'Registrar',
        'CollegeId': 'cos',
        'registrarID': registrarID,
      });

      // Add clearance form data
      // String clearanceFormID = FirebaseFirestore.instance.collection('ClearanceForms_Collection').doc().id;
      // await FirebaseFirestore.instance.collection('ClearanceForms_Collection').doc(clearanceFormID).set({
      //   'studentID': studentID,
      //   'dateSubmitted': Timestamp.now(),
      //   'overrallStatus': 'Pending',
      //   'hodStatus': 'Pending',
      //   'hodComment': 'Clearance denied due to outstanding fees',
      //   'registrarStatus':'Pending',
      //   'registrarComment':'',
      //   'libraryStatus': 'Pending',
      //   'feesStatus': 'Pending',
      //   'name': 'sam KK',
      //   'referenceID': '2243356',
      //   'program': 'Computer Science',
      //   'defermentStatus': 'Not Deferred',
      //   'feesPaid': "true",
      //   'owingBooks': "false",
      //
      //   'level':"400",
      //   'trails':"No trails",
      //   'projects':"Completed",
      //   'internships':"Completed",
      //   'request':"Sent"
      // });




      QuickAlert.show(context: context, type: QuickAlertType.success);
      print('Sample data added successfully');
    } catch (e) {
      print('Error adding sample data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Sample Data')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => addSampleData(context),
          child: Text('Add Sample Data to Firestore'),
        ),
      ),
    );
  }
}
