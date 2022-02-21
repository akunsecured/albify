import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  bool onLogin = true;

  changeView() {
    onLogin = !onLogin;
    notifyListeners();
  }
}