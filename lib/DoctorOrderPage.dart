
import 'package:healthcare_pakistan/widgets/cancelledAppointment.dart';
import 'package:healthcare_pakistan/widgets/pendAppointment.dart';
import 'package:healthcare_pakistan/widgets/processAppointment.dart';
import 'package:provider/provider.dart';

import '/Widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'models/appoinment_provider.dart';
import 'models/appointment_model.dart';

class DoctorOrderPage extends StatefulWidget {
  @override
  State<DoctorOrderPage> createState() => _DoctorOrderPageState();
}

class _DoctorOrderPageState extends State<DoctorOrderPage> {
  Alignment alignleft = Alignment.topLeft;
  var active = "Active";
  bool delivered = true;
  bool processing = false;
  bool cancelled = false;
  TextStyle activeStyle = TextStyle();

  List<Appointment> cancelledAppointments  = [];
  List<Appointment> pendingAppointments = [];
  List<Appointment> completedAppointments = [];



  @override
  Widget build(BuildContext context) {
    final appointmentProvider = Provider.of<AppointmentProvider>(context);
    appointmentProvider.fetchAppointments();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        title: Text(
          "My Requests",
          style: GoogleFonts.ubuntu(
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(
                height: countHeight(20, context),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () async {
                      setState(() async {
                        delivered = true;
                        processing = false;
                        cancelled = false;
                        active = "Active";

                        pendingAppointments =
                        await getAppointmentsByStatus('pending');
                      });
                    },
                    child: Container(
                      height: countHeight(40, context),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: active == "Active"
                            ? Colors.black
                            : Colors.grey[50],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Pending".toUpperCase(),
                          style: TextStyle(
                            color: active == "Active"
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      setState(() async {
                        delivered = false;
                        processing = true;
                        cancelled = false;
                        active = "Previous";
                        completedAppointments =
                        await getAppointmentsByStatus('process');
                      });
                    },
                    child: Container(
                      height: countHeight(40, context),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: active == "Previous"
                            ? Colors.black
                            : Colors.grey[50],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Process".toUpperCase(),
                          style: TextStyle(
                            color: active == "Previous"
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      setState(() async {
                        delivered = false;
                        processing = false;
                        cancelled = true;
                        active = "Cancelled";
                        cancelledAppointments =
                        await getAppointmentsByStatus('cancelled');
                      });
                    },
                    child: Container(
                      height: countHeight(40, context),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: active == "Cancelled"
                            ? Colors.black
                            : Colors.grey[50],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Cancelled".toUpperCase(),
                          style: TextStyle(
                            color: active == "Cancelled"
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: countHeight(20, context),
              ),
              if (delivered) ...pendingAppointments.map(
                    (appointment) {
                  return Column(
                    children: [
                      pendingAppointment(
                        appointment.appointID,
                        appointment.doctorName,
                        appointment.details,
                        appointment.date,
                        appointment.status,
                        appointment.appointNo,
                        context,
                      ),
                      SizedBox(
                        height: countHeight(15, context),
                      ),
                    ],
                  );
                },
              ),
              if (processing) ...completedAppointments.map(
                    (appointment) {
                  return Column(
                    children: [
                      processAppointment(
                        appointment.appointID,
                        appointment.doctorName,
                        appointment.details,
                        appointment.date,
                        appointment.status,
                        appointment.appointNo,
                        context,
                      ),
                      SizedBox(
                        height: countHeight(15, context),
                      ),
                    ],
                  );
                },
              ),
              if (cancelled) ...cancelledAppointments.map(
                    (appointment) {
                  return Column(
                    children: [
                      CancelAppointment(
                        appointment.appointID,
                        appointment.doctorName,
                        appointment.details,
                        appointment.date,
                        appointment.status,
                        appointment.appointNo,
                        context,
                      ),
                      SizedBox(
                        height: countHeight(15, context),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}