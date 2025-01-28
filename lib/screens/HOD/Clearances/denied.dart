import 'package:flutter/material.dart';
import 'package:clearanceapp/screens/HOD/Hod_StudentProfile.dart';

import '../../../Firebase_Queries/Firebase_download.dart';
import '../../../components/Widgets.dart';

class Denied extends StatefulWidget {
  final String HodID;
  final List StudentID;
  const Denied({required this.HodID, super.key,required this.StudentID});

  @override
  State<Denied> createState() => _DeniedState();
}

class _DeniedState extends State<Denied> {
  @override
  Widget build(BuildContext context) {
    return
      FutureBuilder<Map<String, dynamic>>(
        future: getHodData(widget.HodID,widget.StudentID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(color: Colors.white,);
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            var data = snapshot.data!;
            var studentsToClear = data['studentsToClear'];
            var clearedStudents = data['clearedStudents'];
            var deniedStudents = data['deniedStudents'];
            final List Departmentstudents = data['departmentStudents'];
            final List filteredStudentsDenied = deniedStudents.where((student) {
              return Departmentstudents.any((deptStudent) => deptStudent['studentID'] == student['studentID']);
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
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: const Text('DENIED CLEARANCE',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white),),
                ),
              ),
              Spacer(),
              Text(
                '${filteredStudentsDenied.length} students',
                style:
                const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ) ],
          ),

          SizedBox(height: 8,),
          filteredStudentsDenied.isEmpty
              ? const Expanded(
            child:const Center(
              child:const Text("Nothing to see here"),
            ),
          ):
          ListView.builder(

            shrinkWrap: true,
            itemCount: filteredStudentsDenied.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                final studentID = filteredStudentsDenied[index]["referenceID"];
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentProfile(
                      studentIndex: index,
                      studentID: widget.StudentID,
                      HodID: widget.HodID,
                    ),
                  ),
                );
              },
              child: Clearance_card(
                Name: filteredStudentsDenied[index]["name"],
                Course: filteredStudentsDenied[index]["program"],
                Profile: filteredStudentsDenied[index]["defermentStatus"],
                Student_num: filteredStudentsDenied[index]["referenceID"],
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
