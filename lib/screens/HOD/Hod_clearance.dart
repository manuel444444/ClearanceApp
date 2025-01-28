import 'package:clearanceapp/components/Widgets.dart';
import 'package:clearanceapp/screens/HOD/Clearances/cleared.dart';
import 'package:clearanceapp/screens/HOD/Clearances/denied.dart';
import 'package:clearanceapp/screens/HOD/Hod_StudentProfile.dart';
import '../../Firebase_Queries/Firebase_download.dart';
import 'package:clearanceapp/screens/HOD/Clearances/pending.dart';
import 'package:flutter/material.dart';

class MyScreen extends StatefulWidget {
  final String HodID;
  final List StudentID;

  const MyScreen({super.key, required this.HodID, required this.StudentID});

  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  int _selectedIndex = 1;

  void _onButtonTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Student ID: ${widget.HodID}');
    return FutureBuilder<Map<String, dynamic>>(
      future: getHodData(widget.HodID, widget.StudentID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image:const DecorationImage(
                        image:const AssetImage("assets/images/BGim.png"),
                        fit: BoxFit.fill),
                  ),
                ),
                Center(
                    child: const CircularProgressIndicator(
                  color: Colors.white,
                ))
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          var data = snapshot.data!;
          var studentsToClear = data['studentsToClear'];
          var clearedStudents = data['clearedStudents'];
          var deniedStudents = data['deniedStudents'];
          var Departmentstudents = data['departmentStudents'];
          var hod_Details = data['HOD'];
          print("Hod details: $hod_Details");
          print("Hod details: $hod_Details['studentID']");
          print("students to clear:$studentsToClear");
          print("cleared students: $clearedStudents");
          print("denied students: $deniedStudents");
          print("department students: $Departmentstudents");
          return Scaffold(
              body: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      image:const DecorationImage(
                          image:const AssetImage("assets/images/BGim.png"),
                          fit: BoxFit.fill),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 50),
                      Dash_title(text: "Clearance",studentID: widget.HodID),
                      const SizedBox(
                        height: 5,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const NeumorphicSearchField(),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: const ButtonStyle(
                                foregroundColor:
                                const WidgetStatePropertyAll(Colors.white),
                                backgroundColor:
                                const WidgetStatePropertyAll(Colors.black)),
                            child: const Text('CLEARED'),
                            onPressed: () {
                              _onButtonTapped(0);
                              setState(() {
                                status = "cleared";
                              });
                              print(status);
                            },
                          ),
                          ElevatedButton(
                            style: const ButtonStyle(
                                foregroundColor:
                                const WidgetStatePropertyAll(Colors.white),
                                backgroundColor:
                                const WidgetStatePropertyAll(Colors.black)),
                            onPressed: () {
                              _onButtonTapped(1);
                              setState(() {
                                status = "pending";
                              });
                              print(status);
                            },
                            child: const Text('PENDING'),
                          ),
                          ElevatedButton(
                            style: const ButtonStyle(
                                foregroundColor:
                                const WidgetStatePropertyAll(Colors.white),
                                backgroundColor:
                                const  WidgetStatePropertyAll(Colors.black)),
                            onPressed: () {
                              _onButtonTapped(2);
                              setState(() {
                                status = "denied";
                              });
                              print(status);
                            },
                            child: const Text('DENIED'),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      _selectedIndex == 0
                          ? Cleared(
                              HodID: widget.HodID,
                              StudentID: widget.StudentID,
                            )
                          : _selectedIndex == 1
                              ? Pending(
                                  HodID: widget.HodID,
                                  StudentID: widget.StudentID,
                                )
                              : Denied(
                                  HodID: widget.HodID,
                                  StudentID: widget.StudentID,
                                )
                    ],
                  ),
                ],
              ),
            );

        }
      },
    );
  }
}
