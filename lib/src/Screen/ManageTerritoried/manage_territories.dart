// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:convert';
import 'package:intl/src/intl/date_format.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:page/src/Api/api.dart';
import 'package:page/src/Globals/global.dart';
import 'package:page/src/Model/campaign_model.dart';
import 'package:page/src/Model/user_model.dart';
import 'package:page/src/Screen/GoogleMap/app_google_map.dart';
import 'package:page/src/component/search_bar_component.dart';
import 'package:page/src/component/text_component.dart';
import 'package:page/src/component/bottom_button_component.dart';
import 'package:page/src/constants/colors.dart';
import 'package:page/src/constants/string_constants.dart';
import 'package:page/src/firebase/firebase_functions.dart';
import 'package:page/src/functions/manage_territory_funtions.dart';
import 'package:page/src/services/campaigns_services.dart';
import 'package:page/src/services/user_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManageTerritories extends StatefulWidget {
  @override
  State<ManageTerritories> createState() => _ManageTerritoriesState();
}

class _ManageTerritoriesState extends State<ManageTerritories> {
  bool value = false;
  CampaignsService campaignService = CampaignsService();
  Future<List<Campaigns>>? campaignsList;
  List<Campaigns>? retrievedCampaignsList;
  UsersService userService = UsersService();
  Future<List<UserModel>>? userList;
  List<UserModel>? retrievedUserList;
  List dataListOfUserFroServer = [];
  List<Object?> selectedUsers = [];
  List<Object?>? selectedTerritorries = [];

  ApiForApp apiForApp = ApiForApp();

  IconData changeIcon = Icons.arrow_drop_down;

  // Map<String, dynamic>? dataSend;
  String? uid;

  TextEditingController territortname = TextEditingController();

  Map<String, dynamic>? dataUpdate;

  @override
  void initState() {
    super.initState();
    _initRetrieval();
  }

  Future<void> _initRetrieval() async {
    campaignsList = campaignService.retrieveCampaigns();
    retrievedCampaignsList = await campaignService.retrieveCampaigns();
    apiForApp.setGlobalCampaignList(retrievedCampaignsList);
    userList = userService.retrieveUserModel();
    retrievedUserList = await userService.retrieveUserModel();
    apiForApp.setGlobalUserList(retrievedUserList);
  }

