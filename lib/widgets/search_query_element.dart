import 'package:albify/animations/custom_page_route_builder.dart';
import 'package:albify/animations/slide_directions.dart';
import 'package:albify/common/utils.dart';
import 'package:albify/models/property_search_models.dart';
import 'package:albify/screens/search_result/search_result_page.dart';
import 'package:albify/services/database_service.dart';
import 'package:albify/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchQueryElement extends StatelessWidget {
  final SearchQuery searchQuery;

  const SearchQueryElement({Key? key, required this.searchQuery})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.history, color: Colors.white),
      title: MyText(text: buildTopText(), fontWeight: FontWeight.bold),
      subtitle: MyText(text: buildBottomText()),
      trailing: PopupMenuButton(
        icon: Icon(Icons.more_vert, color: Colors.white),
        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
          PopupMenuItem(
            child: Text('Delete search'),
            onTap: () {
              Provider.of<DatabaseService>(context, listen: false)
                  .removeSearchQuery(searchQuery.id!);
            },
          )
        ],
      ),
      onTap: () {
        Navigator.push(
            context,
            CustomPageRouteBuilder(
                child: SearchResultPage(searchQuery: searchQuery),
                direction: SlideDirections.FROM_DOWN));
      },
    );
  }

  String buildTopText() => searchQuery.propertyType == null
      ? 'Any'
      : Utils.enumToString(searchQuery.propertyType!) +
          ' for ' +
          (searchQuery.forSale == null
              ? 'sale, rent'
              : searchQuery.forSale!
                  ? 'sale'
                  : 'rent');

  String buildBottomText() =>
      (searchQuery.roomNum != null ? 'Rooms: ${searchQuery.roomNum}+ ' : '') +
      betweenToString(searchQuery.priceBetween) +
      betweenToString(searchQuery.floorspaceBetween) +
      (searchQuery.newlyBuilt != null ? 'Newly built ' : '');

  String betweenToString(between) {
    if (!(between is Between)) {
      return '';
    }
    String suffix;
    if (between is PriceBetween) {
      suffix = 'Ft';
    } else {
      suffix = 'm\u00B9';
    }
    if (between.from != null && between.to != null) {
      return '${between.from}-${between.to} $suffix ';
    }
    if (between.from != null) {
      return 'from: ${between.from} $suffix ';
    }
    if (between.to != null) {
      return 'to: ${between.to} $suffix ';
    }
    return '';
  }
}
