import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent/func/google_sign_in.dart';
import 'package:rent/screens/no_internet.dart';
import 'package:rent/screens/screens.dart';
import 'package:rent/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:connectivity/connectivity.dart';

void main() async {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return const Material(
      child: Scaffold(
        body: Center(child: Text("Error occured")),
      ),
    );
  };

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    initConnectivity();

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handleMessage(message);
      }
    });
    FirebaseMessaging.onMessage.listen((message) {
      _handleMessage(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleMessage(message);
    });
  }

  Future<void> initConnectivity() async {
    final ConnectivityResult result = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = (result != ConnectivityResult.none);
    });
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _isConnected = (result != ConnectivityResult.none);
      });
    });
  }

  void _handleMessage(RemoteMessage message) {}

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: ThemeMode.system,
          home: _isConnected ? const Loged() : const NoInternet()),
    );
  }
}
