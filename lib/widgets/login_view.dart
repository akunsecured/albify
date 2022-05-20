import 'package:albify/common/utils.dart';
import 'package:albify/providers/auth_provider.dart';
import 'package:albify/themes/app_style.dart';
import 'package:albify/widgets/circular_text_form_field.dart';
import 'package:albify/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _loginFormKey = GlobalKey<FormState>();
  late final FocusNode _emailFocus, _passwordFocus, _loginButtonFocus;

  @override
  void initState() {
    _emailFocus = FocusNode();
    _passwordFocus = FocusNode();
    _loginButtonFocus = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AuthProvider _authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    return Container(
      margin: EdgeInsets.all(24),
      child: Form(
        key: _loginFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Login",
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
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
                  nextFocusNode: _loginButtonFocus,
                ),
              ],
            ),
            Column(
              children: [
                Selector<AuthProvider, bool>(
                    selector: (_, authProvider) => authProvider.isLoading,
                    builder: (_, onLoading, __) => onLoading
                        ? CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation(AppStyle.appColorGreen),
                          )
                        : RoundedButton(
                            text: 'Login',
                            onPressed: () async {
                              if (_loginFormKey.currentState!.validate()) {
                                await _authProvider.submit();
                              }
                            },
                            primary: AppStyle.appColorGreen,
                            focusNode: _loginButtonFocus,
                          )),
                Utils.addVerticalSpace(8),
                RoundedButton(
                  text: 'Sign up',
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
