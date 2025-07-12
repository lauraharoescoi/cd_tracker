import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'firebase_options.dart';                   // Import the generated options
import 'screens/home_screen.dart';                 // We import our new main screen

// The main function is now async
Future<void> main() async {
  // Ensure that Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const CdTrackerApp());
}

class CdTrackerApp extends StatelessWidget {
  const CdTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CD Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}