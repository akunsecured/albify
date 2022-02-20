import 'package:albify/widgets/rounded_button.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: RoundedButton(
          'Search',
          () {},
          primary: Colors.amber,
          width: MediaQuery.of(context).size.width / 4,
        ),
      ),
    );
  }
}