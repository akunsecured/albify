const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { Storage } = require("@google-cloud/storage");
const { firestore } = require("firebase-admin");

admin.initializeApp();

const db = admin.firestore();
const usersRef = db.collection("users");
const propertiesRef = db.collection("properties");
const conversationsRef = db.collection("conversations");

const bucketAddress = "albify-55066.appspot.com";

exports.userDelete = functions.auth.user().onDelete(async (user) => {
  return db.collection("users").doc(user.uid).delete();
});

function deletePropertyDocumentPromise(id) {
  return db.collection("properties").doc(id).delete();
}

async function findAndDeleteConversations(userID) {
  try {
    const snapshots = await conversationsRef
      .where("participants", "array-contains", userID)
      .get();
    snapshots.docs.forEach((doc) => {
      conversationsRef.doc(doc.id).delete();
    });
  } catch (err) {
    console.log(err);
  }
}

exports.userDocumentDelete = functions.firestore
  .document("users/{userId}")
  .onDelete(async (snapshot, context) => {
    const userData = snapshot.data();

    if (userData.propertyIDs) {
      const propertyDeletePromises = [];
      userData.propertyIDs.forEach((propertyId) => {
        propertyDeletePromises.push(deletePropertyDocumentPromise(propertyId));
      });
    }

    const storage = new Storage();
    const bucket = storage.bucket(bucketAddress);

    try {
      await bucket.deleteFiles({
        prefix: snapshot.id,
      });
      if (userData.propertyIDs) {
        await Promise.all(propertyDeletePromises);
      }
      return await findAndDeleteConversations(snapshot.id);
    } catch (err) {
      console.log(
        "Failed to delete the user with id: " +
          snapshot.id +
          "\nThe error was the following: " +
          err
      );
    }
  });

exports.propertyDocumentDelete = functions.firestore
  .document("properties/{propertyId}")
  .onDelete(async (snapshot, context) => {
    const propertyId = snapshot.id;
    const ownerID = snapshot.data().ownerID;

    const storage = new Storage();
    const bucket = storage.bucket(bucketAddress);

    try {
      return await bucket.deleteFiles({
        prefix: `${ownerID}/properties/${propertyId}`,
      });
    } catch (err) {
      console.log(
        "Failed to delete the property with id: " +
          propertyId +
          "\nThe error was the following: " +
          err
      );
    }
  });
