import 'package:albify/providers/auth_provider.dart';
import 'package:albify/screens/auth/login_view.dart';
import 'package:albify/screens/auth/register_view.dart';
import 'package:albify/services/auth_service.dart';
import 'package:albify/themes/app_style.dart';
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
                  height: 80,
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)
                  ),
                  // child: Provider<AuthService>(
                  //   create: (_) => AuthService(),
                  //   builder: (context, child) => ChangeNotifierProvider(
                  //     create: (_) => AuthProvider(Provider.of<AuthService>(context, listen: false)),
                  //     builder: (context, child) => Selector<AuthProvider, bool>(
                  //       selector: (_, authProvider) => authProvider.isLoginView,
                  //       builder: (_, onLogin, __) =>
                  //         onLogin ? LoginView() : RegisterView(),
                  //     ),
                  //   ),
                  // ),
                  child: ChangeNotifierProvider(
                    create: (_) => AuthProvider(Provider.of<AuthService>(context, listen: false)),
                    builder: (context, child) => Selector<AuthProvider, bool>(
                      selector: (_, authProvider) => authProvider.isLoginView,
                      builder: (_, onLogin, __) =>
                        onLogin ? LoginView() : RegisterView()
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: ChangeNotifierProvider(
                    create: (_) => AuthProvider(Provider.of<AuthService>(context, listen: false)),
                    builder: (context, child) => Selector<AuthProvider, bool>(
                      selector: (_, authProvider) => authProvider.isLoadingAnonymous,
                      builder: (_, isLoadingAnonymous, __) {
                        final _authProvider = Provider.of<AuthProvider>(context, listen: false);
                        return isLoadingAnonymous ?
                          CircularProgressIndicator(
                            color: AppStyle.appColorGreen,
                          ) :
                          TextButton(
                            child: Text(
                              'Continue without authenticate',
                              style: TextStyle(
                                color: Colors.white
                              ),
                            ),
                            onPressed: () {
                              _authProvider.anonymousLogin();
                              // FirebaseAuth.instance.signInAnonymously().then((userCredential) {
                              //   print(userCredential);
                              //   print(FirebaseAuth.instance.currentUser!);
                              // });
                            },
                          );
                      }
                    ),
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}