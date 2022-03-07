import 'package:albify/common/utils.dart';
import 'package:albify/themes/app_style.dart';
import 'package:albify/widgets/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginIsNeeded extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'This function is avaible only for authenticated users! Log in to enjoy fully the application!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16
            ),
          ),
          Utils.addVerticalSpace(32),
          RoundedButton(
            text: "Login",
            onPressed: () {
              FirebaseAuth.instance.currentUser!.delete();
            },
            width: MediaQuery.of(context).size.width / 3,
            primary: AppStyle.appColorGreen,
          )
        ],
      ),
    );
  }
}