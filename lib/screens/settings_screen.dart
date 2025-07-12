import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // CORRECCIÓN: Se crea una única instancia del servicio
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    // Se obtiene el usuario de la instancia del servicio
    final User? user = _authService.currentUser;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          if (user != null) ...[
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: user.photoURL != null ? NetworkImage(user.photoURL!) : null,
                child: user.photoURL == null ? const Icon(Icons.person, size: 50) : null,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                user.displayName ?? 'No Name',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                user.email ?? 'No Email',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70),
              ),
            ),
          ] else ...[
            const Center(child: Text('Not logged in')),
          ],
          const Spacer(),
          ElevatedButton.icon(
            onPressed: () async {
              // Se usa la instancia creada para cerrar sesión
              await _authService.signOut();
            },
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent.withOpacity(0.8),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}