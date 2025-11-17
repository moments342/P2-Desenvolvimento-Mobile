import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get usuarioStream => _auth.authStateChanges();

  Future<User?> cadastrar(String email, String senha) async {
    final credencial = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: senha,
    );
    return credencial.user;
  }

  Future<User?> login(String email, String senha) async {
    final credencial = await _auth.signInWithEmailAndPassword(
      email: email,
      password: senha,
    );
    return credencial.user;
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}
