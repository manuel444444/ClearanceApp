
import 'package:clearanceapp/screens/STU/Stulogin_screen.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _selectedRole = 'Student'; // Default selected role

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (context) {
          return Scaffold(
              body: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.25, 0.5, 0.75, 1.0],
              colors: [
                Color(0xFF035A6D),
                Color(0xFF012A35),
                Color(0xFF011D26),
                Color(0xFF01161E),
                Color(0xFF011219),
              ],
            )),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset(
                  'assets/images/Group12598.png',
                  height: 300,
                  width: 300,
                ),
                SizedBox(height: 100,),
                const Text.rich(
                  TextSpan(
                    text: 'Welcome to ', // Plain text
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 30),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'AZA ',
                        style: TextStyle(
                            color: Color(0xFF3FD295),
                            fontWeight: FontWeight.w900,
                            fontSize: 50),
                      ),
                      TextSpan(
                        text: '!',
                        style: TextStyle(
                            fontStyle: FontStyle.italic, color: Colors.red),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "School clearing made easy made easy",
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 45),


                ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Color(0xFF20607B))),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const Login_screen()

                    ));
                  },
                  child: const Padding(
                      padding: EdgeInsets.only(
                          top: 20.0, bottom: 20, left: 120, right: 120),
                      child: Icon(
                          color: Colors.white,
                          size: 15,
                          Icons.arrow_right_alt_rounded)),
                ),
                const SizedBox(height: 50),
                const Text.rich(
                  TextSpan(
                    text: 'Affiliated to ', // Plain text
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'KNUST',
                        style: TextStyle(color: Color(0xFFA1DE6E)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "School clearing made easy made easy",
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
              ],
            )),
          ));
        }
      ),
    );
  }
}
