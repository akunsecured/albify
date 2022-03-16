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