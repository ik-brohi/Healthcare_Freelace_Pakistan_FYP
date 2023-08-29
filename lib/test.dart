import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  StreamSubscription<QuerySnapshot> messageSubscription;

  messageSubscription = _firestore.collection('messages').snapshots().listen((snapshot) {
    for (final doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final senderId = data['senderId'];
      final receiverId = data['receiverId'];
      final text = data['text'];
      final timestamp = data['timestamp'];

      print('Sender: $senderId');
      print('Receiver: $receiverId');
      print('Text: $text');
      print('Timestamp: $timestamp');
      print('------------------------');
    }
  });

  // To cancel the subscription and stop listening for updates
  // messageSubscription.cancel();
}
