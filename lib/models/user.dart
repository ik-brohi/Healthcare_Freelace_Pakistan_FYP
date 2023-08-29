import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? uid;
  String? role;
  String? fullname;
  String? profilePic;
  String? email;
  String? city;
  int? age;

  User({
    this.uid,
    this.role,
    this.fullname,
    this.profilePic,
    this.email,
    this.city,
    this.age,
  });

  // Convert User object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'role': role,
      'fullname': fullname,
      'profilePic': profilePic,
      'email': email,
      'city': city,
      'age': age,
    };
  }

  // Create a User object from a JSON map
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'],
      role: json['role'],
      fullname: json['fullname'],
      profilePic: json['profilePic'],
      email: json['email'],
      city: json['city'],
      age: json['age'],
    );
  }
}
