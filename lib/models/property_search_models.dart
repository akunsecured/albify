import 'package:albify/models/property_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Between {
  num? from, to;

  Between({this.from, this.to});

  factory Between.fromMap(Map<String, dynamic> map) =>
      Between(from: map['from'], to: map['to']);

  Map<String, dynamic> toMap() => {'from': from, 'to': to};
}

class PriceBetween extends Between {
  PriceBetween({num? from, num? to}) : super(from: from, to: to);

  factory PriceBetween.fromMap(Map<String, dynamic> map) =>
      PriceBetween(from: map['from'], to: map['to']);
}

class FloorspaceBetween extends Between {
  FloorspaceBetween({num? from, num? to}) : super(from: from, to: to);

  factory FloorspaceBetween.fromMap(Map<String, dynamic> map) =>
      FloorspaceBetween(from: map['from'], to: map['to']);
}

class SearchQuery {
  String? id;
  PropertyType? propertyType;
  int? roomNum;
  late PriceBetween priceBetween;
  late FloorspaceBetween floorspaceBetween;
  bool? newlyBuilt;
  bool? forSale;

  SearchQuery({
    this.id,
    this.propertyType,
    this.roomNum,
    PriceBetween? priceBetween,
    FloorspaceBetween? floorspaceBetween,
    this.newlyBuilt,
    this.forSale,
  }) {
    if (priceBetween == null) {
      this.priceBetween = PriceBetween();
    } else {
      this.priceBetween = priceBetween;
    }

    if (floorspaceBetween == null) {
      this.floorspaceBetween = FloorspaceBetween();
    } else {
      this.floorspaceBetween = floorspaceBetween;
    }
  }

  factory SearchQuery.fromMap(Map<String, dynamic> map,
          {String? id}) =>
      SearchQuery(
          id: id,
          propertyType: map['propertyType'] == null
              ? null
              : PropertyType.values[map['propertyType']],
          roomNum: map['roomNum'],
          priceBetween: PriceBetween.fromMap(map['priceBetween']),
          floorspaceBetween:
              FloorspaceBetween.fromMap(map['floorspaceBetween']),
          newlyBuilt: map['newlyBuilt'],
          forSale: map['forSale']);

  factory SearchQuery.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) =>
      SearchQuery.fromMap(documentSnapshot.data() as Map<String, dynamic>,
          id: documentSnapshot.id);

  Map<String, dynamic> toMap() => {
        'propertyType': propertyType?.index,
        'roomNum': roomNum,
        'priceBetween': priceBetween.toMap(),
        'floorspaceBetween': floorspaceBetween.toMap(),
        'newlyBuilt': newlyBuilt,
        'forSale': forSale
      };
}

enum SearchSort {
  PRICE_ASCENDING,
  PRICE_DESCENDING,
  SPACEFLOOR_ASCENDING,
  SPACEFLOOR_DESCENDING,
  ROOMS_ASCENDING,
  ROOMS_DESCENDING
}
