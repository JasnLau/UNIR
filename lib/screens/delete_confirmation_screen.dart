import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unir/home_page.dart';
import 'package:unir/screens/user_profile_screen.dart';

class DeleteScreen extends StatelessWidget {
  final String eventName;
  final String host;
  final String location;
  final int? capacity;
  final double? cost;
  final String? link;
  final String? description;

  DeleteScreen({
    required this.eventName,
    required this.host,
    required this.location,
    this.capacity,
    this.cost,
    this.link,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmation', style: TextStyle(fontFamily: 'OpenSans')),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Center(
              child: InkWell(
                onTap: () {
                  // Navigate to the desired page, e.g., UserProfilePage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserProfileScreen()),
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.account_circle,
                      size: 24,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'UNIR',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Event Details', style: TextStyle(fontSize: 24,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Event Name: $eventName', style: TextStyle(
                            fontSize: 18, fontFamily: 'OpenSans')),
                        SizedBox(height: 10),
                        Text('Host: $host', style: TextStyle(fontSize: 18,
                            fontFamily: 'OpenSans')),
                        SizedBox(height: 10),
                        Text('Location: $location', style: TextStyle(
                            fontSize: 18, fontFamily: 'OpenSans')),
                        SizedBox(height: 10),
                        if (capacity != null) Text(
                            'Capacity: $capacity', style: TextStyle(
                            fontSize: 18, fontFamily: 'OpenSans')),
                        SizedBox(height: 10),
                        if (cost != null) Text(
                            'Cost: \$$cost', style: TextStyle(
                            fontSize: 18, fontFamily: 'OpenSans')),
                        SizedBox(height: 10),
                        if (link != null) Text('Link: $link', style: TextStyle(
                            fontSize: 18, fontFamily: 'OpenSans')),
                        SizedBox(height: 10),
                        if (description != null) ...[
                          Text('Description:', style: TextStyle(
                              fontSize: 18, fontFamily: 'OpenSans')),
                          SizedBox(height: 5),
                          Text(description!, style: TextStyle(
                              fontSize: 16, fontFamily: 'OpenSans')),
                        ],
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await _deleteEvent();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      },
                      child: Text(
                          'Delete', style: TextStyle(fontFamily: 'OpenSans')),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                          'Go Back', style: TextStyle(fontFamily: 'OpenSans')),
                      style: TextButton.styleFrom(
                        primary: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> getLatestEventId() async {
    String? latestEventId;

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('joinedEvents')
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        latestEventId = querySnapshot.docs.first.id;
      }
    } catch (e) {
      print('Error fetching latest event: $e');
    }

    return latestEventId;
  }

  Future<void> _deleteEvent() async {
    String? latestEventId = await getLatestEventId();
    try {
        await FirebaseFirestore.instance.collection('joinedEvents').doc(latestEventId).delete();
        print('Event deleted successfully.');
      } catch (e) {
        print('Error deleting event: $e');
      }
    }


}