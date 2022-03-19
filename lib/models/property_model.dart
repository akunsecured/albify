import 'package:cloud_firestore/cloud_firestore.dart';

class PropertyModel {
  String? id;
  String? ownerID;
  PropertyLocation location;
  PropertyType type;
  int rooms, price, floorspace;
  bool newlyBuilt, forSale;
  List photoUrls;

  PropertyModel({
    this.id,
    this.ownerID,
    required this.location,
    required this.type,
    required this.rooms,
    required this.price,
    required this.floorspace,
    required this.newlyBuilt,
    required this.forSale,
    required this.photoUrls
  });

  factory PropertyModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    return PropertyModel(
      id: documentSnapshot.id,
      ownerID: data['ownerID'] ?? '',
      location: PropertyLocation.fromMap(data['location']),
      type: PropertyType.values[data['type'] ?? 0],
      rooms: data['rooms'] ?? -1,
      price: data['price'] ?? -1,
      floorspace: data['floorspace'] ?? -1,
      newlyBuilt: data['newlyBuilt'] ?? false,
      forSale: data['forSale'] ?? false,
      photoUrls: data['photoUrls'] ?? []
    );
  }

  Map<String, dynamic> toMap() => {
    'ownerID': ownerID,
    'location': location.toMap(),
    'type': type.index,
    'rooms': rooms,
    'price': price,
    'floorspace': floorspace,
    'newlyBuilt': newlyBuilt,
    'forSale': forSale,
    'photoUrls': photoUrls
  };
}

class PropertyLocation {
  double lat;
  double lng;

  PropertyLocation(
    this.lat,
    this.lng
  );

  factory PropertyLocation.fromMap(Map<String, dynamic> map) =>
    PropertyLocation(
      map['lat'] ?? -1,
      map['lng'] ?? -1
    );
  
  Map<String, dynamic> toMap() => {
    'lat': lat,
    'lng': lng
  };
}

enum PropertyType {
  LODGING, FLAT, HOUSE, PLOT, HOLIDAY_HOUSE, WAREHOUSE
}