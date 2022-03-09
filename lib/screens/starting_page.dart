import 'package:albify/models/firebase_user.dart';
import 'package:albify/screens/auth/auth_page.dart';
import 'package:albify/screens/loading_page.dart';
import 'package:albify/screens/main/main_page.dart';
import 'package:albify/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartingPage extends StatelessWidget {
  static const String ROUTE_ID = '/';
  
  @override
  Widget build(BuildContext context) {
    final _authService = Provider.of<AuthService>(context, listen: false);
    final _snapshot = _authService.snapshot;

    if (
      _snapshot!.connectionState == ConnectionState.none ||
      _snapshot.connectionState == ConnectionState.waiting
    ) {
      return LoadingPage();
    }

    if (_snapshot.connectionState == ConnectionState.active) {
      final FirebaseUser? _user = _snapshot.data;

      return WillPopScope(
        onWillPop: () async => true,
        child: _user == null ? AuthPage() : MainPage(),
      );
    }

    return LoadingPage();
  }
}