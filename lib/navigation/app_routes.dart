import 'package:albify/screens/chat/chat_screen.dart';
import 'package:albify/screens/profile/edit_profile_page.dart';
import 'package:albify/screens/starting_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    StartingPage.ROUTE_ID: (context) => StartingPage(),
    ChatScreen.ROUTE_ID: (context) => ChatScreen(),
    EditProfilePage.ROUTE_ID: (context) => EditProfilePage()
  };
}
