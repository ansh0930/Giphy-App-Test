import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  // Email validation regex pattern
  final String emailPattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

  // Validation function for email
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!RegExp(emailPattern).hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // On submit function
  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      // If the form is valid, proceed with reset password logic
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reset link sent to your email')),
      );
      // Implement forgot password logic here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Enter your email to reset your password',
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: validateEmail,
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Send Reset Link'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  hitForgetAPI(context) async {
    QuerySnapshot querySnapshot = await databaseReference
        .collection("user_auth")
        .where("email", isEqualTo: _emailController.text)
        .get();
    if (querySnapshot.docs.isEmpty) {
      print('No user found');
    } else {
      try {
        await auth
            .sendPasswordResetEmail(
          email: _emailController.text,
        )
            .then((value) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                surfaceTintColor: Colors.transparent,
                backgroundColor: Colors.white,
                title: const Text(
                  'Check Your Inbox',
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
                content: const Text(
                    'A password reset link has been sent to your email address. Please check your inbox.',
                    style: TextStyle(
                      fontSize: 14,
                    )),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }).onError((error, stackTrace) {});
      } on FirebaseAuthException catch (e) {
        debugPrint(e.toString());
      }
    }
  }
}
