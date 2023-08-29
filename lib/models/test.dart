// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class Doctor {
//   final String id;
//   final String name;
//   final String price;
//   final String phone;
//   final String city;
//
//   Doctor({
//     required this.id,
//     required this.name,
//     required this.price,
//     required this.phone,
//     required this.city,
//   });
// }
//
// Future<void> populateFirestore() async {
//   await Firebase.initializeApp();
//
//   final firestore = FirebaseFirestore.instance;
//
//   final List<Doctor> dummyDoctors = [
//     Doctor(
//       id: 'doctor0',
//       name: 'Shahzad Ali',
//       price: 'PKR 5000',
//       phone: '03111010010',
//       city: 'Sukkur',
//     ),
//     Doctor(
//       id: 'doctor1',
//       name: 'Kashan Ali',
//       price: 'PKR 7000',
//       phone: '03441010010',
//       city: 'Sukkur',
//     ),
//     Doctor(
//       id: 'doctor2',
//       name: 'Sharjeel',
//       price: 'PKR 90000',
//       phone: '03311010010',
//       city: 'Sukkur',
//     ),
//     Doctor(
//       id: 'doctor3',
//       name: 'Mazhar Shah',
//       price: 'PKR 1000',
//       phone: '0311555010',
//       city: 'Karachi',
//     ),
//     Doctor(
//       id: 'doctor4',
//       name: 'Salman Ali',
//       price: 'PKR 9000',
//       phone: '033010010',
//       city: 'Karachi',
//     ),
//     Doctor(
//       id: 'doctor5',
//       name: 'Rahul',
//       price: 'PKR 6000',
//       phone: '03231010010',
//       city: 'Karachi',
//     ),
//     Doctor(
//       id: 'doctor6',
//       name: 'Ayaz Gul',
//       price: 'PKR 3000',
//       phone: '03001010010',
//       city: 'Hyderabad',
//     ),Doctor(
//       id: 'doctor7',
//       name: 'Tayyab',
//       price: 'PKR 1000',
//       phone: '03551010010',
//       city: 'Hyderabad',
//     ),Doctor(
//       id: 'doctor8',
//       name: 'Khalil Khan',
//       price: 'PKR 2000',
//       phone: '033311010010',
//       city: 'Hyderabad',
//     ),
//   ];
//
//   for (final doctor in dummyDoctors) {
//     await firestore.collection('caretakers').doc(doctor.id).set({
//       'name': doctor.name,
//       'price': doctor.price,
//       'phone': doctor.phone,
//       'city': doctor.city,
//     });
//   }
//
//   print('Dummy data added to Firestore collection.');
// }
//
//
