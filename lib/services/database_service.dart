import 'package:albify/common/utils.dart';
import 'package:albify/models/message_model.dart';
import 'package:albify/models/property_model.dart';
import 'package:albify/models/property_search_models.dart';
import 'package:albify/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  late final String? uid;
  late final CollectionReference usersRef;
  late final CollectionReference propertiesRef;
  late final CollectionReference conversationsRef;

  CollectionReference getConversationMessagesRef(String conversationID) =>
      conversationsRef.doc(conversationID).collection("messages");

  DatabaseService({this.uid}) {
    if (uid == null) {
      uid = _firebaseAuth.currentUser!.uid;
    }

    usersRef = _firestore.collection('users');
    propertiesRef = _firestore.collection('properties');
    conversationsRef = _firestore.collection('conversations');
  }

  Future<UserModel?> getUserData({String? userID}) async {
    if (userID == null) userID = uid;
    try {
      DocumentSnapshot documentSnapshot = await usersRef.doc(userID).get();

      return UserModel.fromDocumentSnapshot(documentSnapshot);
    } on FirebaseException catch (e) {
      print(e.message);
      return null;
    }
  }

  Future<List<PropertyModel>> getProperties(List<String> propertyIDs) async {
    List<PropertyModel> properties = [];
    try {
      if (propertyIDs.isEmpty) return [];

      var querySnapshot = await propertiesRef
          .where(FieldPath.documentId, whereIn: propertyIDs)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        properties = querySnapshot.docs
            .map((doc) => PropertyModel.fromDocumentSnapshot(doc))
            .toList();
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
      var querySnapshot = await propertiesRef.get();

      if (querySnapshot.docs.isNotEmpty) {
        properties = querySnapshot.docs
            .map((doc) => PropertyModel.fromDocumentSnapshot(doc))
            .toList();
      }
    } on FirebaseException catch (e) {
      print(e.message);
      return [];
    }
    return properties;
  }

  Future<List<PropertyModel>> findProperties({SearchQuery? searchQuery}) async {
    List<PropertyModel> properties = [];
    try {
      var querySnapshot = await propertiesRef.get();

      if (querySnapshot.docs.isNotEmpty) {
        properties = querySnapshot.docs
            .map((doc) => PropertyModel.fromDocumentSnapshot(doc))
            .toList();
        if (searchQuery != null) {
          if (searchQuery.priceBetween != null) {
            properties.removeWhere(
                (property) =>
                    property.price < searchQuery.priceBetween!.from ||
                    property.price > searchQuery.priceBetween!.to
            );
          }
          if (searchQuery.roomsBetween != null) {
            properties.removeWhere(
                (property) =>
                    property.rooms < searchQuery.roomsBetween!.from ||
                    property.rooms > searchQuery.roomsBetween!.to
            );
          }
          if (searchQuery.floorspaceBetween != null) {
            properties.removeWhere(
                (property) =>
                    property.floorspace < searchQuery.floorspaceBetween!.from ||
                    property.floorspace > searchQuery.floorspaceBetween!.to
            );
          }
          if (searchQuery.propertyType != null) {
            properties.removeWhere(
                (property) => property.type != searchQuery.propertyType
            );
          }
          if (searchQuery.newlyBuilt != null) {
            properties.removeWhere(
                (property) => property.newlyBuilt != searchQuery.newlyBuilt
            );
          }
          if (searchQuery.forSale != null) {
            properties.removeWhere(
                (property) => property.forSale != searchQuery.forSale
            );
          }
        }
      }
    } on FirebaseException catch (e) {
      print(e.message);
      return [];
    }
    return properties;
  }

  Future<bool> addProperty(
      PropertyModel property, List<PlatformFile> images) async {
    WriteBatch _batch = _firestore.batch();
    try {
      var ownerID = _firebaseAuth.currentUser!.uid;
      property.ownerID = ownerID;

      var newDocument = propertiesRef.doc();

      var urls = await uploadPropertyImages(newDocument.id, images);
      property.photoUrls = urls;

      _batch.set(propertiesRef.doc(newDocument.id), property.toMap());

      _batch.update(usersRef.doc(ownerID), {
        "propertyIDs": FieldValue.arrayUnion([newDocument.id])
      });

      await _batch.commit();
    } on FirebaseException catch (e) {
      print(e.message);
      return false;
    }
    return true;
  }

  Future<String> uploadPropertyImage(
      String propertyID, PlatformFile image) async {
    String path = DateTime.now().millisecondsSinceEpoch.toString();
    String type = image.name.split('.').last;

    var reference = FirebaseStorage.instance
        .ref()
        .child('$uid/properties/$propertyID/$path.$type');

    var task = reference.putData(image.bytes!);

    final snapshot = await task.whenComplete(() {});
    return await snapshot.ref.getDownloadURL();
  }

  Future<List<String>> uploadPropertyImages(
      String propertyID, List<PlatformFile> images) async {
    return await Future.wait(
        images.map((image) => uploadPropertyImage(propertyID, image)));
  }

  Stream<UserModel?> userStream({String? userID}) {
    if (userID == null) userID = uid;
    if (userID != uid)
      return _firestore
          .collection("users")
          .doc(userID)
          .snapshots()
          .map((snapshot) => UserModel.fromDocumentSnapshot(snapshot));
    if (!_firebaseAuth.currentUser!.isAnonymous)
      return _firestore
          .collection("users")
          .doc(uid)
          .snapshots()
          .map((snapshot) => UserModel.fromDocumentSnapshot(snapshot));
    return Stream.empty();
  }

  Stream<QuerySnapshot> propertiesStream() =>
      _firestore.collection("properties").snapshots();

  Stream<QuerySnapshot> propertiesByIdStream(List<String> propertyIDs) =>
      _firestore
          .collection("properties")
          .where(FieldPath.documentId, whereIn: propertyIDs)
          .snapshots();

  Future<void> uploadProfilePicture(PlatformFile image) async {
    String type = image.name.split('.').last;

    var reference = FirebaseStorage.instance
        .ref()
        .child('$uid/profile/profilePicture.$type');

    var task = reference.putData(image.bytes!);

    final snapshot = await task.whenComplete(() {});
    var url = await snapshot.ref.getDownloadURL();

    WriteBatch _batch = _firestore.batch();
    try {
      _batch.update(usersRef.doc(uid), {"avatarUrl": url});

      await _batch.commit();
    } on FirebaseException catch (e) {
      Utils.showToast(e.message.toString());
    }
  }

  Future<bool> editProfile(UserModel userModel) async {
    WriteBatch _batch = _firestore.batch();
    try {
      _batch.update(usersRef.doc(userModel.id), userModel.toMap());

      await _batch.commit();
    } on FirebaseException catch (e) {
      print(e.message);
      return false;
    }
    return true;
  }

  Future<String> findOrCreateConversation(String otherUserID) async {
    print(uid);
    print(otherUserID);
    QuerySnapshot snapshot = await conversationsRef
        .where('participants', arrayContains: uid!)
        .get();
    print(snapshot.docs.length);
    if (snapshot.docs.isNotEmpty) {
      var conversation = snapshot.docs.map((doc) => ConversationModel.fromDocumentSnapshot(doc)).toList()..removeWhere((element) => !element.participants.contains(otherUserID))..first;

      return conversation.isNotEmpty ? conversation.first.id! : await _createConversation(otherUserID);
    } else {
      return await _createConversation(otherUserID);
    }
  }

  Future<String> _createConversation(String otherUserID) async {
    var newDocument = conversationsRef.doc();
    var conversationModel = ConversationModel(
        participants: [
          uid!, otherUserID
        ]
    );

    await conversationsRef.doc(newDocument.id).set(
        conversationModel.toMap()
    );
    return newDocument.id;
  }

  Stream<QuerySnapshot> conversationsStream() => conversationsRef
        .where('participants', arrayContains: uid)
        .orderBy('lastMessage.timeStamp', descending: true)
        .snapshots();


  Stream<QuerySnapshot> messagesStream(String conversationID) =>
      conversationsRef
          .doc(conversationID)
          .collection('messages')
          .orderBy('timeStamp', descending: true)
          .snapshots();

  Future<void> sendMessage({ required String conversationID, required String message }) async {
    WriteBatch _batch = _firestore.batch();
    try {
      var newDocument = getConversationMessagesRef(conversationID).doc();
      var newMessage = {
        'sentBy': uid!,
        'message': message,
        'sentFromClient': DateTime.now().millisecondsSinceEpoch,
        'timeStamp': FieldValue.serverTimestamp()
      };

      _batch.set(
          getConversationMessagesRef(conversationID).doc(newDocument.id),
          newMessage
      );

      _batch.update(conversationsRef.doc(conversationID), {
        "lastMessage": newMessage
      });

      await _batch.commit();
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }

  Future<String?> getOtherUserName(String conversationId) async {
    var conversation = ConversationModel.fromDocumentSnapshot(
        await conversationsRef.doc(conversationId).get());
    String? otherUserID;
    for (String userID in conversation.participants) {
      if (userID != uid) {
        otherUserID = userID;
        break;
      }
    }
    var otherUser = UserModel.fromDocumentSnapshot(
      await usersRef.doc(otherUserID).get());
    return otherUser.name;
  }
}
