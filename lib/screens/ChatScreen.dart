import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  final String recipientUsername;
  final String recipientUserId; // Use email as the identifier

  ChatScreen({required this.recipientUsername, required this.recipientUserId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late String _currentUserId;

  @override
  void initState() {
    super.initState();
    _currentUserId = _auth.currentUser!.email!; // Use email as the identifier
  }

  void _sendMessage(String message) {
    log('Sending message: $message');
    log('Sender: $_currentUserId');
    log('Receiver: ${widget.recipientUserId}');

    _firestore.collection('messages').add({
      'senderId': _currentUserId,
      'receiverId': widget.recipientUserId,
      'text': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.recipientUsername}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('messages')
                  .where('senderId', isEqualTo: _currentUserId)
                  .snapshots(),
              builder: (context, senderSnapshot) {
                if (senderSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                return StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('messages')
                      .where('receiverId', isEqualTo: _currentUserId)
                      .snapshots(),
                  builder: (context, receiverSnapshot) {
                    if (receiverSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    List<QueryDocumentSnapshot> allMessages = [];

                    if (senderSnapshot.hasData) {
                      allMessages.addAll(senderSnapshot.data!.docs);
                    }

                    if (receiverSnapshot.hasData) {
                      allMessages.addAll(receiverSnapshot.data!.docs);
                    }

                    allMessages.sort((a, b) {
                      final aTimestamp = (a['timestamp'] as Timestamp?)?.toDate();
                      final bTimestamp = (b['timestamp'] as Timestamp?)?.toDate();
                      return bTimestamp?.compareTo(aTimestamp ?? DateTime.now()) ?? 0;
                    });

                    if (allMessages.isEmpty) {
                      return Center(child: Text('No messages yet.'));
                    }

                    return ListView.builder(
                      reverse: true,
                      itemCount: allMessages.length,
                      itemBuilder: (context, index) {
                        final messageData = allMessages[index].data() as Map<String, dynamic>;
                        final messageText = messageData['text'];
                        final messageSenderId = messageData['senderId'];

                        final isMe = messageSenderId == _currentUserId;

                        return Align(
                          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                            padding: EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                              color: isMe ? Colors.blue : Colors.grey[300],
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Text(

                              messageText,
                              style: TextStyle(fontSize:16, color: isMe ? Colors.white : Colors.black),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: TextStyle(fontSize: 18),
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  iconSize: 30,
                  icon: Icon(Icons.send),
                  onPressed: () {
                    final message = _messageController.text.trim();
                    if (message.isNotEmpty) {
                      _sendMessage(message);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
