import 'package:healthcare_pakistan/AddressPage.dart';
import 'package:healthcare_pakistan/AppointmentPage.dart';
import 'package:healthcare_pakistan/DoctorCat.dart';
import 'package:healthcare_pakistan/DoctorOrderPage.dart';
import 'package:healthcare_pakistan/HealthcareTipsDoctorPage.dart';
import 'package:healthcare_pakistan/HealthcareTipsPage.dart';
import 'package:healthcare_pakistan/Messages.dart';
import 'package:healthcare_pakistan/PaymentScreen.dart';
import 'package:healthcare_pakistan/PrivacySecurityPage.dart';
import 'package:healthcare_pakistan/ReviewsPage.dart';
import 'package:healthcare_pakistan/chatDetailPage.dart';
import 'package:healthcare_pakistan/detailpage.dart';
import 'package:healthcare_pakistan/favourite.dart';
import 'package:healthcare_pakistan/homepage.dart';
import 'package:healthcare_pakistan/medicalRecordPage.dart';
import 'package:healthcare_pakistan/myOrderpage.dart';
import 'package:healthcare_pakistan/onboardingScreen.dart';
import 'package:healthcare_pakistan/profile.dart';
import 'package:healthcare_pakistan/profileDoctor.dart';
import 'package:healthcare_pakistan/screens/UsersScreen.dart';
import 'package:healthcare_pakistan/splashscreen.dart';

import '/models/appoinment_provider.dart';
import '/services/SignUpPage.dart';
import '/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'notifications.dart';
import 'services/LoginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp( MultiProvider(
    child: MyApp(),
    providers: [

      // Provider for AppointmentProvider
      ChangeNotifierProvider(create: (_) => AppointmentProvider()),
    ],
  ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Set this to false
      title: 'Healthcare Freelance App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: onBoardingScreen(),

    );
  }
}
