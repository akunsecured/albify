import 'package:cloud_firestore/cloud_firestore.dart';

class PropertyModel {
  String? id;
  String? ownerID;
  PropertyLocation location;
  PropertyType type;
  int rooms, price, floorspace;
  bool newlyBuilt, forSale;
  List photoUrls, favoriteBy;
  String description;

  PropertyModel(
      {this.id,
      this.ownerID,
      required this.location,
      required this.type,
      required this.rooms,
      required this.price,
      required this.floorspace,
      required this.newlyBuilt,
      required this.forSale,
      required this.photoUrls,
      this.favoriteBy = const [],
      required this.description});

  factory PropertyModel.fromDocumentSnapshot(
      DocumentSnapshot documentSnapshot) {
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
        photoUrls: data['photoUrls'] ?? [],
        favoriteBy: data['favoriteBy'] ?? [],
        description: data['description'] ?? '');
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
        'photoUrls': photoUrls,
        'favoriteBy': favoriteBy,
        'description': description
      };
}

class PropertyLocation {
  double lat;
  double lng;
  String? locationName;

  PropertyLocation(this.lat, this.lng, this.locationName);

  factory PropertyLocation.fromMap(Map<String, dynamic> map) =>
      PropertyLocation(
          map['lat'] ?? -1, map['lng'] ?? -1, map['locationName'] ?? '');

  Map<String, dynamic> toMap() =>
      {'lat': lat, 'lng': lng, 'locationName': locationName};
}

enum PropertyType { LODGING, FLAT, HOUSE, PLOT, HOLIDAY_HOUSE, WAREHOUSE }
