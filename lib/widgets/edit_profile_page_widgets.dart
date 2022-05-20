import 'package:albify/common/constants.dart';
import 'package:albify/common/utils.dart';
import 'package:albify/models/user_model.dart';
import 'package:albify/providers/edit_profile_provider.dart';
import 'package:albify/services/auth_service.dart';
import 'package:albify/services/database_service.dart';
import 'package:albify/themes/app_style.dart';
import 'package:albify/widgets/circular_text_form_field.dart';
import 'package:albify/widgets/my_alert_dialog.dart';
import 'package:albify/widgets/my_circular_progress_indicator.dart';
import 'package:albify/widgets/my_error_printer.dart';
import 'package:albify/widgets/my_password_require_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'rounded_button.dart';

class EditProfilePageWidgets extends StatefulWidget {
  const EditProfilePageWidgets({Key? key}) : super(key: key);

  @override
  State<EditProfilePageWidgets> createState() => _EditProfilePageWidgetsState();
}

class _EditProfilePageWidgetsState extends State<EditProfilePageWidgets> {
  final _editProfileFormKey = GlobalKey<FormState>();
  late final AuthService _authService;
  late final EditProfileProvider _editProfileProvider;
  late Size _size;
  late final Future<UserModel?> future;
  late final User currentUser;

  @override
  void initState() {
    currentUser = FirebaseAuth.instance.currentUser!;
    _authService = Provider.of<AuthService>(context, listen: false);
    _editProfileProvider =
        Provider.of<EditProfileProvider>(context, listen: false);
    future = Provider.of<DatabaseService>(context, listen: false).getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;

    return Align(
      alignment: Alignment.center,
      child: Container(
        width: getPreferredSize(_size),
        margin:
            EdgeInsets.symmetric(horizontal: MARGIN_HORIZONTAL, vertical: 16),
        child: FutureBuilder(
            future: this.future,
            builder:
                (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {
              if (snapshot.hasError) {
                return MyErrorPrinter(error: snapshot.error.toString());
              }

              if (snapshot.connectionState == ConnectionState.none ||
                  snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.connectionState == ConnectionState.active) {
                return MyCircularProgressIndicator();
              }

              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data != null) {
                  return buildPage(snapshot.data!);
                }
              }

              return MyCircularProgressIndicator();
            }),
      ),
    );
  }

  Widget buildPage(UserModel userModel) {
    var isEnabled = context.watch<EditProfileProvider>().isEnabled;
    return Form(
      key: _editProfileFormKey,
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircularTextFormField(
                hintText: userModel.name,
                icon: Icon(Icons.person),
                validateFun: (value) =>
                    Utils.validateName(value, isNeeded: false),
                textEditingController: _editProfileProvider.nameController,
                inputType: TextInputType.name,
                fillColor: Colors.white,
              ),
              Utils.addVerticalSpace(16),
              CircularTextFormField(
                hintText: currentUser.email ?? 'Email',
                icon: Icon(Icons.email),
                validateFun: (value) =>
                    Utils.validateEmail(value, isNeeded: false),
                textEditingController: _editProfileProvider.emailController,
                inputType: TextInputType.emailAddress,
                fillColor: Colors.white,
              ),
              Utils.addVerticalSpace(16),
              CircularTextFormField(
                hintText: 'Password',
                icon: Icon(Icons.lock),
                validateFun: (value) =>
                    Utils.validatePassword(value, isNeeded: false),
                textEditingController: _editProfileProvider.passwordController,
                obsecureText: true,
                fillColor: Colors.white,
              ),
              Utils.addVerticalSpace(16),
              CircularTextFormField(
                hintText:
                    userModel.phoneNumber == null || userModel.phoneNumber == -1
                        ? 'Phone number'
                        : userModel.phoneNumber.toString(),
                icon: Icon(Icons.phone),
                validateFun: (value) =>
                    Utils.validatePhoneNumber(value, isNeeded: false),
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
                validateFun: (value) =>
                    Utils.validateEmail(value, isNeeded: false),
                textEditingController:
                    _editProfileProvider.contactEmailController,
                inputType: TextInputType.emailAddress,
                fillColor: Colors.white,
              ),
              Utils.addVerticalSpace(48),
              RoundedButton(
                text: 'Save profile',
                primary: AppStyle.appColorGreen,
                onPressed: doUpdate,
                enabled: isEnabled,
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
                        content:
                            'Are you sure you want to delete your profile?',
                        onPositiveButtonPressed: () async {
                          var result = await showDialog(
                              builder: (context) => MyPasswordRequireDialog(),
                              context: context);

                          if (result != null) {
                            _authService
                                .login(
                                    email: _authService.currentUser!.email!,
                                    password: result)
                                .then((_) => _authService.deleteProfile().then(
                                    (value) => Navigator.of(context).pop()));
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
                        onNegativeButtonPressed: () =>
                            Navigator.of(context).pop())),
                width: getPreferredSize(_size),
              ),
            ],
          ),
        ),
      ),
    );
  }

  doUpdate() async {
    if (_editProfileFormKey.currentState!.validate()) {
      if (_editProfileProvider.emailController.text.isNotEmpty ||
          _editProfileProvider.passwordController.text.isNotEmpty) {
        var result = await showDialog(
            builder: (context) => MyPasswordRequireDialog(), context: context);
        if (result == null) {
          return;
        }
        var success = await _authService.login(
            email: currentUser.email!, password: result);
        if (!success) {
          return;
        }
      }
      _editProfileProvider.saveProfile().then((value) {
        if (value) {
          Utils.showToast('Profile updated successfully');
          _editProfileProvider.nameController.clear();
          _editProfileProvider.emailController.clear();
          _editProfileProvider.passwordController.clear();
          _editProfileProvider.contactEmailController.clear();
          _editProfileProvider.phoneNumberController.clear();
        } else {
          Utils.showToast('There was an error updating the profile');
        }
      });
    }
  }
}
