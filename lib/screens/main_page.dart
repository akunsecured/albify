import 'package:albify/screens/auth_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  static const String ROUTE_ID = '/main';
  
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ElevatedButton(
            child: Text('Logout'),
            onPressed: () {
              Navigator.pushReplacementNamed(
                context,
                AuthPage.ROUTE_ID
              );
            },
          ),
        ),
      ),
    );
  }
}