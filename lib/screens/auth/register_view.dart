import 'package:albify/common/utils.dart';
import 'package:albify/themes/app_style.dart';
import 'package:albify/widgets/circular_text_form_field.dart';
import 'package:albify/widgets/rounded_button.dart';
import 'package:flutter/material.dart';

import '../main_page.dart';

class RegisterView extends StatefulWidget {
  Function() onLoginPressed;

  RegisterView(
    this.onLoginPressed
  );

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _registerFormKey = GlobalKey<FormState>();

  String? name, email, password, confirmPassword;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(24),
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularTextFormField(
              'Name',
              Icon(Icons.person),
              Utils.validateName,
              onNameChanged,
              inputType: TextInputType.name,
            ),
            Utils.addVerticalSpace(8),
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
            Utils.addVerticalSpace(8),
            CircularTextFormField(
              'Confirm password',
              Icon(Icons.lock),
              null,
              onConfirmPasswordChanged,
              obsecureText: true,
              isConfirm: true,
              matchWith: confirmPassword,
            ),
            Utils.addVerticalSpace(36),
            RoundedButton(
              'Register',
              onRegisterPressed,
              primary: AppStyle.appColorGreen,
            ),
            Utils.addVerticalSpace(8),
            RoundedButton(
              'I have an account',
              widget.onLoginPressed,
              outlined: true,
              primary: AppStyle.appColorGreen,
            ),
          ],
        ),
      ),
    );
  }

  onNameChanged(String? value) {
    name = value;
  }

  onEmailChanged(String? value) {
    email = value;
  }

  onPasswordChanged(String? value) {
    password = value;
  }

  onConfirmPasswordChanged(String? value) {
    confirmPassword = value;
  }

  onRegisterPressed() async {
    if (_registerFormKey.currentState!.validate()) {
      print('Name: $name\nEmail: $email\nPassword: $password\nConfirm password: $confirmPassword');
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