import 'package:albify/screens/main/chats_view.dart';
import 'package:albify/screens/main/favorites_view.dart';
import 'package:albify/screens/main/search_view.dart';
import 'package:albify/screens/main/map_view.dart';
import 'package:albify/screens/main/profile_view.dart';
import 'package:albify/themes/app_style.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  static const String ROUTE_ID = '/main';
  
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  PageController pageController = PageController();

  void onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        children: [
          SearchView(),
          FavoritesView(),
          MapView(),
          ChatsView(),
          ProfileView()
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: AppStyle.appColorBlack,
          primaryColor: Colors.white,
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey[600],
          onTap: onTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search'
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: 'Favorites'
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Map'
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chats'
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile'
            ),
          ],
        ),
      )
    );
  }
}