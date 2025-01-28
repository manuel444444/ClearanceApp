import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:clearanceapp/screens/REGISTRAR/Registrar_StudentProfile.dart';
import '../../../Firebase_Queries/Firebase_download.dart';
import '../../../components/Widgets.dart';

class Pending extends StatefulWidget {
  final String RegistrarID;
  final List StudentID;

  const Pending({required this.RegistrarID, super.key,required this.StudentID});

  @override
  State<Pending> createState() => _PendingState();
}

class _PendingState extends State<Pending> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: getRegistrarData(widget.RegistrarID,widget.StudentID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(
            color: Colors.white,
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          var data = snapshot.data!;
          var clearedStudents = data['clearedStudents'];
          var deniedStudents = data['deniedStudents'];
          final List studentsToClear = data['studentsToClear'];

          final List Collegestudents = data['collegeStudents'];
          final List filteredStudentsToClear = studentsToClear.where((student) {
            return Collegestudents.any((deptStudent) => deptStudent['studentID'] == student['studentID']);
          }).toList();


          return Curved_card(
            Fidget: Column(
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color:const Color(0xFF001502)),
                      child: const Padding(
                        padding:const  EdgeInsets.all(10.0),
                        child: const Text(
                          'PENDING CLEARANCE',
                          style:const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    const Spacer(),
                     Text(
                       '${filteredStudentsToClear.length} students',
                      style:
                      const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
               const SizedBox(
                  height: 8,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 3, color:const Color(0xFF001502)),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const Text("Clear All"),
                      ),
                    )),



                filteredStudentsToClear.isEmpty
                    ? const Expanded(
                  child:const Center(
                    child:const Text("Nothing to see here"),
                  ),
                )
                    :
                 ListView.builder(

                  shrinkWrap: true,
                  itemCount: filteredStudentsToClear.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      final studentID = filteredStudentsToClear[index]["referenceID"];
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StudentProfile(
                            studentIndex: index,
                            studentID: widget.StudentID,
                            RegistrarID: widget.RegistrarID,
                          ),
                        ),
                      );
                    },
                    child: Clearance_card(
                      Name: filteredStudentsToClear[index]["name"],
                      Course: filteredStudentsToClear[index]["program"],
                      Profile: filteredStudentsToClear[index]["defermentStatus"],
                      Student_num: filteredStudentsToClear[index]["referenceID"],
                    ),
                  ),
                ),
                // const SizedBox(height: 60),
              ],
            ),
          );
        }
      },
    );
  }
}
