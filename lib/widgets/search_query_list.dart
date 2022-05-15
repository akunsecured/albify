import 'package:albify/models/property_search_models.dart';
import 'package:albify/widgets/my_text.dart';
import 'package:albify/widgets/search_query_element.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchQueryList extends StatelessWidget {
  const SearchQueryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<SearchQuery> searchQueries = Provider.of<List<SearchQuery>>(context);
    return searchQueries.isEmpty
        ? Align(
            alignment: Alignment.center,
            child: MyText(
              text: 'There are no search history',
            ),
          )
        : ListView(
            children: searchQueries
                .map((searchQuery) => SearchQueryElement(
                    searchQuery: searchQuery, key: ValueKey(searchQuery.id)))
                .toList(),
          );
  }
}
