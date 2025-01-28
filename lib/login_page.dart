import 'package:clearanceapp/screens/STU/Stulogin_screen.dart';
import 'package:flutter/material.dart';

class Login_page extends StatelessWidget {
  const Login_page({super.key});

  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Login_screen()
        ),
      ),
    );
  }
}


