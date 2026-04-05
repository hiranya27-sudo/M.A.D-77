import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  Future<void> signUp(
    String email,
    String password, {
    String dietaryType = 'omnivore',
    List<String> allergies = const [],
  }) async {
    // Step 1: Create Firebase Auth account
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Step 2: Save user profile to Firestore
    await _db.collection('users').doc(credential.user!.uid).set({
      'email': email,
      'dietaryType': dietaryType,
      'allergies': allergies,
      'calorieTarget': 2000,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> login({required String email, required String password}) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}

final authServiceProvider = Provider<AuthService>((ref) => AuthService());
