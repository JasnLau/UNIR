import 'package:flutter/material.dart';
import 'package:unir/services/authentication.dart';
import 'package:unir/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unir/screens/admin_screen.dart'; // Import the admin page

// Enum to represent form type
enum FormType { login, signUp }

class LoginSignupScreen extends StatefulWidget {
  @override
  _LoginSignupScreenState createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Authentication _auth = Authentication();

  String _email = '';
  String _password = '';
  FormType _formType = FormType.login;

  void _submit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_formType == FormType.login) {
        // Check for admin credentials
        if (_email == 'admin' && _password == 'admin') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminPage()), // Navigate to the admin page
          );
        } else { // Check the user exist or not in the Firebase
          try {
            final user = await _auth.signInWithEmailAndPassword(_email, _password);
            if (user != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            }
          } catch (e) {
            String errorMessage;

            if (e is FirebaseAuthException) {
              switch (e.code) {
                case 'user-not-found':
                  errorMessage = 'No user found with this email.';
                  break;
                case 'wrong-password':
                  errorMessage = 'Incorrect password.';
                  break;
                case 'invalid-email':
                  errorMessage = 'Invalid email format.';
                  break;
                case 'user-disabled':
                  errorMessage = 'User has been disabled.';
                  break;
                default:
                  errorMessage = 'An error occurred while logging in.';
                  break;
              }
            } else {
              errorMessage = 'An unexpected error occurred. Please try again.';
            }

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                duration: Duration(seconds: 3),
              ),
            );
          }
        }
      } else { // Create a new user and store in Firebase
        final user =
        await _auth.createUserWithEmailAndPassword(_email, _password);
        if (user != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      }
    }
  }
  void _toggleFormType() {
    setState(() {
      _formType =
      _formType == FormType.login ? FormType.signUp : FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login / Sign Up'),
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
        ],),
      body: Builder(
        builder: (context) => Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 40),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                    value!.isEmpty ? 'Email can\'t be empty' : null,
                    onSaved: (value) => _email = value!,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) =>
                    value!.isEmpty ? 'Password can\'t be empty' : null,
                    onSaved: (value) => _password = value!,
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => _submit(context),
                    child:
                    Text(_formType == FormType.login ? 'Login' : 'Sign Up'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: _toggleFormType,
                    child: Text(
                      _formType == FormType.login
                          ? 'Don\'t have an account? Sign Up'
                          : 'Already have an account? Login',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}