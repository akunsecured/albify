import 'package:albify/models/property_model.dart';
import 'package:albify/models/user_model.dart';
import 'package:albify/widgets/login_is_needed.dart';
import 'package:albify/services/database_service.dart';
import 'package:albify/themes/app_style.dart';
import 'package:albify/widgets/my_text.dart';
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
    return FirebaseAuth.instance.currentUser!.isAnonymous ?
      Center(child: LoginIsNeeded()) :
      Scaffold(
        appBar: AppBar(
          title: Text('Saved properties'),
          centerTitle: true,
        ),
        body: Container(
          child: MultiProvider(
            providers: [
              StreamProvider<UserModel?>.value(
                value: Provider.of<DatabaseService>(context, listen: false).userStream(),
                initialData: null,
                catchError: (_, err) {
                  print(err);
                },
              )
            ],
            child: FutureBuilder(
              future: getFavProperties(),
              builder: (BuildContext context, AsyncSnapshot<List<PropertyModel>> snapshot) {
                if (snapshot.hasError) {
                  return Align(
                    alignment: Alignment.center,
                    child: MyText(
                      text: 'Error'
                    ),
                  );
                }
      
                if (
                  snapshot.connectionState == ConnectionState.none ||
                  snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.connectionState == ConnectionState.active
                ) {
                  return Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      color: AppStyle.appColorGreen,
                    )
                  );
                }
      
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data!.isNotEmpty) {
                    return Align(
                      alignment: Alignment.center,
                      child: MyText(
                        text: snapshot.data!.map((p) => p.id).toString()
                      )
                    );
                  }
                  else {
                    return Align(
                      alignment: Alignment.center,
                      child: MyText(
                        text: "Has no data"
                      )
                    );
                  }
                }
      
                return Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    color: AppStyle.appColorGreen,
                  )
                );
              },
            ),
          )
        ),
      );
  }

  Future<List<PropertyModel>> getFavProperties() {
    final userModel = Provider.of<UserModel>(context, listen: false);
    List<String> favPropertyIDs = [];

    favPropertyIDs = userModel.propertyIDs?.cast<String>() ?? [];

    return Provider.of<DatabaseService>(context, listen: false).getProperties(favPropertyIDs);
  }
}