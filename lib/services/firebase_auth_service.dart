import 'package:firebase_auth/firebase_auth.dart';

/// Thin wrapper around Firebase Authentication.
///
/// Keeping this separate from providers makes auth easy to test and keeps UI
/// code away from Firebase SDK details.
class FirebaseAuthService {
  FirebaseAuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  User? get currentUser => _auth.currentUser;
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<UserCredential> signUp({required String email, required String password}) {
    return _auth.createUserWithEmailAndPassword(email: email.trim().toLowerCase(), password: password);
  }

  Future<UserCredential> signIn({required String email, required String password}) {
    return _auth.signInWithEmailAndPassword(email: email.trim().toLowerCase(), password: password);
  }

  Future<void> updateDisplayName(String name) async {
    await _auth.currentUser?.updateDisplayName(name.trim());
  }

  Future<void> updateEmail(String email) async {
    await _auth.currentUser?.verifyBeforeUpdateEmail(email.trim().toLowerCase());
  }

  Future<void> sendPasswordResetEmail(String email) {
    return _auth.sendPasswordResetEmail(email: email.trim().toLowerCase());
  }

  Future<void> signOut() => _auth.signOut();
}
