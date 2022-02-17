import 'package:albify/screens/auth_page.dart';
import 'package:albify/screens/main_page.dart';
import 'package:albify/screens/splash_screen.dart';
import 'package:albify/themes/app_style.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Albify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: AppStyle.appColorBlack,
        scaffoldBackgroundColor: AppStyle.appColorBlack
      ),
      initialRoute: SplashScreen.ROUTE_ID,
      routes: {
        SplashScreen.ROUTE_ID: (context) => SplashScreen(),
        MainPage.ROUTE_ID: (context) => MainPage(),
        AuthPage.ROUTE_ID: (context) => AuthPage()
      },
    );
  }
}
