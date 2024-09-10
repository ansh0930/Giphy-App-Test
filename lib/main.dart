import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:giphy_app_test/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'data/model/gif_data_model.dart';
import 'firebase_options.dart';
import 'data/model/base_model.dart';
import 'screens/fav_gif_screen.dart';

var randomNumber;

FirebaseAuth auth = FirebaseAuth.instance;
// Stream<AT.User?>? authUser;
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
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    // authUser = FirebaseAuth.instance.authStateChanges();
  } catch (e) {
    debugPrint(e.toString());
  }
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
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<BaseModel>(
      create: (_) => BaseModel(),
    ),
    ChangeNotifierProvider<GiphsModel>(
      create: (_) => GiphsModel(),
    ),
  ], child: const MyApp()));
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
        home: SplashScreen());
  }
}

class GlobalVariable {
  static final GlobalKey<ScaffoldMessengerState> navState =
      GlobalKey<ScaffoldMessengerState>();

  static final GlobalKey<NavigatorState> navigatorState =
      GlobalKey<NavigatorState>();
}
