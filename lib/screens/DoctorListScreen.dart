import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../detailpage.dart';
import '../models/doctor.dart';

String toSentenceCase(String input) {
  if (input == null || input.isEmpty) {
    return '';
  }

  // Split the input into words
  List<String> words = input.split(' ');

  // Convert the first character of each word to uppercase
  for (int i = 0; i < words.length; i++) {
    if (words[i].isNotEmpty) {
      words[i] = words[i][0].toUpperCase() + words[i].substring(1).toLowerCase();
    }
  }

  // Join the words back together
  return words.join(' ');
}

class DoctorListScreen extends StatelessWidget {
  final String cityName;

  DoctorListScreen({required this.cityName}); // Accept city name parameter




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Near By Doctors'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('caretakers')
            .where('city', isEqualTo: toSentenceCase(cityName)) // Filter by city name
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final doctors = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Doctor(
              id: doc.id,
              name: data['name'] ?? '',
              price: data['price'] ?? '',
              phone: data['phone'] ?? '',
              city: data['city'] ?? '',
            );
          }).toList();

          return ListView.builder(
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              final doctor = doctors[index];
              return DoctorTile(doctor: doctor);
            },
          );
        },
      ),
    );
  }
}

class DoctorTile extends StatelessWidget {
  final Doctor doctor;

  DoctorTile({required this.doctor});

  @override
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Details(
              price: doctor.price,
              image: "images/Doctor11.jpg",
              title: doctor.name,
            ),
          ),
        );
      },
      child: Container(
        color: Colors.cyan,
        height: 80, // Adjust the tile's height
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10), // Rounded corners for the image
            child: Image.asset(
              'images/Doctor11.jpg', // Replace with your local image
              width: 100, // Width of the image
              height: 200, // Height of the image
              fit: BoxFit.fill, // Adjust how the image fits
            ),
          ),
          title: Text(
            doctor.name,
            style: TextStyle(fontSize: 18), // Increase font size for the title
          ),
          subtitle: Container(
            // color: Colors.red,
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Price: ${doctor.price}',
                  style: TextStyle(fontSize: 16), // Increase font size for the price
                ),
                Text(
                  'Phone: ${doctor.phone}',
                  style: TextStyle(fontSize: 16), // Increase font size for the phone
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
