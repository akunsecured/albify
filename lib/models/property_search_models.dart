import 'package:albify/models/property_model.dart';

class SearchQuery {
  PropertyType? propertyType;
  RoomsBetween? roomsBetween;
  PriceBetween? priceBetween;
  FloorspaceBetween? floorspaceBetween;
  bool? newlyBuilt;
  bool? forSale;

  SearchQuery({
    this.propertyType,
    this.roomsBetween,
    this.priceBetween,
    this.floorspaceBetween,
    this.newlyBuilt,
    this.forSale,
  });
}

class RoomsBetween {
  int from;
  int to;

  RoomsBetween({
    required this.from,
    required this.to
  });
}

class PriceBetween {
  int from;
  int to;

  PriceBetween({
    required this.from,
    required this.to
  });
}

class FloorspaceBetween {
  double from;
  double to;

  FloorspaceBetween({
    required this.from,
    required this.to
  });
}

enum SearchSort {
  PRICE_ASCENDING,
  PRICE_DESCENDING,
  SPACEFLOOR_ASCENDING,
  SPACEFLOOR_DESCENDING,
  ROOMS_ASCENDING,
  ROOMS_DESCENDING
}