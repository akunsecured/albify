import 'package:albify/common/utils.dart';
import 'package:albify/providers/auth_provider.dart';
import 'package:albify/themes/app_style.dart';
import 'package:albify/widgets/circular_text_form_field.dart';
import 'package:albify/widgets/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  // final Function() onSignUpPressed;

  // LoginView(
  //   this.onSignUpPressed
  // );

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _loginFormKey = GlobalKey<FormState>();

  String? email, password;

  @override
  Widget build(BuildContext context) {
    final AuthProvider _authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Container(
      margin: EdgeInsets.all(24),
      child: Form(
        key: _loginFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularTextFormField(
              'Email',
              Icon(Icons.email),
              Utils.validateEmail,
              onEmailChanged,
              inputType: TextInputType.emailAddress,
            ),
            Utils.addVerticalSpace(8),
            CircularTextFormField(
              'Password',
              Icon(Icons.lock),
              Utils.validatePassword,
              onPasswordChanged,
              obsecureText: true,
            ),
            Utils.addVerticalSpace(36),
            RoundedButton(
              'Login',
              onLoginPressed,
              primary: AppStyle.appColorGreen,
            ),
            Utils.addVerticalSpace(8),
            RoundedButton(
              'Sign up',
              _authProvider.changeView,
              outlined: true,
              primary: AppStyle.appColorGreen,
            ),
          ],
        ),
      ),
    );
  }

  onEmailChanged(String? value) {
    email = value;
  }

  onPasswordChanged(String? value) {
    password = value;
  }

  onLoginPressed() async {
    if (_loginFormKey.currentState!.validate()) {
      print('Email: $email\nPassword: $password');
      Utils.showLoadingDialog(context);
      FirebaseAuth.instance.signInWithEmailAndPassword(email: 'teszt@elek.me', password: '12345678')
        .then((userCredential) {
          Navigator.pop(context);
        });
    }
  }
}