import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthcare_pakistan/data.dart';

import '/Widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';


// Function to update the status in Firebase
Future<void> updateAppointmentStatus(String appointID, String status) async {
  try {
    final appointmentsCollection = FirebaseFirestore.instance.collection('appointments');

    // Query the appointments collection to find the appointment with the matching appointID
    final appointmentSnapshot = await appointmentsCollection.where('appointID', isEqualTo: appointID).get();

    // Check if any document with the given appointID was found
    if (appointmentSnapshot.docs.isNotEmpty) {
      final appointmentDoc = appointmentSnapshot.docs.first;

      // Reference to the document containing the appointment
      final appointmentRef = appointmentsCollection.doc(appointmentDoc.id);

      // Update the status field
      await appointmentRef.update({'status': status});
    } else {
      print("No appointment found with appointID: $appointID");
    }
  } catch (error) {
    print("Error updating appointment status: $error");
    // Handle the error as needed
  }
}


Widget pendingAppointment(
    String appointID,
    String doctorName,
    String details,
    DateTime date,
    String status,
    String appointNo,
    context) {
  Alignment alignLeft = Alignment.topLeft;

  void _showAppointmentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Appointment $appointID"),
          content: Text("Do you want to accept or reject the appointment?"),
          actions: [
            ElevatedButton(
              onPressed: () async {
                // Update status to "process" in Firebase
                await updateAppointmentStatus(appointID, "process");
                Navigator.pop(context); // Close the dialog
              },
              child: Text("Accept"),
            ),
            ElevatedButton(
              onPressed: () async {
                // Update status to "cancelled" in Firebase
                await updateAppointmentStatus(appointID, "cancelled");
                Navigator.pop(context); // Close the dialog
              },
              child: Text("Reject"),
            ),
          ],
        );
      },
    );
  }

  return GestureDetector(
    onTap: currentRole == 'doctor' ? _showAppointmentDialog : null,
    child: Container(
      width: double.infinity,
      height: countHeight(155, context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 221, 221, 221),
            blurRadius: 2.0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Align(
              alignment: alignLeft,
              child: Container(
                child: Row(
                  children: [
                    Text(
                      "Appointment No : $appointNo",
                      style: GoogleFonts.openSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 18.0,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
            Align(
              alignment: alignLeft,
              child: Container(
                child: Row(
                  children: [
                    Text(
                      "Doctor : ",
                      style: GoogleFonts.openSans(
                        fontWeight: FontWeight.normal,
                        fontSize: 17.0,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      width: countWidth(15, context),
                    ),
                    Text(
                      "$doctorName",
                      style: GoogleFonts.openSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: alignLeft,
              child: Container(
                child: Row(
                  children: [
                    Text(
                      "Details : ",
                      style: GoogleFonts.openSans(
                        fontWeight: FontWeight.normal,
                        fontSize: 17.0,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      width: countWidth(15, context),
                    ),
                    Text(
                      "$details",
                      style: GoogleFonts.openSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: alignLeft,
              child: Container(
                child: Row(
                  children: [
                    Text(
                      "Date : \t\t\t\t",
                      style: GoogleFonts.openSans(
                        fontWeight: FontWeight.normal,
                        fontSize: 17.0,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      width: countWidth(15, context),
                    ),
                    Text(
                      DateFormat('yyyy-MM-dd').format(date),
                      style: GoogleFonts.openSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            Align(
              alignment: alignLeft,
              child: Container(
                child: Row(
                  children: [
                    Spacer(),
                    Text(
                      "$status".toUpperCase(),
                      style: GoogleFonts.openSans(
                        fontWeight: FontWeight.w600,
                        color: Colors.green[600],
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
