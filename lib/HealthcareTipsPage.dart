import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class HealthcareTipsPage extends StatefulWidget {
  @override
  _HealthcareTipsPageState createState() => _HealthcareTipsPageState();
}

class _HealthcareTipsPageState extends State<HealthcareTipsPage> {
  late Future<List<Tip>> tipsFuture;

  @override
  void initState() {
    super.initState();
    tipsFuture = fetchTipsFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Healthcare Tips'),
      ),
      body: FutureBuilder<List<Tip>>(
        future: tipsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching tips'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return TipCard(tip: snapshot.data![index]);
              },
            );
          } else {
            return Center(child: Text('No tips available.'));
          }
        },
      ),
    );
  }
}

class Tip {
  final String title;
  final String description;

  Tip(this.title, this.description);
}

class TipCard extends StatelessWidget {
  final Tip tip;

  TipCard({required this.tip});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tip.title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(tip.description),
          ],
        ),
      ),
    );
  }
}

Future<List<Tip>> fetchTipsFromFirestore() async {
  List<Tip> tipsList = [];

  try {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('tips').get();

    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      Tip tip = Tip(data['title'], data['description']);
      tipsList.add(tip);
    });

    return tipsList;
  } catch (error) {
    print("Error fetching tips: $error");
    return tipsList; // Return an empty list if there's an error
  }
}
