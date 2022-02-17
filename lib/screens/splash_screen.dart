import 'package:albify/screens/auth_page.dart';
import 'package:albify/screens/main_page.dart';
import 'package:albify/themes/app_style.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const String ROUTE_ID = '/splash';
  
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<bool> _checkIsLoggedIn() async {
    // TODO: Firebase checks
    return true;
  }

  _navigateToNextScreen() async {
    await Future.delayed(Duration(milliseconds: 2200), () async {
      final isLoggedIn = await _checkIsLoggedIn();
      var nextPage = isLoggedIn ? MainPage.ROUTE_ID : AuthPage.ROUTE_ID;
      Navigator.pushReplacementNamed(
        context,
        nextPage
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppStyle.appColorBlack,
      child: Center(
        child: Image.asset(
          'assets/images/albify_icon.png',
          height: 100,
        ),
      ),
    );
  }
}