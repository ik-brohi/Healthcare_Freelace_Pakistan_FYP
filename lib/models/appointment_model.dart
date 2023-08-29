import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  final String appointID;
  final String appointNo;
  final String trackNo;
  final String details;
  final DateTime date;
  final String status;
  final String documentId;
  final String doctorName;// Add this field to store the document ID
  final String doctorEmail;// Add this field to store the document ID

  Appointment({
    required this.appointID,
    required this.appointNo,
    required this.trackNo,
    required this.details,
    required this.date,
    required this.status,
    required this.documentId,
    required this.doctorName,
    required this.doctorEmail,
  });

  factory Appointment.fromSnapshot(QueryDocumentSnapshot<Object?> doc) {
    Map data = doc.data() as Map;
    return Appointment(
      appointID: data?['appointID'],
      appointNo: data?['appointNo'],
      trackNo: data?['trackNo'],
      details: data?['details'],
      date: (data?['date'] as Timestamp).toDate(),
      status: data?['status'],
      documentId: doc.id,
      doctorName: (data?['doctor']),
      doctorEmail: (data?['doctorEmail']),

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointID': appointID,
      'appointNo': appointNo,
      'trackNo': trackNo,
      'details': details,
      'date': date,
      'status': status,
      'doctor' : doctorName,
      'doctorEmail' : doctorEmail
    };
  }

}
Future<List<Appointment>> getAppointmentsByStatus(String status) async {
  try {
    final appointmentsCollection = FirebaseFirestore.instance.collection('appointments');

    // Query the appointments collection to find appointments with the specified status
    final querySnapshot = await appointmentsCollection.where('status', isEqualTo: status).get();

    // Convert the DocumentSnapshots into Appointment objects
    final appointments = querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Appointment(
        appointID: data?['appointID'],
        appointNo: data?['appointNo'],
        trackNo: data?['trackNo'],
        details: data?['details'],
        date: (data?['date'] as Timestamp).toDate(),
        status: data?['status'],
        documentId: doc.id,
        doctorName: (data?['doctor']),
        doctorEmail: (data?['doctorEmail']),
      );
    }).toList();

    return appointments;
  } catch (error) {
    print("Error fetching appointments: $error");
    // Handle the error as needed
    return [];
  }
}
