import 'package:albify/models/user_model.dart';
import 'package:albify/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EditProfileProvider extends ChangeNotifier {
  final DatabaseService databaseService;

  bool isLoading = false, isDisposed = false;
  late final TextEditingController _nameController, _emailController, _passwordController, _phoneNumberController, _contactEmailController;

  EditProfileProvider(this.databaseService) {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _contactEmailController = TextEditingController();
  }

  TextEditingController get nameController => _nameController;
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  TextEditingController get phoneNumberController => _phoneNumberController;
  TextEditingController get contactEmailController => _contactEmailController;

  changeLoadingStatus() async {
    isLoading = !isLoading;
    if (!isDisposed) notifyListeners();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneNumberController.dispose();
    _contactEmailController.dispose();
    isDisposed = true;
    super.dispose();
  }

  Future<bool> saveProfile() async {
    await changeLoadingStatus();
    await Future.delayed(Duration(milliseconds: 500));

    var oldUser = await databaseService.getUserData();
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (
      _emailController.text.toLowerCase() != currentUser!.email
    ) currentUser.updateEmail(_emailController.text.toLowerCase());

    if (
      _passwordController.text.isNotEmpty
    ) currentUser.updatePassword(_passwordController.text);

    if (oldUser != null) {
      databaseService.editProfile(
        UserModel(
          id: oldUser.id,
          name: _nameController.text,
          avatarUrl: oldUser.avatarUrl,
          contactEmail: _contactEmailController.text,
          phoneNumber: int.parse(_phoneNumberController.text),
          propertyIDs: oldUser.propertyIDs
        )
      );

      return true;
    }

    return false;
  }

  Future<bool> deleteProfile(String password) async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    AuthCredential credential = EmailAuthProvider.credential(email: currentUser!.email!, password: password);

    try {
      var newUser = await currentUser.reauthenticateWithCredential(
        credential
      );
      return true;
    } on Exception catch (e) {
      print(e.toString());
      return false;
    }
  }
}