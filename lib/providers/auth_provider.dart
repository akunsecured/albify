import 'package:albify/services/auth_service.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService authService;

  bool isLoginView = true;
  bool isLoading = false;
  bool isLoadingAnonymous = false;
  bool isDisposed = false;


  late final TextEditingController _nameController, _emailController, _passwordController, _confirmPasswordController;

  AuthProvider(this.authService) {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  TextEditingController get nameController => _nameController;
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  TextEditingController get confirmPasswordController => _confirmPasswordController;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    isDisposed = true;
    super.dispose();
  }

  clearControllers() {
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
  }

  changeView() {
    if (!isLoading) {
      isLoginView = !isLoginView;
      clearControllers();
      notifyListeners();
    }
  }

  changeLoadingStatus() async {
    isLoading = !isLoading;
    if (!isDisposed) notifyListeners();
  }

  Future<void> submit() async {
    await changeLoadingStatus();
    await Future.delayed(Duration(milliseconds: 500));

    if (isLoginView) {
      await authService.login(
        email: _emailController.text,
        password: _passwordController.text
      );
    } else {
      await authService.signUp(
        email: _emailController.text,
        password: _passwordController.text,
        name: _nameController.text
      );
    }

    changeLoadingStatus();
  }

  changeLoadingAnonymousStatus() async {
    isLoadingAnonymous = !isLoadingAnonymous;
    if (!isDisposed) notifyListeners();
  }

  Future<void> anonymousLogin() async {
    await changeLoadingAnonymousStatus();
    await Future.delayed(Duration(milliseconds: 500));

    await authService.signInAnonymously();

    changeLoadingAnonymousStatus();
  }
}