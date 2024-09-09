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
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
}

initApp() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Sharing app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SignUpScreen(),
    );
  }
}

class GlobalVariable {
  static final GlobalKey<ScaffoldMessengerState> navState =
      GlobalKey<ScaffoldMessengerState>();

  static final GlobalKey<NavigatorState> navigatorState =
      GlobalKey<NavigatorState>();
}
