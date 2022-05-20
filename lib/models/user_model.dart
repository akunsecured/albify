import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id, name;
  String? avatarUrl, contactEmail;
  int? phoneNumber;
  List? propertyIDs, lastSearchIDs;

  UserModel(
      {required this.id,
      required this.name,
      this.avatarUrl,
      this.contactEmail,
      this.phoneNumber,
      this.propertyIDs,
      this.lastSearchIDs});

  factory UserModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    return UserModel(
        id: documentSnapshot.id,
        name: data['name'] ?? '',
        avatarUrl: data['avatarUrl'] ?? '',
        contactEmail: data['contactEmail'] ?? '',
        phoneNumber: data['phoneNumber'] ?? -1,
        propertyIDs: data['propertyIDs'] ?? [],
        lastSearchIDs: data['lastSearchIDs'] ?? []);
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'avatarUrl': avatarUrl,
        'contactEmail': contactEmail,
        'phoneNumber': phoneNumber,
        'propertyIDs': propertyIDs,
        'lastSearchIDs': lastSearchIDs
      };
}
