import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential =
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return null;
    } catch (e) {
      print('An error occurred during sign in');
      return null;
    }
  }

  Future<User?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential =
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return null;
    } catch (e) {
      print('An error occurred during sign up');
      return null;
    }
  }
}