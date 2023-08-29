import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:healthcare_pakistan/data.dart';
import '/AddressPage.dart';
import '/PrivacySecurityPage.dart';
import '/ReviewsPage.dart';
import '/Widgets/responsive.dart';
import '/medicalRecordPage.dart';
import '/myOrderpage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? role;
  String? email;
  String? name;
  Uint8List? _imageData;
  Alignment alignleft = Alignment.topLeft;
  Alignment alignright = Alignment.topRight;

  Future<void> getImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imageBytes = await pickedFile.readAsBytes();
      setState(() {
        _imageData = imageBytes;
        firebase_auth.User user = firebase_auth.FirebaseAuth.instance.currentUser!;
        FirebaseFirestore.instance.collection('users').doc(user.uid).update({'image': _imageData});
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getRoleFromSharedPreferences();
  }

  Future<void> _getRoleFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      role = prefs.getString('role') ?? '';
      email = prefs.getString('email') ?? '';
      name = prefs.getString('name') ?? '';
    });
  }

  @override
  Scaffold build(BuildContext context)  {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        // backgroundColor: Colors.white,
        title: Text(
          "My Profile",
          style: GoogleFonts.openSans(
              fontWeight: FontWeight.bold, fontSize: 25.0),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Container(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: getImage,
                        child: Container(
                          height: countHeight(65, context),
                          width: countWidth(65, context),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue[100],
                          ),
                          child: _imageData != null
                              ? CircleAvatar(
                            backgroundImage: MemoryImage(_imageData!),
                            radius: countWidth(32, context),
                          )
                              : Center(
                            child: Text(
                              "Upload",
                              style: GoogleFonts.openSans(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14.0,
                                  color: Colors.blue[500]),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: alignleft,
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: alignleft,
                                  child: Text(
                                    currentName.toString(),
                                    style: GoogleFonts.openSans(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18.0),
                                  ),
                                ),
                                Align(
                                  alignment: alignleft,
                                  child: Text(
                                    currentEmail.toString(),
                                    style: GoogleFonts.openSans(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyOrders()));
                },
                child: ListTile(
                  title: Text("My Appointments", style: GoogleFonts.openSans(fontSize: 16.0)),
                  subtitle: Text(
                    "2 Appointments",
                    style: GoogleFonts.openSans(fontWeight: FontWeight.normal),
                  ),
                  trailing: Icon(Icons.chevron_right_rounded),
                ),
              ),
              Divider(),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddressPage()));
                },
                child: ListTile(
                  title: Text("Addresses", style: GoogleFonts.openSans(fontSize: 16.0)),
                  subtitle: Text(
                    "2 Addresses",
                    style: GoogleFonts.openSans(fontWeight: FontWeight.normal),
                  ),
                  trailing: Icon(Icons.chevron_right_rounded),
                ),
              ),
              Divider(),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => MedicalRecordPage()));
                },
                child: ListTile(
                  title: Text("My Records", style: GoogleFonts.openSans(fontSize: 16.0)),
                  subtitle: Text(
                    "2 Official documents submitted",
                    style: GoogleFonts.openSans(fontWeight: FontWeight.normal),
                  ),
                  trailing: Icon(Icons.chevron_right_rounded),
                ),
              ),
              Divider(),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ReviewsPage()));
                },
                child: ListTile(
                  title: Text("My Reviews", style: GoogleFonts.openSans(fontSize: 16.0)),
                  subtitle: Text(
                    "01 Reviews",
                    style: GoogleFonts.openSans(fontWeight: FontWeight.normal),
                  ),
                  trailing: Icon(Icons.chevron_right_rounded),
                ),
              ),
              Divider(),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => PrivacySecurityPage()));
                },
                child: ListTile(
                  title: Text("Account Settings", style: GoogleFonts.openSans(fontSize: 16.0)),
                  subtitle: Text(
                    "Privacy and Security",
                    style: GoogleFonts.openSans(fontWeight: FontWeight.normal),
                  ),
                  trailing: Icon(Icons.chevron_right_rounded),
                ),
              ),
              Divider(),
             // Closing brace for the ListView widget
        ], // Closing brace for the Column widget
      ), // Closing brace for the Container widget
    ), // Closing brace for the Padding widget
    ), // Closing brace for the Scaffold widget
    ); // Closing brace for the build method
  } // Closing brace for the _ProfileState class
}

