import 'package:albify/animations/custom_page_route_builder.dart';
import 'package:albify/animations/slide_directions.dart';
import 'package:albify/models/property_search_models.dart';
import 'package:albify/providers/search_queries_provider.dart';
import 'package:albify/widgets/login_is_needed.dart';
import 'package:albify/screens/search_result/search_result_page.dart';
import 'package:albify/services/database_service.dart';
import 'package:albify/widgets/my_title_text.dart';
import 'package:albify/widgets/rounded_button.dart';
import 'package:albify/widgets/search_query_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchView extends StatefulWidget {
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late DatabaseService _databaseService;

  @override
  void initState() {
    _databaseService = Provider.of<DatabaseService>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: RoundedButton(
          text: 'Search',
          onPressed: () => Navigator.push(
              context,
              CustomPageRouteBuilder(
                  child: SearchResultPage(),
                  direction: SlideDirections.FROM_DOWN)),
          primary: Colors.amber,
          width: MediaQuery.of(context).size.width / 4,
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16.0),
              child: MyTitleText(
                title: 'Search history',
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: FirebaseAuth.instance.currentUser!.isAnonymous
                    ? LoginIsNeeded()
                    : ChangeNotifierProvider(
                        create: (BuildContext _) =>
                            SearchQueriesProvider(_databaseService),
                        builder: (context, child) {
                          return Container(
                              child: StreamProvider<List<SearchQuery>>.value(
                            value: Provider.of<SearchQueriesProvider>(context,
                                    listen: false)
                                .searchQueries(),
                            initialData: [],
                            child: SearchQueryList(),
                          ));
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
