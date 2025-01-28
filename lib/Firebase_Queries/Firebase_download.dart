import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map<String, dynamic>> getStudentData(String studentID) async {
  if (studentID.isEmpty) {
    throw ArgumentError('Student ID must not be empty');
  }

  try {
    // Step 1: Get the student document
    DocumentSnapshot studentDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(studentID)
        .get();

    if (!studentDoc.exists) {
      throw Exception('Student document does not exist');
    }

    // Step 2: Query the ClearanceForms collection to get the document where studentID matches
    QuerySnapshot clearanceForm = await FirebaseFirestore.instance
        .collection('ClearanceForms_Collection')
        .where('studentID', isEqualTo: studentID)
        .get();


    if (clearanceForm.docs.isNotEmpty) {
      Map<String, dynamic> clearanceStepsMap = {};

      String formID = clearanceForm.docs.first.id;


      // Loop through the documents in the clearanceForm (though there should be only one)
      for (var formDoc in clearanceForm.docs) {
        print('Clearance Form ID: ${formDoc.id}');
        print('Clearance Form Data: ${formDoc.data()}');
      }

      return {
        'formID': formID,
        'student': studentDoc.data(),
        'ClearanceForms_Collection': clearanceForm.docs.map((doc) => doc.data()).toList(),

      };
    } else {
      print('No Clearance Form found for studentID: $studentID');
    }

    return {
      'student': studentDoc.data(),
      'ClearanceForms': [],
    };
  } catch (e) {
    print('Error getting student or clearance details: $e');
    return {
      'error': 'Error getting student or clearance details: $e',
    };
  }
}

//..........................................................................................................

Future<Map<String, dynamic>> getRegistrarData(String RegistrarID, List studentID) async {
  if (RegistrarID.isEmpty) {
    throw ArgumentError('Registrar ID must not be empty');
  }

  DocumentSnapshot RegistrarDoc = await FirebaseFirestore.instance
      .collection('Users')
      .doc(RegistrarID)
      .get();

  QuerySnapshot registrarstudentsToClear = await FirebaseFirestore.instance
      .collection('ClearanceForms_Collection')
      .where('registrarStatus', isEqualTo: 'Pending')
      .where('request', isEqualTo: "Sent")
      .get();

  QuerySnapshot registrarclearedStudents = await FirebaseFirestore.instance
      .collection('ClearanceForms_Collection')
      .where('registrarStatus', isEqualTo: 'Cleared')
      .where('request', isEqualTo: "Sent")
      .get();

  QuerySnapshot registrardeniedStudents = await FirebaseFirestore.instance
      .collection('ClearanceForms_Collection')
      .where('registrarStatus', isEqualTo: 'Denied')
      .where('request', isEqualTo: "Sent")
      .get();

  // Retrieve and filter the students based on the department IDs
  DocumentSnapshot departmentDoc = await FirebaseFirestore.instance
      .doc('/Users/$RegistrarID/ListofDepartments/$RegistrarID')
      .get();

  List<Map<String, dynamic>> collegeStudents = [];

  if (departmentDoc.exists) {
    // Extract department IDs
    String dept1 = departmentDoc['Dept1'];
    String dept2 = departmentDoc['Dept2'];

    // Create a list of department IDs
    List<String> departmentIds = [dept1, dept2];
    print(departmentIds);
    try {
      QuerySnapshot RStu = await FirebaseFirestore.instance
          .collection('Users')
          .where('Role', isEqualTo: 'Student')
          .where('CollegeId', isEqualTo: RegistrarDoc["CollegeId"])
          .where('DepartmentId', whereIn: departmentIds)
          .get();
      collegeStudents = RStu.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
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

  return {
    'Registrar': RegistrarDoc.data(),
    'studentsToClear': registrarstudentsToClear.docs.map((doc) => doc.data() as Map<String, dynamic>).toList(),
    'clearedStudents': registrarclearedStudents.docs.map((doc) => doc.data() as Map<String, dynamic>).toList(),
    'deniedStudents': registrardeniedStudents.docs.map((doc) => doc.data() as Map<String, dynamic>).toList(),
    'collegeStudents': collegeStudents,
  };
}


//......................................................................................................

Future<Map<String, dynamic>> getHodData(String HodID,List studentID) async {
  if (HodID.isEmpty) {
    throw ArgumentError('Student ID must not be empty');
  }


  DocumentSnapshot HodDoc = await FirebaseFirestore.instance
      .collection('Users')
      .doc(HodID)
      .get();

  // Get students to clear
  QuerySnapshot hodstudentsToClear = await FirebaseFirestore.instance
      .collection('ClearanceForms_Collection')
      .where('hodStatus', isEqualTo: 'Pending' )
      .where('request', isEqualTo: "Sent")
      .get();
  QuerySnapshot HStu = await FirebaseFirestore.instance
      .collection('Users')
      .where('Role', isEqualTo: 'Student')
      .where('DepartmentId', isEqualTo: HodDoc["DepartmentId"])
      // .where('request', isEqualTo: "Sent")
      .get();

  // Get cleared students
  QuerySnapshot hodclearedStudents = await FirebaseFirestore.instance
      .collection('ClearanceForms_Collection')
      .where('hodStatus', isEqualTo: 'Cleared')
      .where('request', isEqualTo: "Sent")
      .get();

  // Get denied students
  QuerySnapshot hoddeniedStudents = await FirebaseFirestore.instance
      .collection('ClearanceForms_Collection')
      .where('hodStatus', isEqualTo: 'Denied')
      .where('request', isEqualTo: "Sent")
      .get();


  return {
    'HOD': HodDoc.data(),
    'studentsToClear': hodstudentsToClear.docs.map((doc) => doc.data()).toList(),
    'clearedStudents': hodclearedStudents.docs.map((doc) => doc.data()).toList(),
    'deniedStudents': hoddeniedStudents.docs.map((doc) => doc.data()).toList(),
    "departmentStudents":HStu.docs.map((doc) => doc.data()).toList(),
  };
}

// ...............................................................................................

Future<String?> getFormID(String studentID) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    QuerySnapshot clearanceFormSnapshot = await firestore
        .collection('ClearanceForms_Collection')
        .where('studentID', isEqualTo: studentID)
        .get();

    if (clearanceFormSnapshot.docs.isNotEmpty) {
      String formID = clearanceFormSnapshot.docs.first.id;
      print('Found formID: $formID');
      return formID;
    } else {
      print('No Clearance Form found for studentID: $studentID');
      return null;
    }
  } catch (e) {
    print('Error getting formID for studentID: $studentID');
    print(e);
    return null;
  }
}























