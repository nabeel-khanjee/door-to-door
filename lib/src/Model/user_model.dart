import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? email;
  String? fullname;
  String? role;
  String? phone;
  String? avatar;
  String? designation;
  bool? approvedByAdmin;
  int? lastLogin;
  LastLocation? lastLocation;

  UserModel(
      {this.role,
      this.uid,
      this.email,
      this.fullname,
      this.phone,
      this.avatar,
      this.approvedByAdmin,
      this.designation,
      this.lastLogin,
      this.lastLocation});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
        uid: map['uid'],
        email: map['email'],
        fullname: map['fullname'],
        role: map['role'],
        phone: map['phone'],
        avatar: map['avatar'],
        approvedByAdmin: map['approvedByAdmin'],
        designation: map['designation'],
        lastLogin:map['lastLogin'],
        lastLocation: map['lastLocation']);
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullname': fullname,
      'role': role,
      'phone': phone,
      'avatar': avatar,
      'approvedByAdmin': approvedByAdmin,
      'designation': designation,
      'lastLogin':lastLogin,
      'lastLocation': lastLocation!.toMap()
    };
  }

  UserModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : uid = doc.id,
        approvedByAdmin = doc.data()!['approvedByAdmin'],
        avatar = doc.data()!["avatar"],
        designation = doc.data()!["designation"],
        email = doc.data()!['email'],
        fullname = doc.data()!['fullname'],
        phone = doc.data()!['phone'],
        role = doc.data()!['role'],
        lastLogin= doc.data()!['lastLogin'],
        lastLocation = LastLocation.fromMap(doc.data()!["lastLocation"]);
}

class LastLocation {
  final double lat;
  final double lng;

  LastLocation({
    required this.lat,
    required this.lng,
  });

  Map<String, dynamic> toMap() {
    return {
      'lat': lat,
      'lng': lng,
    };
  }

  LastLocation.fromMap(Map<String, dynamic> dataMap)
      : lat = dataMap["lat"],
        lng = dataMap["lng"];
}
