// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:collection';
import 'dart:math' as Math;

class GetUsers {
  String? id;
  String? fullname;

  GetUsers();
  Map<String, dynamic> toJson() => {'id': id, 'fullname': fullname};

  GetUsers.fromSnapshot(snapshot)
      : id = snapshot.id,
        fullname = snapshot.data()['fullname'];
}

class GMap extends StatefulWidget {
  const GMap({Key? key}) : super(key: key);

  @override
  State<GMap> createState() => _GMapState();
}

class _GMapState extends State<GMap> {
  TextEditingController territorttext = TextEditingController();

  bool _drawPolygonEnabled = false;
  List<LatLng> _userPolyLinesLatLngList = [];
  bool _clearDrawing = false;
  late int lastXCoordinate, lastYCoordinate;

  List<GetUsers> _allUsers = [];
  List<Object?> selectedUsers = [];

  String? selectedCarType;

  List<dynamic> staticlist = [];

  Future getTodolist() async {
    await FirebaseFirestore.instance.collection('users').get().then((value) {
      setState(() {
        _allUsers =
            List.from(value.docs.map((doc) => GetUsers.fromSnapshot(doc)));
        // print(_allUsers);
        // _allUsers = _allUsers
        //     .map((item) =>
        //         MultiSelectItem<GetUsers>(item.value, item.value.fullname))
        //     .toList();
      });
    });
  }

  void insertAssignees() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    List<GetUsers> teste = [];

    // for (var i = 0; i < selectedUsers.length; i++) {

    //   print(map2);
    // }

    // db.collection("territories").add({
    //   "assigneess": teste.map((e) => e.toJson()).toList(),
    //   "territoryname": territorttext.text,
    // });
  }

  bool maps = false;

  bool polyEnable = false;

  bool dialogTerritoryNameEnable = false;
  bool dialogAssignTerritoryEnable = false;

  var pppooiinntt = [];

  late GoogleMapController newGoogleMapController;
  Completer<GoogleMapController> _controllerGoogleMap = Completer();

  Set<Polygon> _polygons = Set<Polygon>();
  Set<Polyline> _polyLines = Set<Polyline>();
  List<LatLng> polygonLatLngs = <LatLng>[];

  _onPanUpdate(DragUpdateDetails details) async {
    // To start draw new polygon every time.
    if (_clearDrawing) {
      _clearDrawing = false;
      _clearPolygons();
    }

    if (_drawPolygonEnabled) {
      late double x, y;
      if (Platform.isAndroid) {
        // It times in 3 without any meaning,
        // We think it's an issue with GoogleMaps package.
        x = details.globalPosition.dx * 3;
        y = details.globalPosition.dy * 3;
      } else if (Platform.isIOS) {
        x = details.globalPosition.dx;
        y = details.globalPosition.dy;
      }

      // Round the x and y.
      int xCoordinate = x.round();
      int yCoordinate = y.round();

      // Check if the distance between last point is not too far.
      // to prevent two fingers drawing.
      if (lastXCoordinate != null && lastYCoordinate != null) {
        var distance = Math.sqrt(Math.pow(xCoordinate - lastXCoordinate, 2) +
            Math.pow(yCoordinate - lastYCoordinate, 2));
        // Check if the distance of point and point is large.
        if (distance > 80.0) return;
      }

      // Cached the coordinate.
      lastXCoordinate = xCoordinate;
      lastYCoordinate = yCoordinate;

      ScreenCoordinate screenCoordinate =
          ScreenCoordinate(x: xCoordinate, y: yCoordinate);

      final GoogleMapController controller = await _controllerGoogleMap.future;
      LatLng latLng = await controller.getLatLng(screenCoordinate);

      try {
        // Add new point to list.
        _userPolyLinesLatLngList.add(latLng);

        _polyLines.removeWhere(
            (polyline) => polyline.polylineId.value == 'user_polyline');
        _polyLines.add(
          Polyline(
            polylineId: PolylineId('user_polyline'),
            points: _userPolyLinesLatLngList,
            width: 2,
            color: Colors.blue,
          ),
        );
      } catch (e) {
        print(" error painting $e");
      }
      setState(() {});
    }
  }

