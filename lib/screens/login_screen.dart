import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey[900]!, Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo.png', height: 100),
              const SizedBox(height: 20),
              Text(
                'CD Tracker',
                style: GoogleFonts.oswald(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Your personal collection',
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton.icon(
                onPressed: () async {
                  await authService.signInWithGoogle();
                },
                icon: Image.asset('assets/google_logo.png', height: 24.0), // Necesitarás añadir este logo
                label: const Text('Sign in with Google'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black, backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}