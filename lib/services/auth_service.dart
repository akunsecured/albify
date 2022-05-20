import 'package:albify/common/utils.dart';
import 'package:albify/models/firebase_user.dart';
import 'package:albify/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AsyncSnapshot<FirebaseUser?>? snapshot;

  FirebaseUser? _userFromFirebaseAuth(User? user) =>
      user == null ? null : FirebaseUser(uid: user.uid);

  Stream<FirebaseUser?> authStateChanges() =>
      _firebaseAuth.authStateChanges().map(_userFromFirebaseAuth);

  User? get currentUser => _firebaseAuth.currentUser;

  Future<void> signUp(
      {required String email,
      required String password,
      required String name}) async {
    try {
      UserCredential _userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      UserModel userModel =
          UserModel(id: _userCredential.user!.uid, name: name);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(_userCredential.user!.uid)
          .set(userModel.toMap());
    } on FirebaseAuthException catch (e) {
      print(e.message);
      Utils.showToast(e.message!);
    } on FirebaseException catch (e) {
      print(e.message);
      Utils.showToast('Something went wrong');
    }
  }

  Future login({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      print(e.message.toString());
      Utils.showToast('Wrong credentials');
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      print(e.message.toString());
    }
  }

  signInAnonymously() async {
    try {
      await _firebaseAuth.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      Utils.showToast(e.message.toString());
    }
  }

  deleteProfile() async {
    try {
      await _firebaseAuth.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      Utils.showToast(e.message.toString());
    }
  }
}
