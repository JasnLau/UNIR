import 'package:flutter/material.dart';
import 'package:unir/services/events.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unir/screens/user_profile_screen.dart';
import 'package:share/share.dart';

class EventCreationScreen extends StatefulWidget {
  @override
  _EventCreationScreenState createState() => _EventCreationScreenState();
}

class _EventCreationScreenState extends State<EventCreationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _hostController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Event Creation'),
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
        ],),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _eventNameController,
                decoration: InputDecoration(
                  labelText: 'Event Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an event name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _hostController,
                decoration: InputDecoration(
                  labelText: 'Host',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a host';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _capacityController,
                decoration: InputDecoration(
                  labelText: 'Capacity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _costController,
                decoration: InputDecoration(
                  labelText: 'Cost',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _linkController,
                decoration: InputDecoration(
                  labelText: 'Link',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.url,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () => _submitEvent(context),
                  child: Text('Submit Event'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),    );
  }

  Future<void> _submitEvent(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('events').add({
          'hiddenID': user.email,
          'eventName': _eventNameController.text,
          'host': _hostController.text,
          'location': _locationController.text,
          'capacity': int.tryParse(_capacityController.text) ?? 0,
          'cost': double.tryParse(_costController.text) ?? 0.0,
          'link': _linkController.text,
          'description': _descriptionController.text,
        });

        await FirebaseFirestore.instance.collection('joinedEvents').add({
          'hiddenID': user.email,
          'eventName': _eventNameController.text,
          'host': _hostController.text,
          'location': _locationController.text,
          'capacity': int.tryParse(_capacityController.text) ?? 0,
          'cost': double.tryParse(_costController.text) ?? 0.0,
          'link': _linkController.text,
          'description': _descriptionController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Event created successfully')),
        );

        // Share event details
        await _shareEvent(context);

        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: User not logged in')),
        );
      }
    }
  }

  Future<void> _shareEvent(BuildContext context) async {
    final String eventDetails = '''
  Event: ${_eventNameController.text}
  Host: ${_hostController.text}
  Location: ${_locationController.text}
  Capacity: ${_capacityController.text}
  Cost: ${_costController.text}
  Link: ${_linkController.text}
  Description: ${_descriptionController.text}
  ''';

    try {
      await Share.share(
        eventDetails,
        subject: 'Check out this event!',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Event details shared successfully!'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to share event details.'),
        ),
      );
    }
  }
}