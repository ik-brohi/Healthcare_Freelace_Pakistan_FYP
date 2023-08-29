import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'ChatScreen.dart';


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class UsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUserEmail = FirebaseAuth.instance.currentUser?.email;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Chat Screen'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final userData = users[index].data() as Map<String, dynamic>;
              final email = userData['email'];
              final username = userData['name']; // Adjust this field name

              if (currentUserEmail == email) {
                return SizedBox.shrink(); // Skip the current user's tile
              }

              return Container(
                color: Colors.blueGrey,
                height: 70,
                child: Align(
                  alignment: Alignment.center,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      // You can set the image using the user's profile picture URL
                      // backgroundImage: NetworkImage(userData['profileImageUrl']),
                      child: Text(
                        username.substring(0, 1),
                        style: TextStyle(fontSize: 28),  // Increase the font size here
                      ),
                    ),
                    title: Text(
                      username,
                      style: TextStyle(fontSize: 23),  // Increase the font size here
                    ),
                    subtitle: Text(
                      email,
                      style: TextStyle(fontSize: 18),  // Increase the font size here
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            recipientUsername: username,
                            recipientUserId: email, // Use email as the identifier
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );

            },
          );
        },
      ),
    );
  }
}
