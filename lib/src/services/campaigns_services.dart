import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:page/src/Model/campaign_model.dart';

final FirebaseFirestore _db = FirebaseFirestore.instance;

class CampaignsService {
  addCampaigns(Campaigns campaignData) async {
    await _db.collection("campaigns").add(campaignData.toMap());
  }

  updateCampaigns(Campaigns campaignData) async {
    await _db
        .collection("campaigns")
        .doc(campaignData.id)
        .update(campaignData.toMap());
  }

  Future<void> deleteCampaigns(String documentId) async {
    await _db.collection("campaigns").doc(documentId).delete();
  }

  Future<List<Campaigns>> retrieveCampaigns() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("campaigns").get();
    return snapshot.docs
        .map((docSnapshot) => Campaigns.fromDocumentSnapshot(docSnapshot))
        .toList();
  }
}
