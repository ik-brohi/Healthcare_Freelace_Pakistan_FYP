import 'package:cloud_firestore/cloud_firestore.dart';

import '/Widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';




Widget processAppointment(
    String appointID,
    String doctorName,
    String details,
    DateTime date,
    String status,
    String appointNo,
    context) {
  Alignment alignLeft = Alignment.topLeft;



  return Container(
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
                      color: Colors.blue[600],
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
  );
}