  TextEditingController seratchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomButtonComponent(
// icon: Icons.abc,
        onTap: () {},
        textColor: ColorConstants().white,
        buttonText: StringConstants().delete,
        buttonColor: ColorConstants().red,
      ),
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "Manage Territories",
          style: TextStyle(
              color: Colors.black,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SearchBar(
              onTap: () {
                setState(() {
                  seratchController = seratchController;
                });
              },
              controller: seratchController,
            ),
            Divider(
              thickness: 1,
            ),
            Column(
              children: [
                SizedBox(
                  height: 31.h,
                ),
                Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 42.w,
                          ),
                          Text(
                            "Name",
                            style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: 120.w,
                          ),
                          Text(
                            "Assignees",
                            style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 31.h,
                      ),
                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: seratchController.value.text.isNotEmpty
                            ? FirebaseFirestore.instance
                                .collection('territories')
                                .where('territoryname',
                                    isGreaterThanOrEqualTo:
                                        seratchController.value.text)
                                .where('territoryname',
                                    isLessThan:
                                        seratchController.value.text + 'z')
                                .snapshots()
                            : FirebaseFirestore.instance
                                .collection('territories')
                                .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError)
                            return Text('Error = ${snapshot.error}');
                          if (snapshot.hasData) {
                            final docs = snapshot.data!.docs;
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: docs.length,
                              itemBuilder: (BuildContext context, index) {
                                final Map<String, dynamic> data =
                                    docs[index].data() as Map<String, dynamic>;

                                return Padding(
                                  padding:
                                      EdgeInsets.only(left: 26.w, right: 34.w),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: value,
                                            onChanged: (value) {
                                              setState(
                                                () {
                                                  this.value = value!;
                                                },
                                              );
                                            },
                                          ),
                                          Column(
                                            children: [
                                              TextCompnentAlertBox(
                                                textMaxSize: 100,
                                                text: data['territoryname'] ??
                                                    "Name",
                                              ),
                                              TextCompnentAlertBox(
                                                textMaxSize: 100,
                                                text: data['created'] ??
                                                    "30/04/2022",
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 50,
                                        child: GridView.builder(
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 3),
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount:
                                              data['assignees'].length > 3
                                                  ? 3
                                                  : data['assignees']
                                                      .length,
                                          itemBuilder: (context, index) {
                                            for (var i = 0;
                                                i < UserList_list.length;
                                                i++) {
                                              if (UserList_list[i]['uid'] ==
                                                  data['assignees'][index]
                                                      ['uid']) {
                                                return Container(
                                                  height: 33.h,
                                                  width: 33.w,
                                                  child: CircleAvatar(
                                                      minRadius: 10,
                                                      maxRadius: 20,
                                                      backgroundImage:
                                                          NetworkImage(
                                                              UserList_list[
                                                                      index]
                                                                  [
                                                                  'avatar'])),
                                                );
                                              }
                                            }
                                            return Container();
                                          },
                                        ),
                                      ),
                                      PopupMenuButton(
                                          padding: const EdgeInsets.all(16.0),
                                          onCanceled: () {
                                            setState(() {
                                              changeIcon =
                                                  Icons.arrow_drop_down;
                                            });
                                          },
                                          onSelected: (value) {
                                            // ignore: avoid_print
                                            print(data['assignees'].length);

                                            if (value == 0) {
                                              selectedTerritorries!.clear();
                                              selectedUsers.clear();
                                              openDialog(data, docs[index].id);
                                            }

                                            if (value == 1) {
                                              ManageTerritoriesFunction()
                                                  .showAlertDialog(
                                                      context, value!, data);
                                            }
                                            if (value == 2) {
                                              FirebaseFunctions().deleteItems(
                                                  docs[index].id,
                                                  'territories',
                                                  'Delete Territory',
                                                  'errorMsg');
                                            }
                                          },
                                          icon: Icon(
                                            changeIcon,
                                            color: Colors.green,
                                            size: 30,
                                          ),
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          itemBuilder: (context) {
                                            return List.generate(3, (index) {
                                              return PopupMenuItem(
                                                // enabled: index != 0,
                                                value: index,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    index == 0
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(5.0),
                                                            child: Text(
                                                                ManageTerritoriesFunction()
                                                                    .popupData(
                                                                        index)),
                                                          )
                                                        : Text(
                                                            ManageTerritoriesFunction()
                                                                .popupData(
                                                                    index)),
                                                    index == 0
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 10.0),
                                                            child: Divider(),
                                                          )
                                                        : Container()
                                                  ],
                                                ),
                                              );
                                            });
                                          }),
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                          return Center(child: CircularProgressIndicator());
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future openDialog(data, docsId) => showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setStateSB) {
          return AlertDialog(
              insetPadding: const EdgeInsets.fromLTRB(26, 0, 26, 0),
              title: Text(
                data != null
                    ? "Update Existing Territory"
                    : "Create New Territory",
                style: TextStyle(color: Colors.black, fontSize: 18.sp),
              ),
              content: Text(
                data != null
                    ? "Enter details here to update existing territory"
                    : "Enter details here to create new territory",
                style: TextStyle(color: Colors.grey, fontSize: 12.sp),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 21.w),
                  child: SizedBox(
                    height: 22.h,
                    width: 305.w,
                    child: Text("Territory Name",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 21.w),
                  child: Container(
                      height: 42.h,
                      width: 305.w,
                      child: TextFormField(
                        enabled: data != null ? false : true,
                        // controller: territortname,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.all(
                              Radius.circular(3),
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3))),
                          hintText: data != null
                              ? data['territoryname']
                              : "Eg Territory 1",
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12.sp,
                              color: Color.fromRGBO(0, 0, 0, 1)),
                        ),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.w, right: 1.w, top: 50.h),
                  child: Row(
                    children: [
                      Container(
                          width: 145.w,
                          height: 42.h,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.grey),
                              onPressed: () {
                                // _clearPolygons();

                                Navigator.pop(context, true);
                              },
                              child: Text("Back"))),
                      SizedBox(
                        width: 10.w,
                      ),
                      Container(
                          width: 145.w,
                          height: 42.h,
                          child: ElevatedButton(
                              onPressed: () {
                                if (data != null) {
                                  // dataListOfUserFroServer.clear();
                                  for (var i = 0;
                                      i < data['assignees'].length;
                                      i++) {
                                    dataListOfUserFroServer.add({
                                      'id': data['assignees'][i]['id'],
                                      'fullname': data['assignees'][i]
                                          ['fullname'],
                                      'email': data['assignees'][i]['email'],
                                    });
                                  }
                                }
                                assignTerritory(context, data,
                                    dataListOfUserFroServer, docsId);
                              },
                              child: Text("Next"))),
                    ],
                  ),
                ),
                SizedBox(height: 30.h),
              ]);
        });
      });

  Future assignTerritory(
      BuildContext context, data, userListFromServer, docsId) async {
    return await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              insetPadding: EdgeInsets.fromLTRB(26, 0, 26, 0),
              title: Text(
                data != null
                    ? "Update Existing Territory"
                    : "Create New Territory",
                style: TextStyle(color: Colors.black, fontSize: 18.sp),
              ),
              content: Text(
                data != null
                    ? "Enter details here to update existing territory"
                    : "Enter details here to create new territory",
                style: TextStyle(color: Colors.grey, fontSize: 12.sp),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 24.h),
                  child: SingleChildScrollView(
                    child: Container(
                      width: 305.w,
                      height: 22.h,
                      child: Text(
                        "Assign Territory To",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 14.sp),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 17.w, right: 22.w),
                  child: SizedBox(
                    height: 61.h,
                    width: 305.w,
                    child: MultiSelectBottomSheetField(
                        backgroundColor: ColorConstants().white,
                        buttonIcon: const Icon(Icons.arrow_drop_down),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        // dialogHeight: MediaQuery.of(context).size.height / 2,
                        items: ((UserList_list)).map((e) {
                          return MultiSelectItem((e), e['fullname'].toString());
                        }).toList(),
                        onConfirm: (values) {
                          selectedUsers = values;
                        },
                        initialValue: selectedUsers,
                        chipDisplay: MultiSelectChipDisplay.none()),
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                SizedBox(
                  height: 8.h,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 24.h),
                  child: SingleChildScrollView(
                    child: Container(
                      width: 305.w,
                      height: 22.h,
                      child: Text(
                        "Assign Campaign",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 14.sp),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 17.w, right: 22.w),
                  child: SizedBox(
                    height: 61.h,
                    width: 305.w,
                    child: MultiSelectBottomSheetField(
                        backgroundColor: ColorConstants().white,
                        buttonIcon: const Icon(Icons.arrow_drop_down),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        // dialogHeight: MediaQuery.of(context).size.height / 2,
                        items: ((CampaignList_list)).map((e) {
                          print(CampaignList_list);
                          return MultiSelectItem((e), e['name'].toString());
                        }).toList(),
                        onConfirm: (values) {
                          selectedTerritorries = values;
                        },
                        initialValue: selectedTerritorries,
                        chipDisplay: MultiSelectChipDisplay.none()),
                  ),
                ),
                SizedBox(height: 25.h),
                Padding(
                  padding: EdgeInsets.only(
                    left: 23.w,
                    right: 1.w,
                  ),
                  child: Row(
                    children: [
                      Container(
                          width: 145.w,
                          height: 42.h,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.grey),
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                              child: Text("Back"))),
                      SizedBox(
                        width: 10.w,
                      ),
                      Container(
                          width: 145.w,
                          height: 42.h,
                          child: ElevatedButton(
                              onPressed: () {
                                // print(isUpdate);
                                print(selectedTerritorries);
                                print(selectedUsers);

                                // isUpdate == true
                                dataUpdate = {
                                  "paths": data['paths'],
                                  "territoryname": data['territoryname'],
                                  "created": DateFormat("yyyy-MM-dd")
                                      .format(DateTime.now()),
                                  "assignees":
                                      jsonDecode(jsonEncode(selectedUsers)),
                                  'campaigns': selectedTerritorries,
                                  'setmarker': data['setmarker']
                                };
                                // dataSend = {
                                //   // "paths": path,
                                //   "territoryname": territortname.value.text,
                                //   "created": DateFormat("yyyy-MM-dd")
                                //       .format(DateTime.now()),
                                //   "assignees":
                                //       jsonDecode(jsonEncode(selectedUsers)),
                                //   'campaigns': selectedTerritorries!,
                                //   // 'setmarker': {
                                //   //   'lat': setMarker!.latitude,
                                //   //   'lng': setMarker!.longitude
                                //   // }
                                // };

                                // isUpdate == true
                                FirebaseFunctions().updateItems(
                                    dataUpdate!,
                                    docsId,
                                    'territories',
                                    "Territory Update",
                                    "errorMsg");

                                // FirebaseFunctions().addtems(
                                //     dataSend!,
                                //     'territories',
                                //     "Terittory Added",
                                //     "errorMsg");
                                // _clearPolygons();

                                Navigator.pop(context, true);
                                Navigator.pop(context, true);
                              },
                              child: Text("Next"))),
                    ],
                  ),
                ),
                SizedBox(height: 30.h),
              ],
            );
          });
        });
  }
}
