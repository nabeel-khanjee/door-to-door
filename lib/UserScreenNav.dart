import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page/UserTodoScreen.dart';
import 'package:page/src/Screen/GoogleMap/app_google_map.dart';
import 'package:page/src/Screen/Profile/profile_screen.dart';
import 'package:page/src/Screen/leads/leads.dart';
import 'package:page/src/firebase/firebase_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserScreenNav extends StatefulWidget {
  UserScreenNav(
      {Key? key, required this.currentTab, required this.currentScreen})
      : super(key: key);
  int currentTab;
  Widget currentScreen;
  @override
  State<UserScreenNav> createState() => _UserScreenNavState();
}


class _UserScreenNavState extends State<UserScreenNav> {

  LatLng _coordinates = LatLng(24.9008, 67.1681); //default value
  String? uid;
  Timer? _timer;

  Map<String, Object>? dataSend;
  getUserIdfromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    // getTodolist(
    //     jsonDecode(prefs.getString("user").toString())["uid"].toString());
    uid = jsonDecode(prefs.getString("user").toString())["uid"].toString();
    sendData();
  }

  void getCurrentLocation() async {
    await Geolocator.getCurrentPosition().then((currLocation) {
      setState(() {
        _coordinates = LatLng(currLocation.latitude, currLocation.longitude);
      });
    });
    getUserIdfromLocal();
  }

  void sendData() {
    dataSend = {
      'lastLocation': {
        'lat': _coordinates.latitude,
        'lng': _coordinates.longitude
      },
      'lastLogin': DateTime.now().millisecondsSinceEpoch
    };

    FirebaseFunctions()
        .updateItems(dataSend!, uid!, 'users', '', 'errorMsg');
    Timer(const Duration(minutes: 5), () {
      sendData();
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(actions: [
      //   MaterialButton(
      //     onPressed: () {
      //       sendData();
      //       print(DateTime.now().millisecondsSinceEpoch);
      //     },
      //     child: Text("data"),
      //   )
      // ]),
      backgroundColor: Colors.white,
      body: PageStorage(bucket: PageStorageBucket(), child: widget.currentScreen),
      bottomNavigationBar: BottomAppBar(
        // notchMargin: 50,
        color: Colors.white,
        child: Container(
          height: 88.h,
          width: 428.w,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                MaterialButton(
                    minWidth: 24.w,
                    height: 24.h,
                    onPressed: () {
                      setState(() {
                        widget.currentScreen = AppGoogleMap(
                          user: 1,
                        );
                        widget.currentTab = 0;
                      });
                    },
                    child: Icon(Icons.home_outlined,
                        color: widget.currentTab == 0
                            ? Colors.green
                            : Colors.grey)),
                MaterialButton(
                    minWidth: 24.w,
                    height: 24.h,
                    onPressed: () {
                      setState(() {
                        widget.currentScreen = const LeadScreen();
                        widget.currentTab = 1;
                      });
                    },
                    child: Icon(Icons.location_city_sharp,
                        color: widget.currentTab == 1
                            ? Colors.green
                            : Colors.grey)),
                MaterialButton(
                  minWidth: 24.w,
                  height: 24.h,
                  onPressed: () {
                    setState(() {
                      widget.currentScreen = UserTodoScreen();
                      widget.currentTab = 2;
                    });
                  },
                  child: Icon(Icons.task_alt,
                      color:
                          widget.currentTab == 2 ? Colors.green : Colors.grey),
                ),
                MaterialButton(
                    minWidth: 24.w,
                    height: 24.h,
                    onPressed: () {
                      setState(() {
                        widget.currentScreen = ProfileScreem();
                        widget.currentTab = 3;
                      });
                    },
                    child: Icon(Icons.person,
                        color: widget.currentTab == 3
                            ? Colors.green
                            : Colors.grey)),
                // MaterialButton(
                //     minWidth: 24.w,
                //     height: 24.h,
                //     onPressed: () {
                //       setState(() {
                //         currentScreen = Home();
                //         currentTab = 3;
                //       });
                //     },
                //     child: Icon(Icons.person,
                //         color: currentTab == 3 ? Colors.green : Colors.grey),
                //         ),
              ]),
        ),
      ),
    );
  }
}
