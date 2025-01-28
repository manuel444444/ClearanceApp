import 'package:clearanceapp/components/Widgets.dart';
import 'package:clearanceapp/screens/REGISTRAR/Clearances/cleared.dart';
import 'package:clearanceapp/screens/REGISTRAR/Clearances/denied.dart';
import 'package:clearanceapp/screens/REGISTRAR/Registrar_StudentProfile.dart';
import 'package:clearanceapp/screens/REGISTRAR/Registrar_menu.dart';
import '../../Firebase_Queries/Firebase_download.dart';
import 'package:clearanceapp/screens/REGISTRAR/Clearances/pending.dart';
import 'package:flutter/material.dart';

class MyRScreen extends StatefulWidget {
  final String RegistrarID;
  final List StudentID;

  const MyRScreen(
      {super.key, required this.RegistrarID, required this.StudentID});

  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyRScreen> {
  int _selectedIndex = 1;

  void _onButtonTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Student ID: ${widget.RegistrarID}');
    return FutureBuilder<Map<String, dynamic>>(
      future: getRegistrarData(widget.RegistrarID, widget.StudentID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: const DecorationImage(
                        image: const AssetImage("assets/images/BGim.png"),
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
          var Departmentstudents = data['collegeStudents'];
          var Registrar_Details = data['Registrar'];
          print("Registrar details: $Registrar_Details");
          print("Registrar details: $Registrar_Details['studentID']");
          print("students to clear:$studentsToClear");
          print("cleared students: $clearedStudents");
          print("denied students: $deniedStudents");
          print("department students: $Departmentstudents");

          final List filteredStudentsToClear = studentsToClear.where((student) {
            return Departmentstudents.any((deptStudent) =>
                deptStudent['studentID'] == student['studentID']);
          }).toList();

          List<String>? _filteredItems = [];
          @override
          void initState() {
            super.initState();
            _filteredItems = filteredStudentsToClear.cast<String>();
          }

          void filterItems(String query) {
            final filtered = filteredStudentsToClear
                .where(
                    (item) => item.toLowerCase().contains(query.toLowerCase()))
                .toList();
            setState(() {
              _filteredItems = filtered.cast<String>();
            });
          }

          return Scaffold(
            body: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: const DecorationImage(
                        image: const AssetImage("assets/images/BGim.png"),
                        fit: BoxFit.fill),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 21),
                      child: Row(
                        children: [
                          Text(
                            "Clearance",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 23,
                                color: Colors.white),
                          ),
                          const Spacer(),
                          GestureDetector(
                            child: Icon(
                              Icons.menu_rounded,
                              size: 24,
                              color: Colors.white,
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Menu_Registrar(
                                  StudentID: widget.RegistrarID,
                                ),
                              ));
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 21),
                      child: PrimaryContainer(
                        child: TextField(
                          onChanged: (value) {
                            filterItems;
                          },
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                          textAlignVertical: TextAlignVertical.center,
                          controller: TextEditingController(),
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 3),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              hintText: 'Search',
                              suffixIcon: Container(
                                width: 70,
                                decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                        colors: [
                                          Color(0XFF5E5E5E),
                                          Color(0XFF3E3E3E),
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight),
                                    borderRadius: BorderRadius.circular(30)),
                                child: const Icon(Icons.search,
                                    color: Color(0xFF222222)),
                              ),
                              hintStyle: const TextStyle(
                                  fontSize: 14, color: Colors.grey)),
                        ),
                      ),
                    ),
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
                                  const WidgetStatePropertyAll(Colors.black)),
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
                            RegistrarID: widget.RegistrarID,
                            StudentID: widget.StudentID,
                          )
                        : _selectedIndex == 1
                            ? Pending(
                                RegistrarID: widget.RegistrarID,
                                StudentID: widget.StudentID,
                              )
                            : Denied(
                                RegistrarID: widget.RegistrarID,
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
