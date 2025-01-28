import 'package:clearanceapp/components/Widgets.dart';
import 'package:clearanceapp/screens/STU/ClearanceForm.dart';
import 'package:clearanceapp/screens/STU/Student_dash.dart';
import 'package:clearanceapp/screens/STU/Stulogin_screen.dart';
import 'package:clearanceapp/screens/aboutPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Profile page.dart';

class Menu_page extends StatefulWidget {
  final String studentID;
 
  const Menu_page({super.key,required this.studentID});

  @override
  State<Menu_page> createState() => _Menu_pageState();
}

class _Menu_pageState extends State<Menu_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/BGim.png"),
                  fit: BoxFit.fill),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 40, left: 30, right: 30, bottom: 15),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Row(
                  children: [
                    Text(
                      "Home",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      width: 230,
                    ),

                  ],
                ),
                Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ))),
                Column(
                  children: [
                     NotificationCard(
                      text: "Home",
                      icon: Icons.home_outlined,
                      screen: Student_Dash(studentID: widget.studentID),
                    ),
                    NotificationCard(
                      text: "Profile",
                      icon: Icons.person_outline,
                      screen: StudentProfilePage(studentName: "studentName", studentId: "studentId", email: "email", profilePictureUrl: "profilePictureUrl", clearanceStatus: "clearanceStatus"),
                    ),
                     NotificationCard(
                      text: "Clearance Form",
                      icon: Icons.file_copy_outlined,
                      screen: Clearanceform(studentID: widget.studentID),
                    ),

                    NotificationCard(
                      text: "About",
                      icon: Icons.help_outline,
                      screen: AboutPage(),
                    )
                  ],
                ),
                const Spacer(),
    ElevatedButton(
    style: const ButtonStyle(
    elevation: MaterialStatePropertyAll(8),
    backgroundColor: MaterialStatePropertyAll(Color(0xFF20607B)),
    padding: MaterialStatePropertyAll(
    EdgeInsets.symmetric(horizontal: 90, vertical: 12))),
    onPressed: () {
      FirebaseAuth.instance.signOut();
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Login_screen(),
          ));
    },
    child: Text(
    "Log out",
    style: const TextStyle(
    color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),
    ),
    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
