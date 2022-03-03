import 'package:albify/common/utils.dart';
import 'package:albify/models/property_model.dart';
import 'package:albify/services/database_service.dart';
import 'package:albify/themes/app_style.dart';
import 'package:albify/widgets/my_text.dart';
import 'package:albify/widgets/rounded_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<PropertyModel> properties = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: RoundedButton(
          'Search',
          () {},
          primary: Colors.amber,
          width: MediaQuery.of(context).size.width / 4,
        ),
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: Provider.of<DatabaseService>(context, listen: false).propertiesStream(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Align(
                alignment: Alignment.center,
                child: MyText(
                  text: "Error"
                ),
              );
            }

            if (
              snapshot.connectionState == ConnectionState.none ||
              snapshot.connectionState == ConnectionState.waiting
            ) {
              return Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  color: AppStyle.appColorGreen,
                )
              );
            }

            
            List<PropertyModel> properties = 
              snapshot.data!.docs.map(
                (doc) => PropertyModel.fromDocumentSnapshot(doc)
              ).toList();
            
            if (properties.length == 0) {
              return Align(
                alignment: Alignment.center,
                child: MyText(
                  text: 'There are no properties in the database'
                ),
              ); 
            }

            return ListView.builder(
              itemCount: properties.length,
              itemBuilder: (context, index) =>
                ListTile(
                  title: MyText(text: properties[index].id!),
                )
            );
          },
        )
        // child: FutureBuilder(
        //   future: Provider.of<DatabaseService>(context, listen: false).getAllProperties(),
        //   builder: (BuildContext context, AsyncSnapshot snapshot) {
        //     if (snapshot.hasError) {
        //       return Align(
        //         alignment: Alignment.center,
        //         child: MyText(
        //           text: "Error"
        //         ),
        //       );
        //     }

        //     if (
        //       snapshot.connectionState == ConnectionState.none ||
        //       snapshot.connectionState == ConnectionState.waiting ||
        //       snapshot.connectionState == ConnectionState.active
        //     ) {
        //       return Align(
        //         alignment: Alignment.center,
        //         child: CircularProgressIndicator(
        //           color: AppStyle.appColorGreen,
        //         )
        //       );
        //     }

        //     if (snapshot.connectionState == ConnectionState.done) {
        //       if (snapshot.data.length == 0) {
        //         return Align(
        //           alignment: Alignment.center,
        //           child: MyText(
        //             text: 'There are no properties in the database'
        //           ),
        //         );
        //       }

        //       return ListView.builder(
        //         itemCount: snapshot.data.length,
        //         itemBuilder: (context, index) =>
        //           ListTile(
        //             title: MyText(text: snapshot.data[index].id!),
        //           )
        //       );
        //     }

        //     return Align(
        //       alignment: Alignment.center,
        //       child: CircularProgressIndicator(
        //         color: AppStyle.appColorGreen,
        //       )
        //     );
        //   }
        // ),
      ),
      floatingActionButton: FirebaseAuth.instance.currentUser!.isAnonymous ? 
        null :
        FloatingActionButton(
          onPressed: () => addProperty(),
          child: Icon(Icons.add),
          backgroundColor: AppStyle.appColorGreen,
        ),
    );
  }

  void addProperty(
    // PropertyModel propertyModel
  ) async {
    PropertyModel propertyModel = PropertyModel(
      location: PropertyLocation(
        0.1, 0.1
      ),
      type: PropertyType.FLAT,
      rooms: 5,
      price: 100000,
      floorspace: 20,
      newlyBuilt: true,
      forSale: false,
      photoUrls: []
    );
    bool success = await Provider.of<DatabaseService>(context, listen: false).addProperty(propertyModel);
    Utils.showToast(
      success ? 'Property added successfully' : 'There was an error in adding a new property'
    );
  }
}