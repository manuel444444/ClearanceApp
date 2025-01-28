import 'package:clearanceapp/components/Widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import '../../Firebase_Queries/Firebase_download.dart';

String status = "pending";

class StudentProfile extends StatelessWidget {
  final studentID;
  final String RegistrarID;
  final int studentIndex;


  const StudentProfile(
      {super.key,
      required this.studentID,
      required this.RegistrarID,
      required this.studentIndex});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    return FutureBuilder<Map<String, dynamic>>(
      future: getRegistrarData(RegistrarID, studentID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
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
          print("students to clear:$studentsToClear");
          print("cleared students: $clearedStudents");
          print("denied students: $deniedStudents");
          final List Departmentstudents = data['departmentStudents'];
          final List filteredStudentsCleared = clearedStudents.where((student) {
            return Departmentstudents.any((deptStudent) =>
                deptStudent['studentID'] == student['studentID']);
          }).toList();
          final List filteredStudentsToClear = studentsToClear.where((student) {
            return Departmentstudents.any((deptStudent) => deptStudent['studentID'] == student['studentID']);
          }).toList();
          final List filteredStudentsDenied = deniedStudents.where((student) {
            return Departmentstudents.any((deptStudent) => deptStudent['studentID'] == student['studentID']);
          }).toList();


          Future<void> updateClearanceStatus(
              String formID, bool approved, String? comment) async {
            if (formID == null) {
              print('Error: formID is null');
              return;
            }

            String status = approved ? "Cleared" : "Denied";
            String nonNullComment = comment ?? 'No comment provided';

            try {
              DocumentSnapshot formDoc = await FirebaseFirestore.instance
                  .collection('ClearanceForms_Collection')
                  .doc(formID)
                  .get();

              if (!formDoc.exists) {
                print('Error: form document not found for formID: $formID');
                return;
              }
              final dio = Dio();
              // Update the main form document
              await FirebaseFirestore.instance
                  .collection('ClearanceForms_Collection')
                  .doc(formID)
                  .update({
                'registrarStatus': status,
                'registrarComment': nonNullComment,
              });
              if(status=='Cleared'){
                print('hi');
               try{
                 final response = await dio.post('https://clearanceknust.koyeb.app/send-mail',
                   data: {
                     "name":  status =="pending"? '${filteredStudentsToClear?[studentIndex]['name']}':'${filteredStudentsDenied?[studentIndex]['name']}',
                     "email":"emmanuellamptey132@gmail.com",
                     "status":status,
                     "message":comment
                   }
                 );
                 if (response.statusCode == 200) {
                   print(response);
                   // If the server did return a 200 OK response,
                   // then parse the JSON
                 } else {
                   throw new Exception('not working');
                 }
               }catch(error){
                 print(error);
               }
              }

              if(status=='Denied'){
                print('hi');
                try{
                  final response = await dio.post('https://clearanceknust.koyeb.app/send-mail',
                      data: {
                        "name": '${filteredStudentsToClear?[studentIndex]['name']}',
                        "email":"emmanuellamptey132@gmail.com",
                        "status":status,
                        "message":comment
                      }
                  );
                  if (response.statusCode == 200) {
                    print(response);
                    // If the server did return a 200 OK response,
                    // then parse the JSON
                  } else {
                    throw new Exception('not working');
                  }
                }catch(error){
                  print(error);
                }
              }


              print(
                  'Clearance status updated successfully for formID: $formID');
            } catch (e) {
              print('Error updating clearance status for formID: $formID');
              print('Exception: $e');
            }
          }

          return
            Scaffold(
              body: Stack(
                children: [
                  // Background Image
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/BGim.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  // Main Content
                 
                  status == "cleared" ? Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(height: 50),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.chevron_left,
                                color: Colors.white,
                              ),
                            )),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      status == "cleared"
                          ? Profile_card(
                              Profile: "Profile",
                              Name: '${filteredStudentsCleared?[studentIndex]['name']}',
                              Program:
                                  '${filteredStudentsCleared?[studentIndex]['program']}',
                              Level:
                                  '${filteredStudentsCleared?[studentIndex]['level']}')
                          : status == "pending"
                              ? Profile_card(
                                  Profile: "Profile",
                                  Name:
                                      '${filteredStudentsToClear?[studentIndex]['name']}',
                                  Program:
                                      '${filteredStudentsToClear?[studentIndex]['program']}',
                                  Level:
                                      '${filteredStudentsToClear?[studentIndex]['level']}')
                              : Profile_card(
                                  Profile: "Profile",
                                  Name:
                                      '${filteredStudentsDenied?[studentIndex]['name']}',
                                  Program:
                                      '${filteredStudentsDenied?[studentIndex]['program']}',
                                  Level:
                                      '${filteredStudentsDenied?[studentIndex]['level']}'),
                      const SizedBox(height: 20),
                      status == "cleared"
                          ? StudentInfoCard(
                              Fees:
                                  '${filteredStudentsCleared?[studentIndex]['feesPaid']}',
                              Books:
                                  '${filteredStudentsCleared?[studentIndex]['owingBooks']}',
                              Deferment:
                                  '${filteredStudentsCleared?[studentIndex]["defermentStatus"]}',
                              Trailed:
                                  '${filteredStudentsCleared?[studentIndex]["trails"]}',
                              Project:
                                  '${filteredStudentsCleared?[studentIndex]["projects"]}',
                              Internship:
                                  '${filteredStudentsCleared?[studentIndex]["internships"]}')
                          : status == "pending"
                              ? StudentInfoCard(
                                  Fees:
                                      '${filteredStudentsToClear?[studentIndex]['feesPaid']}',
                                  Books:
                                      '${filteredStudentsToClear?[studentIndex]['owingBooks']}',
                                  Deferment:
                                      '${filteredStudentsToClear?[studentIndex]["defermentStatus"]}',
                                  Trailed:
                                      '${filteredStudentsToClear?[studentIndex]["trails"]}',
                                  Project:
                                      '${filteredStudentsToClear?[studentIndex]["projects"]}',
                                  Internship:
                                      '${filteredStudentsToClear?[studentIndex]["internships"]}')
                              : StudentInfoCard(
                                  Fees:
                                      '${filteredStudentsDenied?[studentIndex]['feesPaid']}',
                                  Books:
                                      '${filteredStudentsDenied?[studentIndex]['owingBooks']}',
                                  Deferment:
                                      '${filteredStudentsDenied?[studentIndex]["defermentStatus"]}',
                                  Trailed:
                                      '${filteredStudentsDenied?[studentIndex]["trails"]}',
                                  Project:
                                      '${filteredStudentsDenied?[studentIndex]["projects"]}',
                                  Internship:
                                      '${filteredStudentsDenied?[studentIndex]["internships"]}'),
                      const SizedBox(
                        height: 20,
                      ),
                      status != "cleared" ?
                      const Text(
                        "Have any comments?",
                        style: TextStyle(color: Colors.white),
                      ): Expanded(child: Container()),
                      const SizedBox(height: 20),
                      status != "cleared" ?
                      TextField(
                        controller: _controller,
                        cursorColor: Colors.white,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Leave a message",
                          hintStyle: const TextStyle(color: Colors.white54),
                          filled: true,
                          fillColor: Colors.white12,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ) : Expanded(child: Container()),

                      const SizedBox(height: 20),
                      Row(

                        mainAxisAlignment: status == "pending" ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.center,
                        children: [

                          status != "cleared" ?
                          ElevatedButton(
                            onPressed: () async {
                              String message = _controller.text;
                              if(status == "denied"){
                                var formID = await getFormID(
                                    filteredStudentsDenied[studentIndex]["studentID"]);
                                try {
                                  updateClearanceStatus(
                                      formID as String, true, message);
                                  QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.success,);
                                  print("Update Successful");
                                } catch (e) {
                                  QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.error);
                                  print("Update failed: $e");
                                }
                              }

                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF218418),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "Clear",
                              style: TextStyle(color: Colors.white),
                            ),
                          ) : Container(),
                          status == "pending" ?
                          ElevatedButton(
                            onPressed: () async {
                              String message = _controller.text;
                              if(status == "pending"){
                                var formID = await getFormID(
                                    filteredStudentsToClear[studentIndex]["studentID"]);
                                try {
                                  updateClearanceStatus(
                                      formID as String, false, message);
                                  print("Update Successful");
                                  Navigator.pop(context);
                                  QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.success);

                                } catch (e) {
                                  print("Update failed: $e");
                                  QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.error);
                                }
                              }

                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFBC0000),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text("Deny",
                                style: TextStyle(color: Colors.white)),
                          ) : Container(),
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      )
                      // Status Information
                      // Expanded(
                      //   child: Container(
                      //     padding: EdgeInsets.all(16.0),
                      //     margin: EdgeInsets.symmetric(horizontal: 16.0),
                      //     decoration: BoxDecoration(
                      //       color: Colors.blueGrey[900],
                      //       borderRadius: BorderRadius.circular(20),
                      //     ),
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         _buildStatusRow("ACCOUNTANT", "FEES PAID", "-3,056", true),
                      //         SizedBox(height: 10),
                      //         _buildStatusRow("LIBRARY", "0 ITEMS TO RETURN", "0", false),
                      //         SizedBox(height: 10),
                      //         _buildStatusRow("DEFERMENT STATUS", "0", "0", false),
                      //         SizedBox(height: 10),
                      //         _buildStatusRow("PROJECT STATUS", "COMPLETED", "", false),
                      //         SizedBox(height: 10),
                      //         _buildStatusRow("INTERNSHIP REQUIREMENT", "COMPLETED", "", false),
                      //         Spacer(),
                      //         // Comments Section
                      //         Text(
                      //           "Have any comments?",
                      //           style: TextStyle(color: Colors.white),
                      //         ),
                      //         SizedBox(height: 10),
                      //         TextField(
                      //           decoration: InputDecoration(
                      //             hintText: "Leave a message",
                      //             hintStyle: TextStyle(color: Colors.white54),
                      //             filled: true,
                      //             fillColor: Colors.white12,
                      //             border: OutlineInputBorder(
                      //               borderRadius: BorderRadius.circular(10),
                      //               borderSide: BorderSide.none,
                      //             ),
                      //           ),
                      //         ),
                      //         SizedBox(height: 20),
                      //         // Buttons
                      //         Row(
                      //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //           children: [
                      //             ElevatedButton(
                      //               onPressed: () {},
                      //               style: ElevatedButton.styleFrom(
                      //                 backgroundColor: Colors.green,
                      //                 shape: RoundedRectangleBorder(
                      //                   borderRadius: BorderRadius.circular(20),
                      //                 ),
                      //               ),
                      //               child: Text("Clear"),
                      //             ),
                      //             ElevatedButton(
                      //               onPressed: () {},
                      //               style: ElevatedButton.styleFrom(
                      //                 backgroundColor: Colors.red,
                      //                 shape: RoundedRectangleBorder(
                      //                   borderRadius: BorderRadius.circular(20),
                      //                 ),
                      //               ),
                      //               child: Text("Deny"),
                      //             ),
                      //           ],
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ) : ListView(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const SizedBox(height: 50),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.chevron_left,
                                    color: Colors.white,
                                  ),
                                )),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          status == "cleared"
                              ? Profile_card(
                              Profile: "Profile",
                              Name: '${filteredStudentsCleared?[studentIndex]['name']}',
                              Program:
                              '${filteredStudentsCleared?[studentIndex]['program']}',
                              Level:
                              '${filteredStudentsCleared?[studentIndex]['level']}')
                              : status == "pending"
                              ? Profile_card(
                              Profile: "Profile",
                              Name:
                              '${filteredStudentsToClear?[studentIndex]['name']}',
                              Program:
                              '${filteredStudentsToClear?[studentIndex]['program']}',
                              Level:
                              '${filteredStudentsToClear?[studentIndex]['level']}')
                              : Profile_card(
                              Profile: "Profile",
                              Name:
                              '${filteredStudentsDenied?[studentIndex]['name']}',
                              Program:
                              '${filteredStudentsDenied?[studentIndex]['program']}',
                              Level:
                              '${filteredStudentsDenied?[studentIndex]['level']}'),
                          const SizedBox(height: 20),
                          status == "cleared"
                              ? StudentInfoCard(
                              Fees:
                              '${filteredStudentsCleared?[studentIndex]['feesPaid']}',
                              Books:
                              '${filteredStudentsCleared?[studentIndex]['owingBooks']}',
                              Deferment:
                              '${filteredStudentsCleared?[studentIndex]["defermentStatus"]}',
                              Trailed:
                              '${filteredStudentsCleared?[studentIndex]["trails"]}',
                              Project:
                              '${filteredStudentsCleared?[studentIndex]["projects"]}',
                              Internship:
                              '${filteredStudentsCleared?[studentIndex]["internships"]}')
                              : status == "pending"
                              ? StudentInfoCard(
                              Fees:
                              '${filteredStudentsToClear?[studentIndex]['feesPaid']}',
                              Books:
                              '${filteredStudentsToClear?[studentIndex]['owingBooks']}',
                              Deferment:
                              '${filteredStudentsToClear?[studentIndex]["defermentStatus"]}',
                              Trailed:
                              '${filteredStudentsToClear?[studentIndex]["trails"]}',
                              Project:
                              '${filteredStudentsToClear?[studentIndex]["projects"]}',
                              Internship:
                              '${filteredStudentsToClear?[studentIndex]["internships"]}')
                              : StudentInfoCard(
                              Fees:
                              '${filteredStudentsDenied?[studentIndex]['feesPaid']}',
                              Books:
                              '${filteredStudentsDenied?[studentIndex]['owingBooks']}',
                              Deferment:
                              '${filteredStudentsDenied?[studentIndex]["defermentStatus"]}',
                              Trailed:
                              '${filteredStudentsDenied?[studentIndex]["trails"]}',
                              Project:
                              '${filteredStudentsDenied?[studentIndex]["projects"]}',
                              Internship:
                              '${filteredStudentsDenied?[studentIndex]["internships"]}'),
                          const SizedBox(
                            height: 20,
                          ),
                          status != "cleared" ?
                          const Text(
                            "Have any comments?",
                            style: TextStyle(color: Colors.white),
                          ): Expanded(child: Container()),
                          const SizedBox(height: 20),
                          status != "cleared" ?
                          TextField(
                            controller: _controller,
                            cursorColor: Colors.white,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "Leave a message",
                              hintStyle: const TextStyle(color: Colors.white54),
                              filled: true,
                              fillColor: Colors.white12,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ) : Expanded(child: Container()),

                          const SizedBox(height: 20),
                          Row(

                            mainAxisAlignment: status == "pending" ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.center,
                            children: [

                              status != "cleared" ?
                              ElevatedButton(
                                onPressed: () async {
                                  String message = _controller.text;
                                  if(status == "denied"){
                                    var formID = await getFormID(
                                        filteredStudentsDenied[studentIndex]["studentID"]);
                                    try {
                                      updateClearanceStatus(
                                          formID as String, true, message);
                                      QuickAlert.show(
                                        context: context,
                                        type: QuickAlertType.success,);
                                      print("Update Successful");
                                    } catch (e) {
                                      QuickAlert.show(
                                          context: context,
                                          type: QuickAlertType.error);
                                      print("Update failed: $e");
                                    }
                                  }

                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF218418),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  "Clear",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ) : Container(),
                              status == "pending" ?
                              ElevatedButton(
                                onPressed: () async {
                                  String message = _controller.text;
                                  if(status == "pending"){
                                    var formID = await getFormID(
                                        filteredStudentsToClear[studentIndex]["studentID"]);
                                    try {
                                      updateClearanceStatus(
                                          formID as String, false, message);
                                      print("Update Successful");
                                      Navigator.pop(context);
                                      QuickAlert.show(
                                          context: context,
                                          type: QuickAlertType.success);

                                    } catch (e) {
                                      print("Update failed: $e");
                                      QuickAlert.show(
                                          context: context,
                                          type: QuickAlertType.error);
                                    }
                                  }

                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFBC0000),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text("Deny",
                                    style: TextStyle(color: Colors.white)),
                              ) : Container(),
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                          )
                          // Status Information
                          // Expanded(
                          //   child: Container(
                          //     padding: EdgeInsets.all(16.0),
                          //     margin: EdgeInsets.symmetric(horizontal: 16.0),
                          //     decoration: BoxDecoration(
                          //       color: Colors.blueGrey[900],
                          //       borderRadius: BorderRadius.circular(20),
                          //     ),
                          //     child: Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         _buildStatusRow("ACCOUNTANT", "FEES PAID", "-3,056", true),
                          //         SizedBox(height: 10),
                          //         _buildStatusRow("LIBRARY", "0 ITEMS TO RETURN", "0", false),
                          //         SizedBox(height: 10),
                          //         _buildStatusRow("DEFERMENT STATUS", "0", "0", false),
                          //         SizedBox(height: 10),
                          //         _buildStatusRow("PROJECT STATUS", "COMPLETED", "", false),
                          //         SizedBox(height: 10),
                          //         _buildStatusRow("INTERNSHIP REQUIREMENT", "COMPLETED", "", false),
                          //         Spacer(),
                          //         // Comments Section
                          //         Text(
                          //           "Have any comments?",
                          //           style: TextStyle(color: Colors.white),
                          //         ),
                          //         SizedBox(height: 10),
                          //         TextField(
                          //           decoration: InputDecoration(
                          //             hintText: "Leave a message",
                          //             hintStyle: TextStyle(color: Colors.white54),
                          //             filled: true,
                          //             fillColor: Colors.white12,
                          //             border: OutlineInputBorder(
                          //               borderRadius: BorderRadius.circular(10),
                          //               borderSide: BorderSide.none,
                          //             ),
                          //           ),
                          //         ),
                          //         SizedBox(height: 20),
                          //         // Buttons
                          //         Row(
                          //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //           children: [
                          //             ElevatedButton(
                          //               onPressed: () {},
                          //               style: ElevatedButton.styleFrom(
                          //                 backgroundColor: Colors.green,
                          //                 shape: RoundedRectangleBorder(
                          //                   borderRadius: BorderRadius.circular(20),
                          //                 ),
                          //               ),
                          //               child: Text("Clear"),
                          //             ),
                          //             ElevatedButton(
                          //               onPressed: () {},
                          //               style: ElevatedButton.styleFrom(
                          //                 backgroundColor: Colors.red,
                          //                 shape: RoundedRectangleBorder(
                          //                   borderRadius: BorderRadius.circular(20),
                          //                 ),
                          //               ),
                          //               child: Text("Deny"),
                          //             ),
                          //           ],
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ],
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

  Widget _buildStatusRow(
      String title, String status, String value, bool isNegative) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              status,
              style: TextStyle(
                color: isNegative ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (value.isNotEmpty)
              Text(
                value,
                style: TextStyle(
                  color: isNegative ? Colors.red : Colors.green,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