//panendfunction
  _onPanEnd(DragEndDetails details) async {
    // Reset last cached coordinate
    lastXCoordinate = null as int;
    lastYCoordinate = null as int;

    if (_drawPolygonEnabled) {
      _polygons
          .removeWhere((polygon) => polygon.polygonId.value == 'user_polygon');
      _polygons.add(
        Polygon(
          polygonId: PolygonId('user_polygon'),
          points: _userPolyLinesLatLngList,
          strokeWidth: 2,
          strokeColor: Colors.blue,
          fillColor: Colors.blue.withOpacity(0.4),
        ),
      );
      setState(() {
        _clearDrawing = true;
      });
    }
  }

// Clear polygon and polylines function
  _clearPolygons() {
    setState(() {
      _polyLines.clear();
      _polygons.clear();
      _userPolyLinesLatLngList.clear();
    });
  }

  int _polygonIdCounter = 1;

  LocationPermission permission =
      LocationPermission.denied; //initial permission status

  LatLng _coordinates = LatLng(24.9008, 67.1681); //default value
  // LatLng currentLatLng = LatLng(0.0, 0.0); //updated value

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(24.9008, 67.1681),
    zoom: 14.4746,
  );

  _setPolygon() {
    final String polygonIdVal = 'polygon_$_polygonIdCounter';
    _polygonIdCounter++;

    _polygons.add(
      Polygon(
        polygonId: PolygonId(polygonIdVal),
        points: polygonLatLngs,
        strokeWidth: 2,
        fillColor: Colors.transparent,
      ),
    );
  }

  @override
  void initState() {
    selectedUsers = _allUsers;
    super.initState();

    getCurrentLocation();
    checkPermission();
  }

  //checking Permission
  void checkPermission() async {
    permission = await Geolocator.checkPermission();
  }

  //Starts drawing
  _toggleDrawing() {
    _clearPolygons();
    setState(() => _drawPolygonEnabled = !_drawPolygonEnabled);
  }

  // get current location
  void getCurrentLocation() async {
    await Geolocator.getCurrentPosition().then((currLocation) {
      setState(() {
        _coordinates =
            LatLng(currLocation.latitude, currLocation.longitude);
      });
    });
  }

  //call this onPress floating action button
  void _currentLocation() async {
    getCurrentLocation();
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: _coordinates,
        zoom: 15.0,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    getTodolist();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.more_time_rounded,
            color: Colors.black,
          ),
          onPressed: () {},
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(left: 117.w, right: 89.w),
            child: Container(
              width: 138.w,
              height: 29.44.h,
              child: IconButton(
                // Icons.arrow_back_ios_new_rounded
                icon: Image.asset('images/appbar Vector.png'),
                onPressed: () {},
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.notifications_none,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          GestureDetector(
            onPanUpdate: (_drawPolygonEnabled) ? _onPanUpdate : null,
            onPanEnd: (_drawPolygonEnabled) ? _onPanEnd : null,
            child: GoogleMap(
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              polygons: _polygons,
              polylines: _polyLines,
              myLocationButtonEnabled: true,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controllerGoogleMap.complete(controller);
                newGoogleMapController = controller;
              },
              // onTap: (Point) {
              //   setState(() {
              //     polygonLatLngs.add(Point);
              //     // _setPolygon();
              //   });
              //   print(polygonLatLngs);
              // },
            ),
          ),
          ClipRect(
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      // alltodos = true;
                      // Todo();
                    });
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 64.h,
                        width: 210.w,
                        color: Colors.white,
                        child: Center(
                          child: Text(
                            "CurrentlyViewing",
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      // if (alltodos)
                      // todomethod(),
                      // Todo(),
                      // Container(
                      //   margin: EdgeInsets.only(top: 1.h),
                      //   height: 3.h,
                      //   width: 214.w,
                      //   // color: alltodos ? Colors.green : Colors.grey,
                      // ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      // alltodos = false;
                    });
                  },
                  child: Column(
                    children: [
                      Container(
                        color: Colors.white,
                        height: 64.h,
                        width: 218.w,
                        // color: Colors.white,
                        child: Center(
                          child: Text(
                            "No territory created",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      // // if (!alltodos)
                      // Container(
                      //   margin: EdgeInsets.only(top: 1.h),
                      //   height: 3.h,
                      //   width: 218.w,
                      //   // color: !alltodos ? Colors.green : Colors.grey,
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 17.h,
          ),
          Padding(
            padding: EdgeInsets.only(top: 90.h, right: 31.w),
            child: Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    maps = !maps;
                  });
                },
                child: Container(
                  color: maps ? Colors.green : Colors.white,
                  height: 45.h,
                  width: 45.w,
                  child: Icon(
                    Icons.menu,
                    color: maps ? Colors.white : Colors.green,
                  ),
                ),
              ),
            ),
          ),
          if (maps) mapButtons(),
          // if (!maps)
          Padding(
            padding: EdgeInsets.only(left: 339.w, right: 31.w, top: 460.h),
            child: Container(
              height: 58.h,
              width: 58.w,
              child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.sp)),
                  onPressed: () async {
                    var currentZoomLevel =
                        await newGoogleMapController.getZoomLevel();
                    currentZoomLevel = currentZoomLevel + 1;
                    newGoogleMapController.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: _coordinates,
                          zoom: currentZoomLevel,
                        ),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.green,
                  )),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 339.w, right: 31.w, top: 530.h),
            child: Container(
              height: 58.h,
              width: 58.w,
              child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.sp)),
                  onPressed: () async {
                    var currentZoomLevel =
                        await newGoogleMapController.getZoomLevel();
                    currentZoomLevel = currentZoomLevel - 1;
                    if (currentZoomLevel < 0) currentZoomLevel = 0;
                    newGoogleMapController.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: _coordinates,
                          zoom: currentZoomLevel,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 15.h),
                    child: Icon(
                      Icons.minimize,
                      color: Colors.green,
                    ),
                  )),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 339.w, right: 31.w, top: 630.h),
            child: Container(
              height: 58.h,
              width: 58.w,
              child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.sp)),
                  onPressed: () {
                    _currentLocation();
                  },
                  child: Icon(
                    Icons.my_location_outlined,
                    color: Colors.green,
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Future openDialog() => showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setStateSB) {
          return AlertDialog(
              insetPadding: EdgeInsets.fromLTRB(26, 0, 26, 0),
              title: Text(
                "Create New Territory",
                style: TextStyle(color: Colors.black, fontSize: 18.sp),
              ),
              content: Text(
                "Enter details here to create new territory",
                style: TextStyle(color: Colors.grey, fontSize: 12.sp),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 21.w),
                  child: Container(
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
                        controller: territorttext,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.all(
                              Radius.circular(3),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3))),
                          hintText: "Eg Territory 1",
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
                                Navigator.pop(context, true);
                                assignTerritory(context);
                              },
                              child: Text("Next"))),
                    ],
                  ),
                ),
                SizedBox(height: 30.h),
              ]);
        });
      });

  Future assignTerritory(BuildContext context) async {
    return await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              insetPadding: EdgeInsets.fromLTRB(26, 0, 26, 0),
              title: Text(
                "Create New Territory",
                style: TextStyle(color: Colors.black, fontSize: 18.sp),
              ),
              content: Text(
                "Enter details here to create new territory",
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
                SizedBox(
                  height: 8.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 17.w, right: 22.w),
                  child: Container(
                    // decoration: BoxDecoration(
                    //   border: Border.all(
                    //     color: Colors.grey,
                    //   ),
                    // ),
                    height: 61.h,
                    width: 305.w,
                    child: MultiSelectDialogField(
                        buttonIcon: Icon(Icons.arrow_drop_down),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        items: _allUsers
                            .map((e) => MultiSelectItem<GetUsers>(
                                e, e.fullname.toString()))
                            .toList(),
                        onConfirm: (values) {
                          // print(values);
                        },
                        initialValue: selectedUsers,
                        onSaved: (val) {
                          setState(
                            () {
                              selectedUsers = val!;
                              // print(selectedUsers.toList());
                            },
                          );
                        },
                        chipDisplay: MultiSelectChipDisplay.none()),
                    // DropdownButton(
                    //   focusColor: Colors.grey,
                    //   borderRadius: BorderRadius.all(
                    //     Radius.circular(3),
                    //   ),
                    //   dropdownColor: Colors.white,
                    //   alignment: AlignmentDirectional.center,
                    //   icon: Padding(
                    //     padding: EdgeInsets.only(
                    //       left: 140.w,
                    //     ),
                    //     child: Icon(
                    //       Icons.arrow_drop_down,
                    //       color: Colors.black,
                    //     ),
                    //   ),
                    //   iconSize: 20,
                    //   hint: Padding(
                    //     padding: EdgeInsets.only(
                    //         left: 3.0.w, right: 3.w, top: 8.h, bottom: 8.h),
                    //     child: Text(
                    //       'Select Assignee',
                    //       style: TextStyle(
                    //         fontSize: 13.sp,
                    //         color: Colors.black,
                    //       ),
                    //     ),
                    //   ),
                    //   value: selectedCarType,
                    //   onChanged: (newValue) {
                    //     setState(
                    //       () {
                    //         selectedCarType = newValue.toString();
                    //       },
                    //     );
                    // },
                    // items: _allUsers.map(
                    //   (assignee) {
                    //     return DropdownMenuItem(
                    //       child: Padding(
                    //         padding: EdgeInsets.only(
                    //             right: 6.w, left: 3.w, top: 8.h, bottom: 8.h),
                    //         child: Text(
                    //           "${assignee.fullname}",
                    //           style: TextStyle(
                    //             color: Colors.black,
                    //           ),
                    //         ),
                    //       ),
                    //       value: "${assignee.id}",
                    //     );
                    //   },
                    // ).toList(),
                    // ),
                  ),
                ),
                SizedBox(height: 25.h),
                Padding(
                  padding: EdgeInsets.only(right: 24.w),
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
                SizedBox(height: 8.h),
                Padding(
                  padding: EdgeInsets.only(left: 18.w, right: 20.w),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                    ),
                    height: 49.h,
                    width: 305.w,
                    child: DropdownButton(
                      focusColor: Colors.grey,
                      borderRadius: BorderRadius.all(
                        Radius.circular(3),
                      ),
                      dropdownColor: Colors.white,
                      alignment: AlignmentDirectional.center,
                      icon: Padding(
                        padding: EdgeInsets.only(
                          left: 140.w,
                        ),
                        child: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black,
                        ),
                      ),
                      iconSize: 20,
                      hint: Padding(
                        padding: EdgeInsets.only(
                            left: 3.0.w, right: 3.w, top: 8.h, bottom: 8.h),
                        child: Text(
                          'Select Campaign',
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      value: selectedCarType,
                      onChanged: (newValue) {
                        // setState(
                        //   () {
                        //     selectedCarType = newValue.toString();
                        //   },
                        // );
                      },
                      items: staticlist.map(
                        (car) {
                          return DropdownMenuItem(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  right: 3.w, left: 8.w, top: 8.h, bottom: 8.h),
                              child: Text(
                                "${car.fullname}",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            value: "${car.id}",
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 35.h,
                ),
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
                                insertAssignees();
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

  Column mapButtons() {
    if (maps) {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 249.w, top: 155.h, right: 31.w),
            child: Container(
              height: 48.h,
              width: 149.w,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    primary: Colors.white,
                    shadowColor: Colors.transparent),
                onPressed: () {
                  _toggleDrawing;
                  // setState(() {
                  // if (polyEnable) {
                  //   openDialog();
                  // }
                  // polyEnable = !polyEnable;
                  // });
                },
                icon: Icon(
                  Icons.map,
                  color: Color.fromRGBO(0, 146, 65, 1),
                ),
                label: Text(
                  'Mark Territory',
                  style: TextStyle(
                    color: Color.fromRGBO(0, 146, 65, 1),
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 17.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 249.w, right: 31.w),
            child: Container(
              width: 148.w,
              height: 45.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.white),
                onPressed: () {},
                child: Text(
                  'Manage Territories',
                  style: TextStyle(
                    color: Color.fromRGBO(0, 146, 65, 1),
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 17.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 249.w, right: 31.w),
            child: Container(
              height: 45.h,
              width: 148.w,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    primary: Colors.white,
                    shadowColor: Colors.transparent),
                onPressed: () {},
                icon: Icon(
                  Icons.location_history,
                  color: Color.fromRGBO(0, 146, 65, 1),
                ),
                label: Text(
                  'Track Users',
                  style: TextStyle(
                    color: Color.fromRGBO(0, 146, 65, 1),
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Column();
    }
  }
}
