import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  static const String ROUTE_ID = "/auth";
  
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        
      ),
    );
  }
}