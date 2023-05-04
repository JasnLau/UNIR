import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:unir/screens/delete_confirmation_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';


class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    CollectionReference joinEvents = FirebaseFirestore.instance.collection('joinedEvents');

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
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: joinEvents.where('eventName', isGreaterThanOrEqualTo: searchQuery)
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
              final joinEvents = snapshot.data!.docs[index];
              final user = FirebaseAuth.instance.currentUser;

              return Card(
                margin: EdgeInsets.all(10.0),
                elevation: 5.0,
                child: (user?.email == joinEvents['hiddenID']) ? Column(
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
                            joinEvents['eventName'],
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          SizedBox(height: 8.0),
                          Text('Host: ${joinEvents['host']}'),
                          SizedBox(height: 4.0),
                          Text('Location: ${joinEvents['location']}'),
                          SizedBox(height: 4.0),
                          Text('Capacity: ${joinEvents['capacity']}'),
                          SizedBox(height: 4.0),
                          Text('Cost: ${joinEvents['cost']}'),
                          SizedBox(height: 4.0),
                          Text('Link: ${joinEvents['link']}'),
                          SizedBox(height: 10.0),
                          Text(
                            joinEvents['description'],
                            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DeleteScreen(
                                    eventName: joinEvents['eventName'],
                                    host: joinEvents['host'],
                                    location: joinEvents['location'],
                                    capacity: joinEvents['capacity'],
                                    cost: joinEvents['cost'],
                                    link: joinEvents['link'],
                                    description: joinEvents['description'],
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'Delete',
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
                ): SizedBox.shrink(),
              );
            },
          );
          return Text('You did not join events');
          },
      ),
    );
  }
}