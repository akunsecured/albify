import 'package:albify/models/user_model.dart';
import 'package:albify/screens/main/login_is_needed.dart';
import 'package:albify/services/database_service.dart';
import 'package:albify/themes/app_style.dart';
import 'package:albify/widgets/my_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser!.isAnonymous ?
      Center(child: LoginIsNeeded()) : 
      Container(
        alignment: Alignment.center,
        child: FutureBuilder(
          future: Provider.of<DatabaseService>(context, listen: false).getUserData(),
          builder: (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {
            List<Widget> children = [];
            if (snapshot.hasData) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                children = [
                  CircularProgressIndicator(
                    color: AppStyle.appColorGreen,
                  )
                ];
              } else {
                UserModel userModel = snapshot.data!;
                children = [
                  CircleAvatar(
                    backgroundColor: userModel.avatarUrl!.isEmpty ? Colors.black : null,
                    backgroundImage: userModel.avatarUrl!.isNotEmpty ? NetworkImage(userModel.avatarUrl!) : null,
                    child: userModel.avatarUrl!.isEmpty ? Text('?', style: TextStyle(color: Colors.white, fontSize: 32)) : null,
                    radius: 64,
                  ),
                  Text(
                    userModel.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => FirebaseAuth.instance.signOut(),
                    child: Text('Sign out')
                  )
                ];
              }
              
            } else if (snapshot.hasError) {
              children = [
                MyText(
                  text: 'Error'
                )
              ];
            } else {
              children = [
                CircularProgressIndicator(
                  color: AppStyle.appColorGreen,
                )
              ];
            }
            return Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            );
          }
        ),
      );
  }
}
