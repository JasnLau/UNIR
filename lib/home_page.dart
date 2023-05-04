import 'package:flutter/material.dart';
import 'package:unir/screens/event_creation_screen.dart';
import 'package:unir/screens/event_list_screen.dart';
import 'package:unir/screens/user_profile_screen.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Center(
              child: InkWell(
                onTap: () {
                  // Navigate to the UserProfilePage
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/images/event_placeholder.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EventCreationScreen()),
                    );
                  },
                  child: Text('Create Event'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    primary: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EventListScreen()),
                    );
                  },
                  child: Text('Event List'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    primary: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),    );
  }


}