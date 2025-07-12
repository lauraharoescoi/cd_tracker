import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const CdTrackerApp());
}

class CdTrackerApp extends StatelessWidget {
  const CdTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData.dark();
    final accentColor = Colors.deepOrange;

    return MaterialApp(
      title: 'CD Tracker',
      theme: baseTheme.copyWith(
        textTheme: GoogleFonts.montserratTextTheme(baseTheme.textTheme),
        colorScheme: ColorScheme.fromSeed(
          seedColor: accentColor,
          brightness: Brightness.dark,
          primary: accentColor,
          secondary: accentColor.shade200,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white, // CORRECCIÓN: Se ha añadido el color blanco
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.white.withOpacity(0.1)),
          ),
          color: Colors.grey[900]?.withOpacity(0.5),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.black.withOpacity(0.3),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: accentColor,
          unselectedItemColor: Colors.grey[600],
          backgroundColor: Colors.black.withOpacity(0.5),
          elevation: 0,
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: const Color(0xFF1e1e1e),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}