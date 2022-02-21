import 'package:albify/providers/auth_provider.dart';
import 'package:albify/screens/auth/login_view.dart';
import 'package:albify/screens/auth/register_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {  
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with TickerProviderStateMixin {
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
                  // child: isLogin ? LoginView(changeIsLogin) : RegisterView(changeIsLogin),
                  child: ChangeNotifierProvider(
                    create: (_) => AuthProvider(),
                    child: Selector<AuthProvider, bool>(
                      selector: (_, authProvider) => authProvider.onLogin,
                      builder: (_, onLogin, __) =>
                        onLogin ? LoginView() : RegisterView(),
                    ),
                  ),
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
                    FirebaseAuth.instance.signInAnonymously().then((userCredential) {
                      print(userCredential);
                      print(FirebaseAuth.instance.currentUser!);
                    });
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