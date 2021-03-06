import 'package:albify/animations/custom_page_route_builder.dart';
import 'package:albify/animations/slide_directions.dart';
import 'package:albify/common/constants.dart';
import 'package:albify/models/property_model.dart';
import 'package:albify/models/property_search_models.dart';
import 'package:albify/providers/search_result_filter_provider.dart';
import 'package:albify/screens/property/property_page.dart';
import 'package:albify/services/database_service.dart';
import 'package:albify/themes/app_style.dart';
import 'package:albify/widgets/my_text.dart';
import 'package:albify/widgets/property_card.dart';
import 'package:albify/widgets/rounded_button.dart';
import 'package:albify/widgets/search_result_filter_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';

class SearchResultPage extends StatefulWidget {
  final SearchQuery? searchQuery;

  SearchResultPage({this.searchQuery});

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  late Future<List<PropertyModel>> future;
  SearchQuery? searchQuery;
  SearchSort sortingMode = SearchSort.PRICE_ASCENDING;
  late Size _size;

  @override
  void initState() {
    searchQuery = widget.searchQuery;
    future = Provider.of<DatabaseService>(context, listen: false)
        .findProperties(searchQuery: searchQuery);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: RoundedButton(
          icon: Icons.edit,
          text: 'Search filters',
          isItNavigation: false,
          outlined: false,
          primary: Colors.grey[400],
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) => ChangeNotifierProvider(
                    create: (_) =>
                        SearchResultFilterProvider(searchQuery: searchQuery),
                    child: Consumer<SearchResultFilterProvider>(
                        builder: (BuildContext context,
                                SearchResultFilterProvider provider,
                                Widget? child) =>
                            SearchResultFilterDialog(
                                searchQuery: searchQuery)))).then((value) {
              if (value != null) {
                setState(() {
                  searchQuery = value;
                  future = Provider.of<DatabaseService>(context, listen: false)
                      .findProperties(searchQuery: searchQuery);
                });
              }
            });
          },
          width: getPreferredSize(_size),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.sort),
              onPressed: () => showDialog(
                  context: context, builder: (context) => selectDialog()))
        ],
      ),
      body: FutureBuilder<List<PropertyModel>>(
        future: this.future,
        builder: (BuildContext context,
            AsyncSnapshot<List<PropertyModel>> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Align(
              alignment: Alignment.center,
              child: MyText(text: 'Error'),
            );
          }

          if (snapshot.connectionState == ConnectionState.none ||
              snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.active) {
            return Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  color: AppStyle.appColorGreen,
                ));
          }

          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data!.isNotEmpty) {
              return buildProperties(snapshot.data!);
            } else {
              return Align(
                  alignment: Alignment.center,
                  child: MyText(text: "No results matched the filter"));
            }
          }

          return Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                color: AppStyle.appColorGreen,
              ));
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
    return SingleChildScrollView(
      child: Container(
        child: ResponsiveGridRow(
            children: properties
                .map((property) => ResponsiveGridCol(
                    xs: 12,
                    sm: 12,
                    md: 6,
                    lg: 6,
                    xl: 4,
                    child: PropertyCard(
                      property,
                      onTap: () async {
                        var result = await Navigator.push(
                            context,
                            CustomPageRouteBuilder(
                                child: PropertyPage(property: property),
                                direction: SlideDirections.FROM_DOWN));
                        if (result != null && result) {
                          setState(() {
                            future = Provider.of<DatabaseService>(context,
                                    listen: false)
                                .findProperties(searchQuery: searchQuery);
                          });
                        }
                      },
                    )))
                .toList()),
      ),
    );
  }

  String searchSortEnumToString(SearchSort enumValue) {
    var temp = enumValue.toString().split('.')[1];
    var tempArray = temp.split('_');
    return temp.substring(0, 1) +
        tempArray[0].toLowerCase().substring(1) +
        ' (${tempArray[1].toLowerCase()})';
  }

  getListTiles() => SearchSort.values
      .map((enumValue) => ListTile(
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
          ))
      .toList();

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
          borderRadius: BorderRadius.all(Radius.circular(RADIUS))),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}
