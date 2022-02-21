import 'package:albify/screens/auth/auth_page.dart';
import 'package:albify/screens/main/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StartingPage extends StatelessWidget {
  static const String ROUTE_ID = '/';
  
  @override
  Widget build(BuildContext context) =>
    WillPopScope(
      onWillPop: () async => true,
      child: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MainPage();
          } else {
            return AuthPage();
          }
        }
      ),
    );
}