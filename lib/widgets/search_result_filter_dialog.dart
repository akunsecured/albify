import 'package:albify/common/constants.dart';
import 'package:albify/common/utils.dart';
import 'package:albify/models/property_model.dart';
import 'package:albify/models/property_search_models.dart';
import 'package:albify/providers/search_result_filter_provider.dart';
import 'package:albify/services/database_service.dart';
import 'package:albify/widgets/min_max_dialog.dart';
import 'package:albify/widgets/my_dropdown_menu.dart';
import 'package:albify/widgets/my_title_text.dart';
import 'package:albify/widgets/my_toggle_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'rounded_button.dart';

class SearchResultFilterDialog extends StatefulWidget {
  final SearchQuery? searchQuery;

  const SearchResultFilterDialog({Key? key, this.searchQuery})
      : super(key: key);

  @override
  State<SearchResultFilterDialog> createState() =>
      _SearchResultFilterDialogState();
}

class _SearchResultFilterDialogState extends State<SearchResultFilterDialog> {
  late SearchResultFilterProvider provider;

  @override
  void initState() {
    provider = Provider.of<SearchResultFilterProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MyToggleButtons roomButtons = MyToggleButtons(
        title: 'Rooms',
        optionNum: 5,
        options: {'1+': 1, '2+': 2, '3+': 3, '4+': 4, '5+': 5},
        selected: provider.searchQuery.roomNum,
        onPressed: (value) {
          provider.changeRoomNum(value);
        });

    ListTile priceTile = ListTile(
      title: MyTitleText(title: 'Price', withContainer: false),
      onTap: () async {
        var result = await showDialog(
            context: context,
            builder: (context) => MinMaxDialog(
                  suffix: 'k Ft',
                  title: 'Price',
                  multiple: 1e3.toInt(),
                  regExp: Utils.priceSearchRegExp,
                  values: provider.searchQuery.priceBetween,
                ));
        if (result != null) {
          provider.changePriceBetween(result);
        }
      },
    );

    ListTile floorSpaceTile = ListTile(
      title: MyTitleText(title: 'Floorspace', withContainer: false),
      onTap: () async {
        var result = await showDialog(
            context: context,
            builder: (context) => MinMaxDialog(
                  suffix: 'm\u00B2',
                  title: 'Floorspace',
                  regExp: Utils.floorspaceRegExp,
                  values: provider.searchQuery.floorspaceBetween,
                ));
        if (result != null) {
          provider.changeFloorspaceBetween(result);
        }
      },
    );

    MyDropdownMenu propertyTypeMenu = MyDropdownMenu(
      title: 'Preferred property type',
      options: <int, String>{-1: 'Any'}..addAll(Map.fromIterable(
          PropertyType.values,
          key: (propertyType) => propertyType.index,
          value: (propertyType) => Utils.enumToString(propertyType))),
      onChanged: (value) {
        if (value != null) {
          provider.changePropertyType(value);
        }
      },
      selected: (provider.searchQuery.propertyType == null
          ? null
          : provider.searchQuery.propertyType!.index),
    );

    MyDropdownMenu newlyBuiltMenu = MyDropdownMenu(
      title: 'Should it be old or newly built?',
      options: {-1: 'Any', 0: 'Old', 1: 'Newly built'},
      onChanged: (value) {
        if (value != null) {
          provider.changeNewlyBuilt(value);
        }
      },
      selected: (provider.searchQuery.newlyBuilt == null
          ? null
          : provider.searchQuery.newlyBuilt!
              ? 1
              : 0),
    );

    MyDropdownMenu forSaleMenu = MyDropdownMenu(
      title: 'Should it be for sale or for rent?',
      options: {-1: 'Any', 0: 'For rent', 1: 'For sale'},
      onChanged: (value) {
        if (value != null) {
          provider.changeForSale(value);
        }
      },
      selected: (provider.searchQuery.forSale == null
          ? null
          : provider.searchQuery.forSale!
              ? 1
              : 0),
    );

    RoundedButton button = RoundedButton(
      text: 'Filter',
      onPressed: () {
        var newSearchQuery = provider.searchQuery;
        if (!FirebaseAuth.instance.currentUser!.isAnonymous) {
          Provider.of<DatabaseService>(context, listen: false)
              .addSearchQuery(newSearchQuery);
        }
        Navigator.pop(context, newSearchQuery);
      },
    );

    return Dialog(
        backgroundColor: Colors.grey[200],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(RADIUS))),
        child: SingleChildScrollView(
          child: Container(
            width: getPreferredSize(MediaQuery.of(context).size),
            child: Column(
              children: [
                roomButtons,
                priceTile,
                floorSpaceTile,
                propertyTypeMenu,
                newlyBuiltMenu,
                forSaleMenu,
                Container(margin: EdgeInsets.all(16), child: button)
              ],
            ),
          ),
        ));
  }
}
