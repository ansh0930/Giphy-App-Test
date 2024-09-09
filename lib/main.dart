import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:giphy_app_test/screens/register_screen.dart';
import 'package:provider/provider.dart';
import 'data/model/gif_data_model.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart' as AT;
import 'data/model/base_model.dart';
import 'screens/trending_screen.dart';

var randomNumber;

FirebaseAuth auth = FirebaseAuth.instance;
// Stream<AT.User?>? authUser= FirebaseAuth.instance.authStateChanges();
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
    name: 'default',
    demoProjectId: 'giphy-app-test',
    options: DefaultFirebaseOptions.currentPlatform,
  ).catchError((onError) {
    print("ERROR :- $onError");
  });
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
      home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.data != null) return const TrendingPage();
            return const SignUpScreen();
          }),
    );
  }
}

class GlobalVariable {
  static final GlobalKey<ScaffoldMessengerState> navState =
      GlobalKey<ScaffoldMessengerState>();

  static final GlobalKey<NavigatorState> navigatorState =
      GlobalKey<NavigatorState>();
}
