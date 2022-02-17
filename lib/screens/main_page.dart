import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  static const String ROUTE_ID = '/';
  
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

      ),
    );
  }
}