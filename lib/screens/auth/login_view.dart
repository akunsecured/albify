import 'package:albify/common/utils.dart';
import 'package:albify/screens/main/main_page.dart';
import 'package:albify/themes/app_style.dart';
import 'package:albify/widgets/circular_text_form_field.dart';
import 'package:albify/widgets/rounded_button.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  Function() onSignUpPressed;

  LoginView(
    this.onSignUpPressed
  );

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _loginFormKey = GlobalKey<FormState>();

  String? email, password;

  @override
  Widget build(BuildContext context) {
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
              widget.onSignUpPressed,
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
      await Future.delayed(Duration(milliseconds: 3000)).then((_) {
        // Pop loading dialog
        Navigator.pop(context);
        Navigator.pushReplacementNamed(
          context,
          MainPage.ROUTE_ID
        );
      });
    }
  }
}