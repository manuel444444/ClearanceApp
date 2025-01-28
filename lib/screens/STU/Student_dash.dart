import 'package:clearanceapp/components/Widgets.dart';
import 'package:clearanceapp/screens/STU/ClearanceForm.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Firebase_Queries/Firebase_download.dart';

class Student_Dash extends StatefulWidget {

  final String studentID;
  const Student_Dash({super.key,required this.studentID});

  @override
  State<Student_Dash> createState() => _Student_DashState();
}

class _Student_DashState extends State<Student_Dash> {

  final int truncateLength = 50;

  @override
  Widget build(BuildContext context) {
    print('Student ID: ${widget.studentID}');
    return FutureBuilder<Map<String, dynamic>>(
      future: getStudentData(widget.studentID),
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
                Center(child: const CircularProgressIndicator(color: Colors.white,))
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          var data = snapshot.data!;
          // var student = data['student'];
          // var clearanceForm = data['ClearanceForms_Collection'];
          // var clearanceSteps = data['ClearanceSteps'];
          final student = data['student'] as Map<String, dynamic>?; // Assuming 'student' is a Map
          final clearanceForm = data['ClearanceForms_Collection'] as List<dynamic>?; // Assuming this is a List
          final clearanceSteps = data['ClearanceSteps'] as Map<String, dynamic>?; // Assuming this is a Map
          var status = clearanceForm?[0]['status'];
          var profilePictureUrl = '${student?['profilePicture']}' ?? '';
          print("My student $profilePictureUrl");
          print(clearanceSteps);
          print(clearanceForm);
          bool _isButtonVisible = true;
          void _handleClick() {
            setState(() {
              _isButtonVisible = false;
            });
          }
          Future<void> updateRequest() async {
            var formID = await getFormID(widget.studentID);
            try {
              // Update the main form document
              await FirebaseFirestore.instance
                  .collection('ClearanceForms_Collection')
                  .doc(formID)
                  .update({
                'request': "Sent",
              });
              _handleClick();
              print('Request status updated successfully for formID: $formID');

              QuickAlert.show(
                context: context,
                type: QuickAlertType.success,
                text: "Request sent successfully",
              );

              // Call setState to update the visibility of the button

            } catch (e) {
              print('Error updating request status for formID: $formID');
              print('Exception: $e');
              QuickAlert.show(
                context: context,
                type: QuickAlertType.error,
                text: "Request not sent",
              );
            }
          }

          return MaterialApp(
      debugShowCheckedModeBanner: false,
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                   Dash_title(text: "Home", studentID: widget.studentID),
                  const SizedBox(
                    height: 25,
                  ),
                  Curved_card(
                    Fidget: SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 15, bottom: 5),
                              child:  Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Good morning,",
                                        style: TextStyle(
                                          color: Color(0xFF003F4D),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                          '${student?['Name']}',
                                        style: TextStyle(
                                          color: Color(0xFF003F4D),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 28,
                                        ),
                                      )
                                    ],
                                  ),
                                  Spacer(),
                                  CircleAvatar(
                                    radius: 50,
                                    backgroundImage: profilePictureUrl.isNotEmpty
                                        ? NetworkImage(profilePictureUrl)
                                        : AssetImage('assets/images/untitled-1_245.png') as ImageProvider,
                                  ),
                                ],
                              ),
                            ),
                            clearanceForm?[0]["request"]=="Unsent"?
                            const Text(
                              "Clearance Request",
                              style: TextStyle(
                                color: Color(0xFF003F4D),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ):Container(),
                            //SizedBox(height: 15,),

                            clearanceForm?[0]["request"]=="Unsent"?
                            ElevatedButton(
                              style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(Colors.black),
                              ),
                              onPressed: () {
                                updateRequest();

                              },
                              child: const Text("SEND REQUEST"),
                            ):
                                Container(),
                            const SizedBox(
                              height: 30,
                            ),
                            const Text(
                              "Clearance Overview",
                              style: TextStyle(
                                color: Color(0xFF003F4D),
                                fontWeight: FontWeight.bold,
                                fontSize: 19,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            OverviewCard(
                                onPressed: (){
                                  QuickAlert.show(context: context, type: QuickAlertType.success);
                                },
                                header: "HOD",
                                status:

                                '${clearanceForm?[0]['hodStatus']}',
                                comments: '${clearanceForm?[0]['hodComment']}'),
                            const SizedBox(
                              height: 13,
                            ),
                            OverviewCard(
                                onPressed: (){
                                  QuickAlert.show(context: context, type: QuickAlertType.success);
                                },
                                header: "LIBRARY",
                                status: '${clearanceForm?[0]['libraryStatus']}',
                                comments: '${clearanceSteps?['data'][2]['departmentID']}'),
                            const SizedBox(
                              height: 13,
                            ),
                            OverviewCard(
                                onPressed: (){
                                  QuickAlert.show(context: context, type: QuickAlertType.success);
                                },
                                header: "ACCOUNTANT",
                                status: '${clearanceForm?[0]['feesStatus']}',
                                comments: '${clearanceSteps?['data'][0]['departmentID']}'),
                            const SizedBox(
                              height: 13,
                            ),
                            OverviewCard(
                                onPressed: (){
                                  QuickAlert.show(context: context, type: QuickAlertType.success);
                                },
                                header: "Registrar",
                                status:

                                '${clearanceForm?[0]['registrarStatus']}',
                                comments: '${clearanceForm?[0]['registrarComment']}'),

                          ],
                        ),
                      ),
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
},
);
  }
}
