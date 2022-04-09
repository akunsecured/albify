import 'package:albify/common/constants.dart';
import 'package:albify/common/utils.dart';
import 'package:albify/providers/edit_profile_provider.dart';
import 'package:albify/services/auth_service.dart';
import 'package:albify/services/database_service.dart';
import 'package:albify/widgets/circular_text_form_field.dart';
import 'package:albify/widgets/my_alert_dialog.dart';
import 'package:albify/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  static const String ROUTE_ID = '/edit';

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _editProfileFormKey = GlobalKey<FormState>();
  late EditProfileProvider _editProfileProvider;

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = Provider.of<AuthService>(context, listen: false);
    final Size _size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit profile'),
        centerTitle: true,
      ),
      body: ChangeNotifierProvider(
        create: (_) => EditProfileProvider(Provider.of<DatabaseService>(context, listen: false)),
        builder: (context, child) {
          _editProfileProvider = Provider.of<EditProfileProvider>(context, listen: false);

          return Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(
              horizontal: MARGIN_HORIZONTAL,
              vertical: 16
            ),
            child: Form(
              key: _editProfileFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    children: [
                      CircularTextFormField(
                        hintText: 'Name',
                        icon: Icon(Icons.person),
                        validateFun: () {},
                        textEditingController: _editProfileProvider.nameController,
                        inputType: TextInputType.name,
                      ),
                      CircularTextFormField(
                        hintText: 'Email',
                        icon: Icon(Icons.email),
                        validateFun: () {},
                        textEditingController: _editProfileProvider.emailController,
                        inputType: TextInputType.emailAddress,
                      ),
                      CircularTextFormField(
                        hintText: 'Password',
                        icon: Icon(Icons.lock),
                        validateFun: Utils.validatePassword,
                        textEditingController: _editProfileProvider.passwordController,
                        obsecureText: true,
                      ),
                      CircularTextFormField(
                        hintText: 'Phone number',
                        icon: Icon(Icons.phone),
                        validateFun: () {},
                        textEditingController: _editProfileProvider.phoneNumberController,
                        inputType: TextInputType.phone,
                      ),
                      CircularTextFormField(
                        hintText: 'Contact email',
                        icon: Icon(Icons.mark_email_unread),
                        validateFun: () {},
                        textEditingController: _editProfileProvider.contactEmailController,
                        inputType: TextInputType.emailAddress,
                      ),
                    ],
                  ),
                  RoundedButton(
                    text: 'Delete profile',
                    primary: Colors.red,
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => MyAlertDialog(
                        title: 'Deleting profile',
                        content: 'Are you sure you want to delete your profile?',
                        onPositiveButtonPressed: () =>
                          _authService.login(email: _authService.currentUser!.email!, password: '123456').then(
                            (_) => _authService.deleteProfile().then(
                              (value) => Navigator.of(context).pop()
                            )
                          ),
                        onNegativeButtonPressed: () => Navigator.of(context).pop()
                      )
                    ),
                    width: getPreferredSize(_size),
                  )
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}