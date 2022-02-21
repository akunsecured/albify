import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> signUp({
    required String email,
    required String password,
    required String name
  }) async {
    try {
      UserCredential _userCredential =
        await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password
        );
      
      await FirebaseFirestore.instance
        .collection('users')
        .doc(_userCredential.user!.uid)
        .set({
          'name': name,
          'avatarUrl': ""
        });
    } catch (e) {
      print(e);
    }
  }

  Future<void> login({
    required String email,
    required String password
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      print(e);
    }
  }
}