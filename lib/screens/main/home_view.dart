import 'package:albify/animations/custom_page_route_builder.dart';
import 'package:albify/animations/slide_directions.dart';
import 'package:albify/models/property_model.dart';
import 'package:albify/screens/search_result/search_result_page.dart';
import 'package:albify/services/database_service.dart';
import 'package:albify/themes/app_style.dart';
import 'package:albify/widgets/my_text.dart';
import 'package:albify/widgets/rounded_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
          text: 'Search',
          onPressed: () =>
            Navigator.push(
              context,
              CustomPageRouteBuilder(
                child: SearchResultPage(),
                direction: SlideDirections.FROM_DOWN
              )
            ),
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
      ),
    );
  }
}