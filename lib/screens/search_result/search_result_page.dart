import 'package:albify/common/constants.dart';
import 'package:albify/models/property_model.dart';
import 'package:albify/models/property_search_models.dart';
import 'package:albify/services/database_service.dart';
import 'package:albify/themes/app_style.dart';
import 'package:albify/widgets/my_text.dart';
import 'package:albify/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchResultPage extends StatefulWidget {
  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  late Future<List<PropertyModel>> future;
  SearchSort sortingMode = SearchSort.PRICE_ASCENDING;

  @override
  Widget build(BuildContext context) {
    future = Provider.of<DatabaseService>(context).findProperties();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: RoundedButton(
          icon: Icons.edit,
          text: 'Search filters',
          isItNavigation: false,
          outlined: false,
          primary: Colors.grey[400],
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: () =>
              showDialog(
                context: context,
                builder: (context) =>
                  selectDialog()
              )
          )
        ],
      ),
      body: FutureBuilder<List<PropertyModel>>(
        future: this.future,
        builder: (BuildContext context, AsyncSnapshot<List<PropertyModel>> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
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
              print(snapshot.data!.map((property) => property.id).toList());
              return buildProperties(snapshot.data!); 
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
    );
  }

  void sortProperties(List<PropertyModel> properties) {
    switch (this.sortingMode) {
      case SearchSort.PRICE_ASCENDING:
        properties.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SearchSort.PRICE_DESCENDING:
        properties.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SearchSort.ROOMS_ASCENDING:
        properties.sort((a, b) => a.rooms.compareTo(b.rooms));
        break;
      case SearchSort.ROOMS_DESCENDING:
        properties.sort((a, b) => b.rooms.compareTo(a.rooms));
        break;
      case SearchSort.SPACEFLOOR_ASCENDING:
        properties.sort((a, b) => a.floorspace.compareTo(b.floorspace));
        break;
      case SearchSort.SPACEFLOOR_DESCENDING:
        properties.sort((a, b) => b.floorspace.compareTo(a.floorspace));
        break;
      default:
        properties.sort((a, b) => a.price.compareTo(b.price));
        break;
    }
  }

  Widget buildProperties(List<PropertyModel> properties) {
    sortProperties(properties);
    return ListView.builder(
      itemCount: properties.length,
      itemBuilder: (context, index) =>
        ListTile(
          title: MyText(text: properties[index].id!),
        )
    );
  }

  String searchSortEnumToString(SearchSort enumValue) {
    var temp = enumValue.toString().split('.')[1];
    var tempArray = temp.split('_');
    return temp.substring(0, 1) + tempArray[0].toLowerCase().substring(1) + ' (${tempArray[1].toLowerCase()})';
  }

  getListTiles() =>
    SearchSort.values.map(
      (enumValue) => ListTile(
        title: Text(searchSortEnumToString(enumValue)),
        trailing: Radio<SearchSort>(
          value: enumValue,
          groupValue: sortingMode,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                sortingMode = value;
              });
            }
            Navigator.pop(context);
          },
        ),
      )
    ).toList();

  Widget selectDialog() {
    List<Widget> children = [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: MyText(
          text: 'Sorting mode',
          fontWeight: FontWeight.bold,
          color: Colors.grey[800],
        ),
      ),
      Divider()
    ];
    children.addAll(getListTiles());

    return Dialog(
      backgroundColor: Colors.grey[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(RADIUS))
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}