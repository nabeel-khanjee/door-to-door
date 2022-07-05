// ignore: file_names
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:page/alltodoscreen.dart';
import 'package:page/src/Screen/GoogleMap/app_google_map.dart';
import 'package:page/src/Screen/ManageTerritoried/manage_territories.dart';
import 'package:page/src/Screen/Profile/profile_screen.dart';
import 'package:page/src/firebase/firebase_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavBar extends StatefulWidget {
 NavBar(
      {Key? key,  this.currentTab=0,  this.currentScreen= const AppGoogleMap(
    user: 0,
  ) })
      : super(key: key);
    int currentTab;
  Widget currentScreen;

  @override
  _NavBarState createState() => _NavBarState();
}


final key = GlobalKey<ScaffoldState>();

class _NavBarState extends State<NavBar> {
  
  LatLng _coordinates = LatLng(24.9008, 67.1681); //default value
  String? uid;

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
     
      backgroundColor: Colors.white,
      body: PageStorage(bucket: PageStorageBucket(), child:widget. currentScreen),
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
                 widget.     currentScreen = AppGoogleMap(
                        user: 0,
                      );
                     widget. currentTab = 0;
                    });
                  },
                  child: Icon(Icons.home_outlined,
                      color:widget. currentTab == 0 ? Colors.green : Colors.grey),
                ),
                MaterialButton(
                    minWidth: 24.w,
                    height: 24.h,
                    onPressed: () {
                      setState(() {
                       widget. currentScreen = ManageTerritories();
                   widget.     currentTab = 1;
                      });
                    },
                    child: Icon(Icons.map_rounded,
                        color:widget. currentTab == 1 ? Colors.green : Colors.grey)),
                MaterialButton(
                    minWidth: 24.w,
                    height: 24.h,
                    onPressed: () {
                      setState(() {
                 widget.       currentScreen = Alltodos();
                       widget. currentTab = 2;
                      });
                    },
                    child: Icon(Icons.task_alt,
                        color: widget.currentTab == 2 ? Colors.green : Colors.grey)),
                MaterialButton(
                    minWidth: 24.w,
                    height: 24.h,
                    onPressed: () {
                      setState(() {
                        widget.currentScreen = ProfileScreem();
                  widget.      currentTab = 3;
                      });
                    },
                    child: Icon(Icons.person,
                        color: widget.currentTab == 3 ? Colors.green : Colors.grey)),
              ]),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:page/alltodoscreen.dart';
// import 'package:page/createnewtodo.dart';
// import 'package:page/home.dart';
// class NavBar extends StatefulWidget {
//   const NavBar({ Key? key }) : super(key: key);
//   @override
//   State<NavBar> createState() => _NavBarState();
// }
// class _NavBarState extends State<NavBar> {
//   int _currentIndex = 0;
//   final List<Widget> _children = [
//     const Home(),
//     const Home(),
//      Alltodos(),
//     const Home(),
//   ];
//   void onTappedBar(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _children[_currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//           currentIndex: _currentIndex,
//           onTap: onTappedBar,
//           items: [
//             BottomNavigationBarItem(
//               icon: Icon(
//                 Icons.home, 
//                 color:  Home():Colors.grey?,
//               ),
//               label: 'home',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(
//                 Icons.male_sharp,
//                 color: Colors.grey,
//               ),
//               label: 'territories',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(
//                 Icons.task_alt,
//                 color: Colors.green,
//               ),
//               label: 'todos',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(
//                 Icons.person_rounded,
//                 color: Colors.grey,
//               ),
//               label: 'profile',
//             ),
//           ],
//         ),
//     );
//   }
// }