import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Si el usuario no ha iniciado sesión, muestra la pantalla de login
        if (!snapshot.hasData) {
          return const LoginScreen();
        }
        // Si el usuario ha iniciado sesión, muestra la pantalla principal
        return const HomeScreen();
      },
    );
  }
}