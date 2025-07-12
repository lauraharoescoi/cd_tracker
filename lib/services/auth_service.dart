import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../config/spotify_credentials.dart'; // Importar nuestras credenciales

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  
  // Para que el inicio de sesión funcione en Android, es OBLIGATORIO
  // configurar el `serverClientId` (que es el "Web client ID" de la consola de Google Cloud)
  // usando el método initialize().
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  // Stream para escuchar los cambios de estado de autenticación
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Obtener el usuario actual
  User? get currentUser => _firebaseAuth.currentUser;

  // Iniciar sesión con Google
  Future<User?> signInWithGoogle() async {
    try {
      // Inicializar con el serverClientId
      await _googleSignIn.initialize(serverClientId: googleServerClientId);
      
      // En la API actual, el método para iniciar sesión es `authenticate()`.
      final GoogleSignInAccount? googleUser = await _googleSignIn.authenticate();
      
      if (googleUser == null) {
        // El usuario canceló el proceso
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      // En la API actual, solo necesitamos el `idToken` para la credencial de Firebase.
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print("Error en el inicio de sesión con Google: $e");
      return null;
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}