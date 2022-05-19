import 'package:albify/models/property_model.dart';
import 'package:albify/models/user_model.dart';
import 'package:albify/providers/favorite_property_provider.dart';
import 'package:albify/widgets/favorite_list.dart';
import 'package:albify/widgets/login_is_needed.dart';
import 'package:albify/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesView extends StatefulWidget {
  @override
  _FavoritesViewState createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  late final UserModel? user;
  List<PropertyModel> favoriteProperties = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved properties'),
        centerTitle: true,
      ),
      body: FirebaseAuth.instance.currentUser!.isAnonymous
          ? Center(child: LoginIsNeeded())
          : ChangeNotifierProvider(
              create: (_) => FavoritePropertyProvider(
                  Provider.of<DatabaseService>(context, listen: false)),
              builder: (context, child) =>
                  StreamProvider<List<PropertyModel>>.value(
                    value: Provider.of<FavoritePropertyProvider>(context,
                            listen: false)
                        .favoriteProperties(),
                    initialData: [],
                    child: FavoriteList(),
                  )),
    );
  }
}
