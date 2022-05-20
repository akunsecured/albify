import 'package:albify/models/property_model.dart';
import 'package:albify/widgets/favorite_element.dart';
import 'package:albify/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteList extends StatelessWidget {
  const FavoriteList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<PropertyModel> favoriteProperties =
        Provider.of<List<PropertyModel>>(context);
    if (favoriteProperties.isEmpty) {
      return Center(child: MyText(text: 'There are no favorite properties'));
    }
    return ListView(
      children: favoriteProperties
          .map(
              (favoriteProperty) => FavoriteElement(property: favoriteProperty))
          .toList(),
    );
  }
}
