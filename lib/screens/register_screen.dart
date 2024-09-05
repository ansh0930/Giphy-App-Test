import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Global key for the form
  final _formKey = GlobalKey<FormState>();

  // Text controllers to retrieve input values
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Function to handle form submission
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed with signup logic
      print("Email: ${_emailController.text}");
      print("Password: ${_passwordController.text}");
    }
  }

  hitSignUpEmailAPI(context) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ); // userCredential.user!.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      debugPrint('Error---------${e.stackTrace}');
      debugPrint('stack--------${e.code}');
    }
  }

  showOrHidePasswordVisibility() {
    setState(() {
      viewPassword = !viewPassword;
    });
  }

  showOrHideNewPasswordVisibility() {
    setState(() {
      viewNewPassword = !viewNewPassword;
    });
  }

  bool viewPassword = false;
  bool viewNewPassword = false;

  // Dispose controllers when no longer needed
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              // Email field
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),

              // Password field
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),

              // Confirm Password field
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  } else if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.0),
              Padding(
                
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text("Already have an account",
                        style: TextStyle(fontSize: 16, color: Colors.purple)),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Sign in",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 16,
                            color: Colors.purple,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              // Signup Button
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
