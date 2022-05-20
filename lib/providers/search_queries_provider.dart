import 'package:albify/models/property_search_models.dart';
import 'package:albify/services/database_service.dart';
import 'package:flutter/foundation.dart';

class SearchQueriesProvider extends ChangeNotifier {
  final DatabaseService databaseService;

  SearchQueriesProvider(this.databaseService);

  Stream<List<SearchQuery>> searchQueries() =>
      databaseService.searchQueriesStream().map((snapshot) => snapshot.docs
          .map((searchQuery) => SearchQuery.fromDocumentSnapshot(searchQuery))
          .toList());
}
