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
        hintText: 'Confirm password',
        icon: Icon(Icons.lock),
        validateFun: (String? value) {
          print('Confirm password:\t$value');
          print('Password:\t${_authProvider.passwordController.text}');
          if (value == null || value.isEmpty)
            return 'Confirm password must be filled';
          if (value != _authProvider.passwordController.text)
            return 'Passwords do not match';
          return null;
        },
        textEditingController: _authProvider.confirmPasswordController,
        obsecureText: true,
        focusNode: _confirmPasswordFocus,
        nextFocusNode: _signUpButtonFocus,
      );
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
                  hintText: 'Name',
                  icon: Icon(Icons.person),
                  validateFun: Utils.validateName,
                  textEditingController: _authProvider.nameController,
                  inputType: TextInputType.name,
                  focusNode: _nameFocus,
                  nextFocusNode: _emailFocus,
                ),
                Utils.addVerticalSpace(8),
                CircularTextFormField(
                  hintText: 'Email',
                  icon: Icon(Icons.email),
                  validateFun: Utils.validateEmail,
                  textEditingController: _authProvider.emailController,
                  inputType: TextInputType.emailAddress,
                  focusNode: _emailFocus,
                  nextFocusNode: _passwordFocus,
                ),
                Utils.addVerticalSpace(8),
                CircularTextFormField(
                  hintText: 'Password',
                  icon: Icon(Icons.lock),
                  validateFun: Utils.validatePassword,
                  textEditingController: _authProvider.passwordController,
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
                      text: 'Register',
                      onPressed: () {
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
                  text: 'I have an account',
                  onPressed: _authProvider.changeView,
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