import 'package:albify/models/property_model.dart';
import 'package:albify/models/property_search_models.dart';
import 'package:flutter/foundation.dart';

class SearchResultFilterProvider extends ChangeNotifier {
  late SearchQuery _searchQuery;

  SearchResultFilterProvider({SearchQuery? searchQuery}) {
    if (searchQuery != null) {
      _searchQuery = searchQuery;
    } else {
      _searchQuery = SearchQuery();
    }
  }

  SearchQuery get searchQuery => _searchQuery;

  void changePropertyType(int idx) {
    if (idx == -1) {
      _searchQuery.propertyType = null;
    } else {
      _searchQuery.propertyType = PropertyType.values[idx];
    }
    notifyListeners();
  }

  void changePriceBetween(Map<String, int?> fromToMap) {
    _searchQuery.priceBetween =
        PriceBetween(from: fromToMap['from'], to: fromToMap['to']);
    notifyListeners();
  }

  void changeFloorspaceBetween(Map<String, int?> fromToMap) {
    _searchQuery.floorspaceBetween = FloorspaceBetween(
        from: fromToMap['from']?.toDouble(), to: fromToMap['to']?.toDouble());
    notifyListeners();
  }

  void changeNewlyBuilt(int idx) {
    if (idx == -1) {
      _searchQuery.newlyBuilt = null;
    } else {
      _searchQuery.newlyBuilt = idx == 1;
    }
    notifyListeners();
  }

  void changeForSale(int idx) {
    if (idx == -1) {
      _searchQuery.forSale = null;
    } else {
      _searchQuery.forSale = idx == 1;
    }
    notifyListeners();
  }

  void changeRoomNum(int? num) {
    _searchQuery.roomNum = num;
    notifyListeners();
  }
}
