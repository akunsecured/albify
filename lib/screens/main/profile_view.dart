import 'package:albify/common/constants.dart';
import 'package:albify/common/utils.dart';
import 'package:albify/models/user_model.dart';
import 'package:albify/widgets/login_is_needed.dart';
import 'package:albify/screens/profile/edit_profile_page.dart';
import 'package:albify/services/database_service.dart';
import 'package:albify/themes/app_style.dart';
import 'package:albify/widgets/add_property_dialog.dart';
import 'package:albify/widgets/my_alert_dialog.dart';
import 'package:albify/widgets/my_text.dart';
import 'package:albify/widgets/rounded_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  final String? userID;

  ProfileView({this.userID});

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late final User currentUser;
  late final Stream<UserModel?> stream;
  late bool isOwnProfile = false;

  @override
  void initState() {
    super.initState();
    currentUser = _firebaseAuth.currentUser!;
    isOwnProfile = currentUser.uid == widget.userID || widget.userID == null;
    if (!(currentUser.isAnonymous && isOwnProfile)) {
      stream = Provider.of<DatabaseService>(context, listen: false)
          .userStream(userID: widget.userID);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;

    return (currentUser.isAnonymous && isOwnProfile)
        ? Center(child: LoginIsNeeded())
        : Scaffold(
            appBar: AppBar(
              title: Text('Profile'),
              centerTitle: true,
            ),
            body: StreamBuilder<UserModel?>(
              stream: stream,
              builder:
                  (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {
                if (snapshot.hasError) {
                  return Align(
                    alignment: Alignment.center,
                    child: MyText(text: "Error"),
                  );
                }

                if (snapshot.connectionState == ConnectionState.none ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        color: AppStyle.appColorGreen,
                      ));
                }

                var userModel = snapshot.data!;
                return buildProfileView(userModel, _size);
              },
            ));
  }

  Widget buildProfileView(UserModel userModel, Size size) => Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Utils.addVerticalSpace(24),
              SizedBox(
                height: 128,
                width: 128,
                child: Stack(
                    clipBehavior: Clip.none,
                    fit: StackFit.expand,
                    children: [
                      CircleAvatar(
                        backgroundColor:
                            userModel.avatarUrl!.isEmpty ? Colors.black : null,
                        backgroundImage: userModel.avatarUrl!.isNotEmpty
                            ? NetworkImage(userModel.avatarUrl!)
                            : null,
                        child: userModel.avatarUrl!.isEmpty
                            ? Text('?',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 32))
                            : null,
                        radius: 64,
                      ),
                      Positioned(
                        bottom: 0,
                        right: -32,
                        child: RawMaterialButton(
                          child: Icon(
                            Icons.camera_alt,
                            color: AppStyle.appColorGreen,
                          ),
                          onPressed: selectImage,
                          fillColor: AppStyle.appColorBlack,
                          shape: CircleBorder(),
                          elevation: 0,
                        ),
                      ),
                    ]),
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
                      width: getPreferredSize(size),
                      isItNavigation: false,
                      primary: Theme.of(context).backgroundColor,
                      onPressed: () => showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              AddPropertyDialog()).then((value) => {
                            if (value != null)
                              Utils.showToast(value
                                  ? 'Property added successfully'
                                  : 'There was an error in adding the new property')
                          })),
                  buildProfileMenuItem(
                      icon: Icons.settings,
                      text: 'Settings',
                      width: getPreferredSize(size),
                      primary: Theme.of(context).backgroundColor,
                      onPressed: () => Navigator.of(context)
                          .pushNamed(EditProfilePage.ROUTE_ID)),
                  buildProfileMenuItem(
                      icon: Icons.logout,
                      text: 'Logout',
                      width: getPreferredSize(size),
                      isItNavigation: false,
                      primary: AppStyle.appColorGreen,
                      onPressed: () => showDialog(
                          context: context,
                          builder: (BuildContext context) => MyAlertDialog(
                              title: 'Logging out',
                              content: 'Are you sure you want to log out?',
                              onPositiveButtonPressed: () {
                                _firebaseAuth.signOut();
                                Navigator.pop(context);
                              },
                              onNegativeButtonPressed: () =>
                                  Navigator.pop(context))))
                ],
              )
            ],
          ),
        ),
      );

  Widget buildProfileMenuItem(
          {required IconData icon,
          required String text,
          required double width,
          bool isItNavigation = true,
          Color? primary,
          Function()? onPressed}) =>
      Container(
        margin: EdgeInsets.symmetric(horizontal: MARGIN_HORIZONTAL)
            .copyWith(bottom: 8),
        child: RoundedButton(
          icon: icon,
          text: text,
          width: width,
          isItNavigation: isItNavigation,
          primary: primary,
          onPressed: onPressed,
        ),
      );

  selectImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['jpg', 'png', 'jpeg']);

    if (result != null) {
      await Provider.of<DatabaseService>(context, listen: false)
          .uploadProfilePicture(result.files.first);
    }
  }
}
