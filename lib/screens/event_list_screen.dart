import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:unir/screens/event_confirmation_screen.dart';
import 'package:unir/screens/user_profile_screen.dart';


class EventListScreen extends StatefulWidget {
  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    CollectionReference events = FirebaseFirestore.instance.collection('events');

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Search events',
            fillColor: Colors.white,
            filled: true,
            prefixIcon: Icon(Icons.search, color: Colors.black),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Center(
              child: InkWell(
                onTap: () {
                  // Navigate to the desired page, e.g., UserProfilePage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserProfileScreen()),
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
      body: StreamBuilder<QuerySnapshot>(
        stream: events
            .where('eventName', isGreaterThanOrEqualTo: searchQuery)
            .where('eventName', isLessThan: searchQuery + '\uf8ff')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              final event = snapshot.data!.docs[index];

              return Card(
                margin: EdgeInsets.all(10.0),
                elevation: 5.0,
                child: Column(
                  children: [
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                        ),
                        image: DecorationImage(
                          image: AssetImage('lib/assets/images/event_placeholder.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event['eventName'],
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          SizedBox(height: 8.0),
                          Text('Host: ${event['host']}'),
                          SizedBox(height: 4.0),
                          Text('Location: ${event['location']}'),
                          SizedBox(height: 4.0),
                          Text('Capacity: ${event['capacity']}'),
                          SizedBox(height: 4.0),
                          Text('Cost: ${event['cost']}'),
                          SizedBox(height: 4.0),
                          Text('Link: ${event['link']}'),
                          SizedBox(height: 10.0),
                          Text(
                            event['description'],
                            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ConfirmationScreen(
                                    eventName: event['eventName'],
                                    host: event['host'],
                                    location: event['location'],
                                    capacity: event['capacity'],
                                    cost: event['cost'],
                                    link: event['link'],
                                    description: event['description'],
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'Join',
                              style: TextStyle(fontSize: 18),
                            ),
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: Theme.of(context).primaryColor,
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}