import 'package:albify/common/constants.dart';
import 'package:albify/common/utils.dart';
import 'package:albify/models/user_model.dart';
import 'package:albify/screens/main/login_is_needed.dart';
import 'package:albify/services/database_service.dart';
import 'package:albify/themes/app_style.dart';
import 'package:albify/widgets/add_property_dialog.dart';
import 'package:albify/widgets/my_alert_dialog.dart';
import 'package:albify/widgets/my_text.dart';
import 'package:albify/widgets/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late final Future<UserModel?> future;

  @override
  void initState() {
    super.initState();
    future = Provider.of<DatabaseService>(context, listen: false).getUserData();
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;

    return FirebaseAuth.instance.currentUser!.isAnonymous ?
      Center(child: LoginIsNeeded()) : 
      Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: future,
          builder: (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {
            if (snapshot.hasError) {
              return Align(
                alignment: Alignment.center,
                child: MyText(
                  text: 'Error',
                ),
              );
            }
    
            if (
              snapshot.connectionState == ConnectionState.none ||
              snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.active
            ) {
              return Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  color: AppStyle.appColorGreen,
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              print('data read');
              if (snapshot.data != null) {
                UserModel userModel = snapshot.data!;
                return Container(
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Utils.addVerticalSpace(24),
                        CircleAvatar(
                          backgroundColor: userModel.avatarUrl!.isEmpty ? Colors.black : null,
                          backgroundImage: userModel.avatarUrl!.isNotEmpty ? NetworkImage(userModel.avatarUrl!) : null,
                          child: userModel.avatarUrl!.isEmpty ? Text('?', style: TextStyle(color: Colors.white, fontSize: 32)) : null,
                          radius: 64,
                        ),
                        MyText(
                          text: userModel.name,
                          fontSize: 24,
                        ),
                        MyText(
                          text: _firebaseAuth.currentUser!.email.toString(),
                          color: Colors.white60,
                          fontSize: 16,
                        ),
                        Utils.addVerticalSpace(48),
                        Column(
                          children: [
                            buildProfileMenuItem(
                              icon: Icons.upload,
                              text: 'Create advertisement',
                              width: getPreferredSize(_size),
                              isItNavigation: false,
                              primary: Theme.of(context).backgroundColor,
                              onPressed: () =>
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) => AddPropertyDialog()
                                ).then((value) => Utils.showToast(
                                  value ? 
                                  'Property added successfully' :
                                  'There was an error in adding the new property'
                                ))
                            ),
                            buildProfileMenuItem(
                              icon: Icons.settings,
                              text: 'Settings',
                              width: getPreferredSize(_size),
                              primary: Theme.of(context).backgroundColor
                            ),
                            buildProfileMenuItem(
                              icon: Icons.logout,
                              text: 'Logout',
                              width: getPreferredSize(_size),
                              isItNavigation: false,
                              primary: AppStyle.appColorGreen,
                              onPressed: () =>
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                    MyAlertDialog(
                                      title: 'Logging out',
                                      content: 'Are you sure you want to log out?', 
                                      onPositiveButtonPressed: () {
                                        _firebaseAuth.signOut();
                                        Navigator.pop(context);
                                      }, 
                                      onNegativeButtonPressed: () => Navigator.pop(context)
                                    )
                                )
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return Align(
                  alignment: Alignment.center,
                  child: MyText(
                    text: 'No data',
                  ),
                );
              }
            }
            return Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                color: AppStyle.appColorGreen,
              ),
            );
          }
        ),
      );
  }

  Widget buildProfileMenuItem({
    required IconData icon,
    required String text,
    required double width,
    bool isItNavigation = true,
    Color? primary,
    Function()? onPressed
  }) => Container(
    margin: EdgeInsets.symmetric(
      horizontal: 18
    ).copyWith(
      bottom: 8
    ),
    child: RoundedButton(
      icon: icon,
      text: text,
      width: width,
      isItNavigation: isItNavigation,
      primary: primary,
      onPressed: onPressed,
    ),
  );
}
