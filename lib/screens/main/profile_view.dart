import 'package:flutter/material.dart';

import '../auth/auth_page.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ElevatedButton(
          child: Text('Logout'),
          onPressed: () {
            Navigator.pushReplacementNamed(context, AuthPage.ROUTE_ID);
          },
        ),
      ),
    );
  }
}
