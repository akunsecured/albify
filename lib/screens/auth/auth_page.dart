import 'package:albify/screens/auth/login_view.dart';
import 'package:albify/screens/auth/register_view.dart';
import 'package:albify/screens/main/main_page.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  static const String ROUTE_ID = "/auth";
  
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with TickerProviderStateMixin {
  bool isLogin = true;

  changeIsLogin() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
            maxWidth: MediaQuery.of(context).size.width
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: 64
                ),
                child: Image.asset(
                  'assets/images/albify_logo_white.png',
                  height: 100,
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: isLogin ? LoginView(changeIsLogin) : RegisterView(changeIsLogin),
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: TextButton(
                  child: Text(
                    'Continue without authenticate',
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      MainPage.ROUTE_ID
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}