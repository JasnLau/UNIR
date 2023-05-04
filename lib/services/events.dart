import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event.dart';

class Events {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _eventCollection =
  FirebaseFirestore.instance.collection('events');

  Stream<List<Event>> getEvents() {
    return _firestore.collection('events').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Event(
          id: doc.id,
          name: doc['name'] ?? '',
          description: doc['description'] ?? '',

        );
      }).toList();
    });
  }

  Future<DocumentReference<Object?>> createEvent(String name, String description) async {
    return await _eventCollection.add({
      'name': name,
      'description': description,
    });
  }

}