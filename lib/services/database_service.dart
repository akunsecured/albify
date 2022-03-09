import 'package:albify/models/property_model.dart';
import 'package:albify/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  
  late final String? uid;
  late final CollectionReference usersRef;
  late final CollectionReference propertiesRef;

  DatabaseService({ this.uid }) {
    if (uid == null) {
      uid = _firebaseAuth.currentUser!.uid;
    }
    
    usersRef = _firestore.collection('users');
    propertiesRef = _firestore.collection('properties');
  }

  Future<UserModel?> getUserData({ String? userID }) async {
    if (userID == null) userID = uid;
    try {
      DocumentSnapshot documentSnapshot =
        await usersRef.doc(userID).get();

      return UserModel.fromDocumentSnapshot(documentSnapshot);
    } on FirebaseException catch (e) {
      print(e.message);
      return null;
    }
  }

  Future<List<PropertyModel>> getProperties(List<String> propertyIDs) async {
    List<PropertyModel> properties = [];
    try {
      if (propertyIDs.isEmpty)
        return [];
      
      var querySnapshot = 
        await propertiesRef
                .where(FieldPath.documentId, whereIn: propertyIDs)
                .get();

      if (querySnapshot.docs.isNotEmpty) {
        properties = querySnapshot.docs.map(
          (doc) => PropertyModel.fromDocumentSnapshot(doc)
          ).toList();
      }
    } on FirebaseException catch (e) {
      print(e.message);
      return [];
    }

    return properties;
  }

  Future<List<PropertyModel>> getAllProperties() async {
    List<PropertyModel> properties = [];
    try {
      var querySnapshot = 
        await propertiesRef.get();

      if (querySnapshot.docs.isNotEmpty) {
        properties = querySnapshot.docs.map(
          (doc) => PropertyModel.fromDocumentSnapshot(doc)
          ).toList();
      }
    } on FirebaseException catch (e) {
      print(e.message);
      return [];
    }
    return properties;
  }

  Future<bool> addProperty(PropertyModel property) async {
    WriteBatch _batch = _firestore.batch();
    try {
      var ownerID = _firebaseAuth.currentUser!.uid;
      property.ownerID = ownerID;

      var newDocument = propertiesRef.doc();

      _batch.set(
        propertiesRef.doc(newDocument.id),
        property.toMap()
      );

      _batch.update(
        usersRef.doc(ownerID),
        {
          "properties": FieldValue.arrayUnion([
            newDocument.id
          ])
        }
      );

      await _batch.commit();
    } on FirebaseException catch (e) {
      print(e.message);
      return false;
    }
    return true;
  }

  Stream<UserModel?> userStream() {
    if (!_firebaseAuth.currentUser!.isAnonymous)
      return _firestore
        .collection("users")
        .doc(uid)
        .snapshots()
        .map((snapshot) => UserModel.fromDocumentSnapshot(snapshot));
    return Stream.empty();
  }


  Stream<QuerySnapshot> propertiesStream() =>
    _firestore
      .collection("properties")
      .snapshots();

  Stream<QuerySnapshot> propertiesByIdStream(List<String> propertyIDs) =>
    _firestore
      .collection("properties")
      .where(FieldPath.documentId, whereIn: propertyIDs)
      .snapshots();

  List<PropertyModel> _propertiesFromSnapshot(QuerySnapshot snapshot) =>
    snapshot
      .docs
      .map(
        (doc) => PropertyModel.fromDocumentSnapshot(doc)
      )
      .toList();
}