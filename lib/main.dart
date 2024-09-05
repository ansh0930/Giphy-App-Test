/*
 * @copyright : ToXSL Technologies Pvt. Ltd. < www.toxsl.com >
 * @author     : Shiv Charan Panjeta < shiv@toxsl.com >
 * All Rights Reserved.
 * Proprietary and confidential :  All information contained herein is, and remains
 * the property of ToXSL Technologies Pvt. Ltd. and its partners.
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 */

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:giphy_app_test/screens/register_screen.dart';

var randomNumber;

FirebaseAuth auth = FirebaseAuth.instance;
Stream<User?> authUser = FirebaseAuth.instance.authStateChanges();
FirebaseFirestore databaseReference = FirebaseFirestore.instance;
FirebaseStorage dbStorage = FirebaseStorage.instance;
var deviceToken;

Future<void> main() async {
  initializationFunction();
  orientation();
  initApp();
}

initializationFunction() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyDh5L6sFsCCYvH-xXrw_CvBEarAAmRZ67g',
        appId: '1:832121767989:android:7a50a98a7e6e32063e497c',
        messagingSenderId: '',
        projectId: 'giphy-app-test',
        storageBucket: 'giphy-app-test.appspot.com',
      ));
  debugPrint('deviceToken::$deviceToken');
}

orientation() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.light,
  );
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
}

initApp() async {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Sharing app',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home:  SignUpScreen(),
    );
  }
}

class GlobalVariable {
  static final GlobalKey<ScaffoldMessengerState> navState = GlobalKey<ScaffoldMessengerState>();

  static final GlobalKey<NavigatorState> navigatorState = GlobalKey<NavigatorState>();
}
