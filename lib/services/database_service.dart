import 'dart:io';

import 'package:albify/common/utils.dart';
import 'package:albify/models/property_model.dart';
import 'package:albify/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

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

  // Future<bool> addProperty(PropertyModel property, List<XFile> images) async {
  Future<bool> addProperty(PropertyModel property, List<PlatformFile> images) async {
    WriteBatch _batch = _firestore.batch();
    try {
      var ownerID = _firebaseAuth.currentUser!.uid;
      property.ownerID = ownerID;

      var newDocument = propertiesRef.doc();

      var urls = await uploadPropertyImages(newDocument.id, images);
      property.photoUrls = urls;

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

  // Future<String> uploadPropertyImage(String propertyID, XFile image) async {
  Future<String> uploadPropertyImage(String propertyID, PlatformFile image) async {
    String path = DateTime.now().millisecondsSinceEpoch.toString();
    String type = image.name.split('.').last;

    var reference = FirebaseStorage.instance
      .ref()
      .child('$uid/properties/$propertyID/$path.$type');

    var task = reference
      // .putData(await image.readAsBytes());
      .putData(image.bytes!);

    final snapshot = await task.whenComplete(() {});
    return await snapshot.ref.getDownloadURL();
  }

  // Future<List<String>> uploadPropertyImages(String propertyID, List<XFile> images) async {
  Future<List<String>> uploadPropertyImages(String propertyID, List<PlatformFile> images) async {
    return await Future.wait(
      images.map((image) => uploadPropertyImage(propertyID, image))
    );
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

  Future<void> uploadProfilePicture(PlatformFile image) async {
    String type = image.name.split('.').last;

    var reference = FirebaseStorage.instance
      .ref()
      .child('$uid/profile/profilePicture.$type');

    var task = reference
      .putData(image.bytes!);

    final snapshot = await task.whenComplete(() {});
    var url = await snapshot.ref.getDownloadURL();

    WriteBatch _batch = _firestore.batch();
    try {
      _batch.update(
        usersRef.doc(uid),
        {
          "avatarUrl": url
        }
      );

      await _batch.commit();
    } on FirebaseException catch (e) {
      Utils.showToast(e.message.toString());
    }
  }
}