import 'dart:ui';

import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("About Us",style: TextStyle(color: Colors.white,fontWeight:FontWeight.bold ),),
          backgroundColor: Color(0xFF20607B),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "About Our App",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF003F4D),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  "Our app is designed to make the clearance process seamless and efficient. Whether you're a student or a Head of Department, our app helps you manage the clearance process with ease. We are committed to providing the best user experience and making sure that everything works smoothly.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage("assets/images/untitled-1_245.png"),
                ),
                SizedBox(height: 30),
                Text(
                  "Meet the Creators",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF003F4D),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCreatorCard(
                      name: "Creator 1",
                      role: "Lead Developer",
                      imagePath: "assets/images/untitled-1_245.png",
                    ),
                    _buildCreatorCard(
                      name: "Creator 2",
                      role: "UI/UX Designer",
                      imagePath: "assets/images/untitled-1_245.png",
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Text(
                  "Thank you for using our app. We hope it meets your needs and exceeds your expectations!",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCreatorCard({required String name, required String role, required String imagePath}) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage(imagePath),
        ),
        SizedBox(height: 10),
        Text(
          name,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF003F4D),
          ),
        ),
        Text(
          role,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
