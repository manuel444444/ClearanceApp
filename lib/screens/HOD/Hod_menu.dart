import 'package:clearanceapp/components/Widgets.dart';
import 'package:clearanceapp/screens/STU/Stulogin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Menu_Hod extends StatelessWidget {
  const Menu_Hod({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       home: Scaffold(
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
               padding: const EdgeInsets.only(top: 40, left: 30, right: 30,bottom: 15),
               child: Column(
                 children: [
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
                       Icon(
                         Icons.notifications_outlined,
                         color: Colors.white,
                       ),
                     ],
                   ),
                   const Align(
                       alignment: Alignment.bottomRight,
                       child: Icon(Icons.close,color: Colors.white,)),
                   Column(
                     children: [
                       NotificationCard(
                         text: "Home",
                         icon: Icons.home_outlined,
                         screen: Container(),
                       ),
                       NotificationCard(
                         text: "Profile",
                         icon: Icons.person_outline,
                         screen: Container(),
                       ),
                       NotificationCard(
                         text: "Notifications",
                         icon: Icons.notifications_outlined,
                         screen: Container(),
                       ),
                       NotificationCard(text: "Clearance", icon: Icons.file_copy_outlined, screen: Container(),),
                       NotificationCard(text: "Settings", icon: Icons.settings_outlined, screen: Container(),),
                       NotificationCard(text: "Help", icon: Icons.help_outline, screen: Container(),),
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
       ),
    );
  }
}
