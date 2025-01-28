import 'package:clearanceapp/components/Widgets.dart';
import 'package:clearanceapp/screens/REGISTRAR/Registrar_clearance.dart';
import 'package:clearanceapp/screens/STU/Student_dash.dart';
import 'package:clearanceapp/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../HOD/Hod_clearance.dart';

class Login_screen extends StatefulWidget {
  const Login_screen({super.key});

  @override
  State<Login_screen> createState() => _Login_screenState();
}

class _Login_screenState extends State<Login_screen> {
  final FirebaseAuthServices _auth = FirebaseAuthServices();

  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          children: [
            SizedBox(height: 170,),
            Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17),
                      color: const Color(0xFF0B222D),
                    ),
                    padding: const EdgeInsets.all(27),
                    width: 332,
                    height: 320,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Login',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 27,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            TextField(
                              style: TextStyle(color: Colors.white),
                              controller: _emailController,
                              decoration: InputDecoration(
                                  labelText: "Enter your ID",
                                  labelStyle: TextStyle(color: Colors.white)),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextField(
                              style: TextStyle(color: Colors.white),
                              controller: _passwordController,
                              decoration: InputDecoration(
                                  labelText: "Enter your password",
                                labelStyle: TextStyle(color: Colors.white),),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                        ElevatedButton(
                          style: const ButtonStyle(
                              elevation: MaterialStatePropertyAll(8),
                              backgroundColor:
                                  MaterialStatePropertyAll(Color(0xFF20607B)),
                              padding: MaterialStatePropertyAll(
                                  EdgeInsets.symmetric(
                                      horizontal: 90, vertical: 12))),
                          onPressed: () {
                            _signIn();
                          },
                          child: Text(
                            "Login",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ));

  }

  String getCurrentUserID() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      throw Exception('No user is currently signed in');
    }
  }


  void _signIn() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      // UserCredential userCredential = (await _auth.signInWithEmailAndPassword(
      //   email: email,
      //   password: password,
      // )) as UserCredential;
      User? user = await _auth.signInWithEmailAndPassword(email, password);
      // User? user = userCredential.user;

      if (user != null) {
        String userID = user.uid;

        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(userID)
            .get();
        // DocumentSnapshot HodDoc = await FirebaseFirestore.instance
        //     .collection('Users')
        //     .doc(userID)
        //     .get();

        QuerySnapshot HStu = await FirebaseFirestore.instance
            .collection('Users')
            .where('Role', isEqualTo: 'Student')
            .where('DepartmentId', isEqualTo: userDoc["DepartmentId"])
            .get();

        List hod = HStu.docs.map((doc) => doc.data()).toList();



        if (userDoc.exists) {
          String role = userDoc['Role'];

          if (role == 'Student') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Student_Dash(studentID: userID),
              ),
            );
          }
          else if (role == 'HOD') {

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MyScreen(HodID: userID,StudentID: hod),
              ),
            );
          }
          else if (role == 'Registrar') {
            if (userID.isEmpty) {
              throw ArgumentError('Registrar ID must not be empty');
            }

            DocumentSnapshot RegistrarDoc = await FirebaseFirestore.instance
                .collection('Users')
                .doc(userID)
                .get();

            DocumentSnapshot departmentDoc = await FirebaseFirestore.instance
                .doc('/Users/$userID/ListofDepartments/$userID')
                .get();

            List<Map<String, dynamic>> collegeStudents = [];

            if (departmentDoc.exists) {
              // Extract department IDs
              String dept1 = departmentDoc['Dept1'];
              String dept2 = departmentDoc['Dept2'];

              // Create a list of department IDs
              List<String> departmentIds = [dept1, dept2];
              try {
                QuerySnapshot RStu = await FirebaseFirestore.instance
                    .collection('Users')
                    .where('Role', isEqualTo: 'Student')
                    .where('CollegeId', isEqualTo: RegistrarDoc["CollegeId"])
                    .where('DepartmentId', whereIn: departmentIds)
                    .get();
                collegeStudents = RStu.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyRScreen(RegistrarID:userID ,StudentID: collegeStudents),
                  ),
                );
                // Process the students
              } catch (e) {
                print('Error fetching students: $e');
                // Handle the error (e.g., return a partial response or an error message)
              }
              // Query to get students whose DepartmentId is in the list of department IDs

              // Collect the student data

            } else {
              print('No departments found in the specified path.');
            }


          }
          else {
            print("Unknown user role");
          }
        } else {
          print("User document does not exist");
        }
      } else {
        print("Some error happened");
      }
    } catch (e) {
      print("Error during sign in: $e");
    }
  }

}
