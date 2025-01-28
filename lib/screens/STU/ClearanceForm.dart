import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../Firebase_Queries/Firebase_download.dart';
import '../../components/downScroll.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';




class Clearanceform extends StatefulWidget {
  final studentID;

  const Clearanceform({super.key,required this.studentID});

  @override
  State<Clearanceform> createState() => _ClearanceformState();
}

class _ClearanceformState extends State<Clearanceform> {


  // void _scrollableModalSheet(BuildContext context) {
  //   showModalBottomSheet(
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(
  //         top: Radius.circular(30),
  //       ),
  //     ),
  //       isScrollControlled: true,
  //       context: context,
  //       builder: (context) =>
  //   DraggableScrollableSheet(
  //     initialChildSize: 0.4,
  //     minChildSize: 0.3,
  //     maxChildSize: 0.9,
  //     expand: false,
  //     builder: (context, scrollableController) =>
  //     SingleChildScrollView(
  //       child: Downscroll(),
  //       controller: scrollableController,
  //     ),
  //   ));
  // }



  @override
  Widget build(BuildContext context) {
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
    final student = data['student'] as Map<String, dynamic>?;
    final clearanceForm = data['ClearanceForms_Collection'] as List<dynamic>?;
    final feesStatus = '${clearanceForm?[0]['feesStatus']}';
    final hodStatus = '${clearanceForm?[0]['hodStatus']}';
    final libraryStatus = '${clearanceForm?[0]['libraryStatus']}';
    Future<void> generateAndSavePdf(Map<String, dynamic> invoiceData) async {
      final backgroundImage = pw.MemoryImage(
        (await rootBundle.load('assets/images/untitled-1_245.png')).buffer.asUint8List(),
      );

      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return
              pw.Stack(
                  children: [
                    // Positioned background image
                    pw.Positioned.fill(
                      child: pw.Image(
                        backgroundImage,
                        fit: pw.BoxFit.cover,
                      ),
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        // Your PDF content here
                        pw.Text("KWAME NKRUMAH UNIVERSITY of SCIENCE and TECHNOLOGY", style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(height: 10),
                        pw.Text("Clearance Invoice", style: pw.TextStyle(fontSize: 18)),
                        pw.SizedBox(height: 10),
                        pw.Text("Invoice Number: ${invoiceData['invoiceNumber']}"),
                        pw.Text("Date: ${invoiceData['date']}"),
                        pw.SizedBox(height: 20),
                        pw.Text("Student Information:", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                        pw.Text("Name: ${invoiceData['studentName']}"),
                        pw.Text("Student ID: ${invoiceData['studentId']}"),
                        pw.Text("Department: ${invoiceData['department']}"),
                        pw.SizedBox(height: 20),
                        pw.Text("Clearance Details:", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                        pw.Text("Library Clearance:"),
                        pw.Text("  Status: ${invoiceData['library']['status']}"),
                        pw.Text("  Remarks: ${invoiceData['library']['remarks']}"),
                        pw.Text("  Date: ${invoiceData['library']['date']}"),
                        pw.Text("  Approved by: ${invoiceData['library']['approvedBy']}"),
                        pw.SizedBox(height: 10),
                        pw.Text("HOD Clearance:"),
                        pw.Text("  Status: ${invoiceData['hod']['status']}"),
                        pw.Text("  Remarks: ${invoiceData['hod']['remarks']}"),
                        pw.Text("  Date: ${invoiceData['hod']['date']}"),
                        pw.Text("  Approved by: ${invoiceData['hod']['approvedBy']}"),
                        pw.SizedBox(height: 10),
                        pw.Text("Fees Clearance:"),
                        pw.Text("  Status: ${invoiceData['fees']['status']}"),
                        pw.Text("  Remarks: ${invoiceData['fees']['remarks']}"),
                        pw.Text("  Date: ${invoiceData['fees']['date']}"),
                        pw.Text("  Approved by: ${invoiceData['fees']['approvedBy']}"),
                        pw.SizedBox(height: 20),
                        pw.Text("Overall Clearance Status: ${invoiceData['overallStatus']}"),
                        pw.SizedBox(height: 10),
                        pw.Text("Final Remarks: ${invoiceData['finalRemarks']}"),
                        pw.SizedBox(height: 30),
                        pw.Text("Contact Information:"),
                        pw.Text("Email: emmanuellamptey132@gmail.com"),
                        pw.Text("Phone: +233506607499"),
                        pw.Text("Office Hours: Mon-Fri 9:00 AM - 5:00 PM"),
                        pw.SizedBox(height: 20),
                        pw.Text("Signature: ______________________________"),
                      ],
                    )]
              );

          },
        ),
      );

      // Get the downloads directory
      final directory = await getExternalStorageDirectory();
      final filePath = "${directory!.path}/clearance_invoice.pdf";

      // Save the PDF to the device's downloads directory
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());
      print(pdf);



      print('PDF saved to $filePath');
    }
    Future<void> generateAndSendMailPdf(Map<String, dynamic> invoiceData) async {
      final backgroundImage = pw.MemoryImage(
        (await rootBundle.load('assets/images/untitled-1_245.png')).buffer.asUint8List(),
      );

      // final pdf = pw.Document();
      //
      // pdf.addPage(
      //   pw.Page(
      //     build: (pw.Context context) {
      //       return
      //         pw.Stack(
      //             children: [
      //               // Positioned background image
      //               pw.Positioned.fill(
      //                 child: pw.Image(
      //
      //                   backgroundImage,
      //                   fit: pw.BoxFit.cover,
      //                 ),
      //               ),
      //               pw.Column(
      //                 crossAxisAlignment: pw.CrossAxisAlignment.start,
      //                 children: [
      //                   // Your PDF content here
      //                   pw.Text("KWAME NKRUMAH UNIVERSITY of SCIENCE and TECHNOLOGY", style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
      //                   pw.SizedBox(height: 10),
      //                   pw.Text("Clearance Invoice", style: pw.TextStyle(fontSize: 18)),
      //                   pw.SizedBox(height: 10),
      //                   pw.Text("Invoice Number: ${invoiceData['invoiceNumber']}"),
      //                   pw.Text("Date: ${invoiceData['date']}"),
      //                   pw.SizedBox(height: 20),
      //                   pw.Text("Student Information:", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
      //                   pw.Text("Name: ${invoiceData['studentName']}"),
      //                   pw.Text("Student ID: ${invoiceData['studentId']}"),
      //                   pw.Text("Department: ${invoiceData['department']}"),
      //                   pw.SizedBox(height: 20),
      //                   pw.Text("Clearance Details:", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
      //                   pw.Text("Library Clearance:"),
      //                   pw.Text("  Status: ${invoiceData['library']['status']}"),
      //                   pw.Text("  Remarks: ${invoiceData['library']['remarks']}"),
      //                   pw.Text("  Date: ${invoiceData['library']['date']}"),
      //                   pw.Text("  Approved by: ${invoiceData['library']['approvedBy']}"),
      //                   pw.SizedBox(height: 10),
      //                   pw.Text("HOD Clearance:"),
      //                   pw.Text("  Status: ${invoiceData['hod']['status']}"),
      //                   pw.Text("  Remarks: ${invoiceData['hod']['remarks']}"),
      //                   pw.Text("  Date: ${invoiceData['hod']['date']}"),
      //                   pw.Text("  Approved by: ${invoiceData['hod']['approvedBy']}"),
      //                   pw.SizedBox(height: 10),
      //                   pw.Text("Fees Clearance:"),
      //                   pw.Text("  Status: ${invoiceData['fees']['status']}"),
      //                   pw.Text("  Remarks: ${invoiceData['fees']['remarks']}"),
      //                   pw.Text("  Date: ${invoiceData['fees']['date']}"),
      //                   pw.Text("  Approved by: ${invoiceData['fees']['approvedBy']}"),
      //                   pw.SizedBox(height: 20),
      //                   pw.Text("Overall Clearance Status: ${invoiceData['overallStatus']}"),
      //                   pw.SizedBox(height: 10),
      //                   pw.Text("Final Remarks: ${invoiceData['finalRemarks']}"),
      //                   pw.SizedBox(height: 30),
      //                   pw.Text("Contact Information:"),
      //                   pw.Text("Email: emmanuellamptey132@gmail.com"),
      //                   pw.Text("Phone: +233506607499"),
      //                   pw.Text("Office Hours: Mon-Fri 9:00 AM - 5:00 PM"),
      //                   pw.SizedBox(height: 20),
      //                   pw.Text("Signature: ______________________________"),
      //
      //                 ],
      //               )]
      //         );
      //
      //     },
      //   ),
      // );
      //
      // // Get the downloads directory
      // final directory = await getExternalStorageDirectory();
      // final filePath = "${directory!.path}/clearance_invoice.pdf";
       final dio = Dio();
      // // Save the PDF to the device's downloads directory
      // final File file = File(filePath);
      // print(pdf.toString());
      try{
        final response = await dio.post('https://clearanceknust.koyeb.app/send-mailpdf',
            data: {
              "name":  '${student?['Name']}',
              "email":"emmanuellamptey132@gmail.com",
              "data": invoiceData
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


      // print('PDF saved to $filePath');
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage("assets/images/BGim.png"), fit: BoxFit.fill),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                const Text("Clearance Form",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 23,color: Colors.white),),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                        margin: const EdgeInsets.only(left: 20),
                        child: GestureDetector(
                            onTap: ()=>Navigator.pop(context),
                            child: const Icon(Icons.chevron_left,color: Colors.white,)))),
                const SizedBox(height: 15,),
                Container(
                  padding: const EdgeInsets.only(top: 40),
                    height: 710,
                    decoration:
                    const BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
                      color: Color(0xFFFAFAFA),
                    ),
                    child: Expanded(
                        child: Center(
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                height:132 ,width: 375,
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(30)),
                                  color: Color(0xFFD7E4E6)),
                                child: const Text("Click here to get your clearance form. You can download via email or through your mobile device",style: TextStyle(color: Color(0xFF003F4D),fontWeight: FontWeight.w600),),
                              ),
                              const SizedBox(height: 68,),
                              GestureDetector(

                                onTap: () async {
                                  // Generate and save PDF to device
                                  Map<String, dynamic> invoiceData = {



                                    'invoiceNumber': 'INV12345',
                                    'date': '2024-08-23',
                                    'studentName': '${student?['Name']}',
                                    'studentId': '${student?['Name']}',
                                    'department': 'Computer Science',
                                    'library': {
                                      'status': '${clearanceForm?[0]['libraryStatus']}',
                                      'remarks': '${clearanceForm?[0]['hodComment']}',
                                      'date': '2024-08-22',
                                      'approvedBy': 'Mr. Smith',
                                    },
                                    'hod': {
                                      'status': '${clearanceForm?[0]['hodStatus']}',
                                      'remarks': '${clearanceForm?[0]['hodComment']}',
                                      'date': '2024-08-21',
                                      'approvedBy': 'Dr. Johnson',
                                    },
                                    'fees': {
                                      'status': '${clearanceForm?[0]['feesStatus']}',
                                      'remarks': '${clearanceForm?[0]['hodComment']}',
                                      'date': '2024-08-20',
                                      'approvedBy': 'Ms. Brown',
                                    },
                                    'overallStatus': hodStatus =="Cleared" && feesStatus=="Cleared" && libraryStatus == "Cleared"? "Cleared":"Pending" ,
                                    'finalRemarks': 'Please clear pending fees.',
                                  };
                                  await generateAndSavePdf(invoiceData);
                                  await generateAndSendMailPdf(invoiceData);

                                  // Optionally, display a message or snackbar to notify the user
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text('Invoice saved to device!'),
                                  ));
                                },

                                child: Container(

                                  padding: const EdgeInsets.all(20),
                                  height:165 ,width: 313,
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(30)),
                                      color: Color(0xFFD7E4E6)),
                                child: const Center(child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Get Clearance Form",style: TextStyle(color: Color(0xFF003F4D),fontSize: 23,fontWeight: FontWeight.bold),),
                                    SizedBox(height: 5,),
                                    Icon(Icons.file_open,color:Color(0xFF003F4D),)
                                  ],
                                )),

                                ),
                              ),
                            ],
                          ),
                        ))),


              ],
            )

          ],
        ),
      ),
    );

    }
    },
    );


  }
}

