import 'package:albify/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EditProfileProvider extends ChangeNotifier {
  final DatabaseService databaseService;

  bool isLoading = false, isDisposed = false, isEnabled = false;
  late final TextEditingController _nameController,
      _emailController,
      _passwordController,
      _phoneNumberController,
      _contactEmailController;

  EditProfileProvider(this.databaseService) {
    _nameController = TextEditingController();
    _nameController.addListener(updateIsEnabled);
    _emailController = TextEditingController();
    _emailController.addListener(updateIsEnabled);
    _passwordController = TextEditingController();
    _passwordController.addListener(updateIsEnabled);
    _phoneNumberController = TextEditingController();
    _phoneNumberController.addListener(updateIsEnabled);
    _contactEmailController = TextEditingController();
    _contactEmailController.addListener(updateIsEnabled);
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

  void updateIsEnabled() {
    if (_nameController.text.trim().isNotEmpty ||
        _emailController.text.trim().isNotEmpty ||
        _passwordController.text.trim().isNotEmpty ||
        _phoneNumberController.text.trim().isNotEmpty ||
        _contactEmailController.text.trim().isNotEmpty) {
      isEnabled = true;
    } else {
      isEnabled = false;
    }
    notifyListeners();
  }

  Future<bool> saveProfile() async {
    await changeLoadingStatus();
    await Future.delayed(Duration(milliseconds: 500));

    var oldUser = await databaseService.getUserData();
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (_emailController.text.isNotEmpty &&
        _emailController.text.toLowerCase() != currentUser!.email)
      currentUser.updateEmail(_emailController.text.toLowerCase());

    if (_passwordController.text.isNotEmpty)
      currentUser!.updatePassword(_passwordController.text);

    if (oldUser != null) {
      String name = _nameController.text.isEmpty
          ? oldUser.name
          : _nameController.text.toString();
      String? contactEmail = _contactEmailController.text.isEmpty
          ? oldUser.contactEmail
          : _contactEmailController.text.toString();
      int? phoneNumber = _phoneNumberController.text.isEmpty
          ? oldUser.phoneNumber
          : int.parse(_phoneNumberController.text);

      databaseService.editProfile(oldUser.id,
          name: name, contactEmail: contactEmail, phoneNumber: phoneNumber);

      return true;
    }

    return false;
  }

  Future<bool> deleteProfile(String password) async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    AuthCredential credential = EmailAuthProvider.credential(
        email: currentUser!.email!, password: password);

    try {
      var newUser = await currentUser.reauthenticateWithCredential(credential);
      newUser.user!.delete();
      return true;
    } on Exception catch (e) {
      print(e.toString());
      return false;
    }
  }
}
