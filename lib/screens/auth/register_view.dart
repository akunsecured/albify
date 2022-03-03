import 'package:albify/common/utils.dart';
import 'package:albify/providers/auth_provider.dart';
import 'package:albify/themes/app_style.dart';
import 'package:albify/widgets/circular_text_form_field.dart';
import 'package:albify/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatefulWidget {
  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _registerFormKey = GlobalKey<FormState>();

  late final FocusNode _nameFocus, _emailFocus, _passwordFocus, _confirmPasswordFocus, _signUpButtonFocus;

  @override
  void initState() {
    _nameFocus = FocusNode();
    _emailFocus = FocusNode();
    _passwordFocus = FocusNode();
    _confirmPasswordFocus = FocusNode();
    _signUpButtonFocus = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AuthProvider _authProvider = Provider.of<AuthProvider>(context, listen: false);
    final CircularTextFormField confirmPasswordField = 
      CircularTextFormField(
        'Confirm password',
        Icon(Icons.lock),
        null,
        _authProvider.confirmPasswordController,
        obsecureText: true,
        isConfirm: true,
        matchWith: _authProvider.passwordController.text,
        focusNode: _confirmPasswordFocus,
        nextFocusNode: _signUpButtonFocus,
      );
    _authProvider.passwordController.addListener(() {
      confirmPasswordField.matchWith = _authProvider.passwordController.text;
    });
    return Container(
      margin: EdgeInsets.all(24),
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Register",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold
              ),
            ),
            Column(
              children: [
                CircularTextFormField(
                  'Name',
                  Icon(Icons.person),
                  Utils.validateName,
                  _authProvider.nameController,
                  inputType: TextInputType.name,
                  focusNode: _nameFocus,
                  nextFocusNode: _emailFocus,
                ),
                Utils.addVerticalSpace(8),
                CircularTextFormField(
                  'Email',
                  Icon(Icons.email),
                  Utils.validateEmail,
                  _authProvider.emailController,
                  inputType: TextInputType.emailAddress,
                  focusNode: _emailFocus,
                  nextFocusNode: _passwordFocus,
                ),
                Utils.addVerticalSpace(8),
                CircularTextFormField(
                  'Password',
                  Icon(Icons.lock),
                  Utils.validatePassword,
                  _authProvider.passwordController,
                  obsecureText: true,
                  focusNode: _passwordFocus,
                  nextFocusNode: _confirmPasswordFocus,
                ),
                Utils.addVerticalSpace(8),
                confirmPasswordField,
              ],
            ),
            Column(
              children: [
                Selector<AuthProvider, bool>(
                  selector: (_, authProvider) => authProvider.isLoading,
                  builder: (_, onLoading, __) => onLoading ?
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(AppStyle.appColorGreen),
                    )
                    : RoundedButton(
                      'Register',
                      () {
                        print(
                          'Name: ${_authProvider.nameController.text}\n' +
                          'Email: ${_authProvider.emailController.text}\n' +
                          'Password: ${_authProvider.passwordController.text}\n' +
                          'Confirm password: ${_authProvider.confirmPasswordController.text}'
                        );
                        if (_registerFormKey.currentState!.validate()) {
                          _authProvider.submit();
                        }
                      },
                      primary: AppStyle.appColorGreen,
                      focusNode: _signUpButtonFocus,
                    )
                ),
                Utils.addVerticalSpace(8),
                RoundedButton(
                  'I have an account',
                  _authProvider.changeView,
                  outlined: true,
                  primary: AppStyle.appColorGreen,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}