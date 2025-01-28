import 'package:clearanceapp/Data_insertion.dart';
import 'package:clearanceapp/app.dart';
import 'package:clearanceapp/firebase_options.dart';
import 'package:clearanceapp/screens/STU/Stulogin_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'show Firebase, FirebaseOptions;
import 'package:clearanceapp/screens/HOD/Hod_clearance.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  // runApp(MaterialApp(home: SampleDataScreen()));
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),) );
}


