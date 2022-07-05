import 'package:page/src/Globals/global.dart';
import 'package:page/src/Model/campaign_model.dart';
import 'package:page/src/Model/user_model.dart';

class ApiForApp {
  setGlobalCampaignList(List<Campaigns>? retrievedCampaignsList) {
    CampaignList_list.clear();
    for (var i = 0; i < retrievedCampaignsList!.length; i++) {
      final Map<String, dynamic> data = retrievedCampaignsList[i].toMap();
      CampaignList_list.add({
        'details': data["details"],
        'name': data["name"],
        'status': data['status'],
        'date_range': data["date_range"]
      });
    }
  }

  setGlobalUserList(List<UserModel>? retrievedUsersList) {
    print(retrievedUsersList);
    UserList_list.clear();
    for (var i = 0; i < retrievedUsersList!.length; i++) {
      final Map<String, dynamic> data = retrievedUsersList[i].toMap();
      print(data);
      UserList_list.add({
        'avatar':data['avatar'],
        'uid':data['uid'],
        'approvedByAdmin': data["approvedByAdmin"],
        'designation': data["designation"],
        'email': data['email'],
        'fullname': data["fullname"],
        'lastLocation': data["lastLocation"],
        'lastLogin': data["lastLogin"],
        'phone': data["phone"],
        'role': data["role"],
      });
    }
  }
}
