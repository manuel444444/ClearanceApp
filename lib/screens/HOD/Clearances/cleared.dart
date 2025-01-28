import 'package:clearanceapp/screens/HOD/Hod_clearance.dart';
import 'package:clearanceapp/screens/HOD/Hod_StudentProfile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../Firebase_Queries/Firebase_download.dart';
import '../../../components/Widgets.dart';

class Cleared extends StatefulWidget {
  final String HodID;
  final List StudentID;

  const Cleared({required this.HodID, super.key,required this.StudentID});

  @override
  State<Cleared> createState() => _ClearedState();
}

class _ClearedState extends State<Cleared> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: getHodData(widget.HodID,widget.StudentID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(color: Colors.white,);
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          var data = snapshot.data!;
          var studentsToClear = data['studentsToClear'];
          final List clearedStudents = data['clearedStudents'];
          var deniedStudents = data['deniedStudents'];
          var hod_Details = data['HOD'];
          final List Departmentstudents = data['departmentStudents'];
          final List filteredStudentsCleared = clearedStudents.where((student) {
            return Departmentstudents.any((deptStudent) => deptStudent['studentID'] == student['studentID']);
          }).toList();
          print(studentsToClear);
          print("ddddddd $clearedStudents");
          print(deniedStudents);
          return Curved_card(
            Fidget: Column(
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color:const Color(0xFF001502)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: const Text(
                          'CLEARED CLEARANCE',
                          style:const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    Spacer(),
                     Text(
                      '${filteredStudentsCleared.length} students',
                      style:
                      const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 3, color:const Color(0xFF001502)),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Padding(
                        padding:const  EdgeInsets.symmetric(
                            horizontal: 7, vertical: 8),
                        child:const  Text("Clear All"),
                      ),
                    )),
                filteredStudentsCleared.isEmpty
                    ? const Expanded(
                      child:const Center(
                          child:const Text("Nothing to see here"),
                        ),
                    )
                    : ListView.builder(

                        shrinkWrap: true,
                        itemCount: filteredStudentsCleared.length,
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            final studentID = filteredStudentsCleared[index]["referenceID"];
                            try{ Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StudentProfile(
                                  studentIndex: index,
                                  studentID: widget.StudentID,
                                  HodID: widget.HodID,
                                ),
                              ),
                            );}
                            catch(e){
                              print(e);
                            }

                          },
                          child: Clearance_card(
                              Name: filteredStudentsCleared[index]["name"],
                              Course: filteredStudentsCleared[index]["program"],
                              Profile: filteredStudentsCleared[index]["defermentStatus"],
                              Student_num: filteredStudentsCleared[index]["referenceID"],
                              ),
                        ),
                      ),
              ],
            ),
          );
        }
      },
    );
  }
}
