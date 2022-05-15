import 'package:albify/common/constants.dart';
import 'package:albify/common/utils.dart';
import 'package:albify/models/user_model.dart';
import 'package:albify/providers/edit_profile_provider.dart';
import 'package:albify/services/auth_service.dart';
import 'package:albify/services/database_service.dart';
import 'package:albify/themes/app_style.dart';
import 'package:albify/widgets/circular_text_form_field.dart';
import 'package:albify/widgets/my_alert_dialog.dart';
import 'package:albify/widgets/my_text.dart';
import 'package:albify/widgets/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  static const String ROUTE_ID = '/edit';

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _editProfileFormKey = GlobalKey<FormState>();
  late final Future<UserModel?> future;
  late EditProfileProvider _editProfileProvider;
  late Size _size;
  late final AuthService _authService;
  late final User currentUser;

  @override
  void initState() {
    currentUser = FirebaseAuth.instance.currentUser!;
    _authService = Provider.of<AuthService>(context, listen: false);
    future = Provider.of<DatabaseService>(context, listen: false).getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit profile'),
        centerTitle: true,
      ),
      body: ChangeNotifierProvider(
          create: (_) => EditProfileProvider(
              Provider.of<DatabaseService>(context, listen: false)),
          builder: (context, child) {
            _editProfileProvider =
                Provider.of<EditProfileProvider>(context, listen: false);

            return Align(
              alignment: Alignment.center,
              child: Container(
                width: getPreferredSize(_size),
                margin: EdgeInsets.symmetric(
                    horizontal: MARGIN_HORIZONTAL, vertical: 16),
                child: FutureBuilder(
                    future: this.future,
                    builder: (BuildContext context,
                        AsyncSnapshot<UserModel?> snapshot) {
                      if (snapshot.hasError) {
                        print(snapshot.error);
                        return Align(
                          alignment: Alignment.center,
                          child: MyText(text: 'Error'),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.none ||
                          snapshot.connectionState == ConnectionState.waiting ||
                          snapshot.connectionState == ConnectionState.active) {
                        return Align(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              color: AppStyle.appColorGreen,
                            ));
                      }

                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.data != null) {
                          return buildPage(snapshot.data!);
                        }
                      }

                      return Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            color: AppStyle.appColorGreen,
                          ));
                    }),
              ),
            );
          }),
    );
  }

  Widget buildPage(UserModel userModel) => Form(
        key: _editProfileFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              children: [
                CircularTextFormField(
                  hintText: userModel.name,
                  icon: Icon(Icons.person),
                  validateFun: () {},
                  textEditingController: _editProfileProvider.nameController,
                  inputType: TextInputType.name,
                  fillColor: Colors.white,
                ),
                Utils.addVerticalSpace(16),
                CircularTextFormField(
                  hintText: currentUser.email ?? 'Email',
                  icon: Icon(Icons.email),
                  validateFun: () {},
                  textEditingController: _editProfileProvider.emailController,
                  inputType: TextInputType.emailAddress,
                  fillColor: Colors.white,
                ),
                Utils.addVerticalSpace(16),
                CircularTextFormField(
                  hintText: 'Password',
                  icon: Icon(Icons.lock),
                  validateFun: Utils.validatePassword,
                  textEditingController:
                      _editProfileProvider.passwordController,
                  obsecureText: true,
                  fillColor: Colors.white,
                ),
                Utils.addVerticalSpace(16),
                CircularTextFormField(
                  hintText: userModel.phoneNumber == null ||
                          userModel.phoneNumber == -1
                      ? 'Phone number'
                      : userModel.phoneNumber.toString(),
                  icon: Icon(Icons.phone),
                  validateFun: () {},
                  textEditingController:
                      _editProfileProvider.phoneNumberController,
                  inputType: TextInputType.phone,
                  fillColor: Colors.white,
                ),
                Utils.addVerticalSpace(16),
                CircularTextFormField(
                  hintText: userModel.contactEmail == null ||
                          userModel.contactEmail!.isEmpty
                      ? 'Contact email'
                      : userModel.contactEmail!,
                  icon: Icon(Icons.mark_email_unread),
                  validateFun: () {},
                  textEditingController:
                      _editProfileProvider.contactEmailController,
                  inputType: TextInputType.emailAddress,
                  fillColor: Colors.white,
                ),
              ],
            ),
            Column(
              children: [
                RoundedButton(
                  text: 'Save profile',
                  primary: AppStyle.appColorGreen,
                  onPressed: () {},
                  width: getPreferredSize(_size),
                ),
                Utils.addVerticalSpace(24),
                RoundedButton(
                  text: 'Delete profile',
                  primary: Colors.red,
                  onPressed: () => showDialog(
                      context: context,
                      builder: (context) => MyAlertDialog(
                          title: 'Deleting profile',
                          content: 'Are you sure you want to delete your profile?',
                          onPositiveButtonPressed: () => _authService
                              .login(
                                  email: _authService.currentUser!.email!,
                                  password: '123456')
                              .then((_) => _authService
                                  .deleteProfile()
                                  .then((value) => Navigator.of(context).pop())),
                          onNegativeButtonPressed: () =>
                              Navigator.of(context).pop())),
                  width: getPreferredSize(_size),
                ),
              ],
            )
          ],
        ),
      );
}
