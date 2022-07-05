import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:page/src/Model/campaign_model.dart';
import 'package:page/src/Model/user_model.dart';

final FirebaseFirestore _db = FirebaseFirestore.instance;

class UsersService {
  addUserModel(UserModel campaignData) async {
    await _db.collection("users").add(campaignData.toMap());
  }

  updateUserModel(UserModel campaignData) async {
    await _db
        .collection("users")
        .doc(campaignData.uid)
        .update(campaignData.toMap());
  }

  Future<void> deleteUserModel(String documentId) async {
    await _db.collection("users").doc(documentId).delete();
  }

  Future<List<UserModel>> retrieveUserModel() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("users").get();
    return snapshot.docs
        .map((docSnapshot) => UserModel.fromDocumentSnapshot(docSnapshot))
        .toList();
  }
}
