import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthcare_pakistan/data.dart';

import '/dashboard.dart';
import '/homepage.dart';
import '/screens/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'firebaseFunctions.dart';

class AuthServices {
  static signupUser(
      String email, String password, String name, String role,BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
      await FirebaseAuth.instance.currentUser!.updateEmail(email);
      await FirestoreServices.saveUser(name, email, role,userCredential.user!.uid);





      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Registration Successful')));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Password Provided is too weak')));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Email Provided already Exists')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  static signinUser(String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

      // Get the user's UID from the authentication result
      String uid = userCredential.user!.uid;

      // Fetch user data from Firestore using the UID
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userSnapshot.exists) {
        // Get the role from the user's Firestore document
        String role = (userSnapshot.data() as Map<String, dynamic>)['role'] ?? 'doctor';

        Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;

        // Get email and username from the user's Firestore document
        currentEmail = userData['email'];
        currentName = userData['name'];

        print(currentEmail);
        print(currentName);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You are Logged in as a $role')));
        currentRole = role;

        // Navigate to signup page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );

      } else {
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No user found with this Email')));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password did not match')));
      }
    }
  }
}