import 'dart:async';
import 'package:http/http.dart' as http;

import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as Math;
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:page/CampaignDetails.dart';
import 'package:page/UserScreenNav.dart';
import 'package:page/alltodoscreen.dart';
import 'package:page/src/Api/api.dart';
import 'package:page/src/Globals/global.dart';
import 'package:page/src/Model/campaign_model.dart';
import 'package:page/src/Model/user_model.dart';
import 'package:page/src/Screen/CampaignSelectionScreen/campaign_selection_screen.dart';
import 'package:page/src/Screen/GoogleMap/Components/current_location_component.dart';
import 'package:page/src/Screen/GoogleMap/Components/currently_viewing_component.dart';
import 'package:page/src/Screen/GoogleMap/Components/map_marker_sheet.dart';
import 'package:page/src/Screen/GoogleMap/Components/map_menu_button.dart';
import 'package:page/src/Screen/GoogleMap/Components/map_type_component.dart';
import 'package:page/src/Screen/GoogleMap/Components/map_zoom_component.dart';
import 'package:page/src/Screen/GoogleMap/Components/territorries_listing_component.dart';
import 'package:page/src/Screen/GoogleMap/Functions/functions.dart';
import 'package:page/src/component/app_bar_component.dart';
import 'package:page/src/component/bottom_button_component.dart';
import 'package:page/src/component/campaign_status_component.dart';
import 'package:page/src/component/sub_heading_alertbox.dart';
import 'package:page/src/component/text_component.dart';
import 'package:page/src/constants/colors.dart';
import 'package:page/src/constants/image_path_constants.dart';
import 'package:page/src/constants/string_constants.dart';
import 'package:page/src/firebase/firebase_functions.dart';
import 'package:page/src/services/campaigns_services.dart';
import 'package:page/src/services/user_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetUsers {
  String? id;
  String? fullname;
  String? email;

  GetUsers();
  Map<String, dynamic> toJson() =>
      {'id': id, 'fullname': fullname, 'email': email};

  GetUsers.fromSnapshot(snapshot)
      : id = snapshot.id,
        email = snapshot.data()['email'],
        fullname = snapshot.data()['fullname'];
}

class AppGoogleMap extends StatefulWidget {
  final int user;
  const AppGoogleMap({
    Key? key,
    required this.user,
  }) : super(key: key);
  @override
  State<AppGoogleMap> createState() => _AppGoogleMapState();
}

class _AppGoogleMapState extends State<AppGoogleMap> {
  CampaignsService campaignService = CampaignsService();
  Future<List<Campaigns>>? campaignsList;
  List<Campaigns>? retrievedCampaignsList;
  UsersService userService = UsersService();
  Future<List<UserModel>>? userList;
  List<UserModel>? retrievedUserList;

  final List<Marker> _markers = <Marker>[
    const Marker(
        markerId: MarkerId('1'),
        position: LatLng(24.9008, 67.1681),
        infoWindow: InfoWindow(title: 'The Title of the marker'))
  ];
  late GoogleMapController newGoogleMapController;
  final Set<Polygon> _polygons = HashSet<Polygon>();
  final List<LatLng> _userPolyLinesLatLngList = [];
  final Set<Polyline> _polyLines = HashSet<Polyline>();
  final Math.Random _rnd = Math.Random();
  var territoryData;
  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  VoidCallback? _showPersistantBottomSheetCallBack;
  TextEditingController territortname = TextEditingController();
  List<GetUsers> _allUsers = [];
  List<Object?> selectedUsers = [];
  String? selectedCarType;
  List<dynamic> staticlist = [];
  List<LatLng>? dataListElement;
  List<Map<String, dynamic>> path = [];
  LatLngBounds? visibleRegion;
  BitmapDescriptor? myIcon;
  BitmapDescriptor? interestedMarker;
  BitmapDescriptor? notHomeMarker;
  BitmapDescriptor? comeBackMarker;
  BitmapDescriptor? notInteredtedMarker;
  BitmapDescriptor? emptyPropertyMarket;
  LatLng _coordinates = const LatLng(24.9008, 67.1681);
  List latlingLength = [];
  bool _drawPolygonEnabled = false;
  bool _clearDrawing = false;
  dynamic _lastXCoordinate, _lastYCoordinate;
  bool maps = false;
  bool showTerritorries = false;
  LatLng? setMarker;
  int campaignStatus = 0;
  List dataListOfUserFroServer = [];
  bool mapType = true;
  bool isUpdate = false;
  LatLng? getLatLng;
  DateTime _date = DateTime.now();
  bool mapMarkerVisible = false;
  bool isMarkerSheet = false;
  Marker? getMarker;
  int? markerStatus;
  String? markerType;
  String? territoryId;
  String? uid;
  Map<String, Object?>? leadsData;
  bool sendStatus = false;
  List<Object> campaignList = [];
  Map<String, Object>? dataSend;
  Map<String, dynamic>? dataUpdate;
  Map<String, dynamic>? campaignData;
  String location = "Search Location";
  String googleApikey = "AIzaSyCL21ZpWZTmzm2rFIMY4M9FXVK6lptV5vo";
  String? selectedTerritory;

  List<Object?>? selectedTerritorries;

  bool isAllUsers = false;
  bool isOnline = false;
  bool isOffiline = false;

  bool isUserFilter = false;

  getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    uid = jsonDecode(prefs.getString("user").toString())["uid"].toString();
  }

  disposeData() {
    newGoogleMapController.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? _datepicker = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
      initialDatePickerMode: DatePickerMode.day,
    );
    if (_datepicker != null && _datepicker != _date) {
      setState(() {
        _date = _datepicker;
      });
    }
  }

  double sizeOfImage = 100;

  @override
  initState() {
    super.initState();
    _initRetrieval();
    _showPersistantBottomSheetCallBack = _showBottomSheet;
    getUserData();
    MapFunctions().getUserCurrentLocation();
    getTodolist();
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(
                devicePixelRatio: sizeOfImage,
                size: Size(sizeOfImage, sizeOfImage)),
            ImageConstants().editImage)
        .then((onValue) {
      myIcon = onValue;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(
                devicePixelRatio: sizeOfImage,
                size: Size(sizeOfImage, sizeOfImage)),
            ImageConstants().interestedMarker)
        .then((onValue) {
      interestedMarker = onValue;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(
                devicePixelRatio: sizeOfImage,
                size: Size(sizeOfImage, sizeOfImage)),
            ImageConstants().notHomeMarker)
        .then((onValue) {
      notHomeMarker = onValue;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(
                devicePixelRatio: sizeOfImage,
                size: Size(sizeOfImage, sizeOfImage)),
            ImageConstants().comeBackMarker)
        .then((onValue) {
      comeBackMarker = onValue;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(
                devicePixelRatio: sizeOfImage,
                size: Size(sizeOfImage, sizeOfImage)),
            ImageConstants().notInteredtedMarker)
        .then((onValue) {
      notInteredtedMarker = onValue;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(
                devicePixelRatio: sizeOfImage,
                size: Size(sizeOfImage, sizeOfImage)),
            'images/empty_property.png')
        .then((onValue) {
      emptyPropertyMarket = onValue;
    });
  }

  ApiForApp apiForApp = ApiForApp();
  Future<void> _initRetrieval() async {
    campaignsList = campaignService.retrieveCampaigns();
    retrievedCampaignsList = await campaignService.retrieveCampaigns();
    apiForApp.setGlobalCampaignList(retrievedCampaignsList);
    userList = userService.retrieveUserModel();
    retrievedUserList = await userService.retrieveUserModel();
    apiForApp.setGlobalUserList(retrievedUserList);
  }

  final globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: globalKey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: AppBarForApplication(
            actionCallback: () {},
            leadingCallback: () {},
            actionIcon: Icons.person_outline,
            leadingIcon: Icons.menu,
          ),
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('territories')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) return Text('Error = ${snapshot.error}');
              if (snapshot.hasData) {
                final docs = snapshot.data!.docs;
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    GestureDetector(
                      onPanUpdate: (_drawPolygonEnabled) ? _onPanUpdate : null,
                      onPanEnd: (_drawPolygonEnabled) ? _onPanEnd : null,
                      child: GoogleMap(
                        onTap: (latLng) {
                          getLatLng = LatLng(
                            latLng.latitude,
                            latLng.longitude,
                          );
                          leadsData = {
                            'setMarker': {
                              'lat': latLng.latitude,
                              'lng': latLng.longitude
                            },
                            'status': markerStatus,
                            'territoryId': territoryId,
                            'userId': uid
                          };
                          if (territoryId != null &&
                              uid != null &&
                              isMarkerSheet == true) {
                            setState(() {
                              _markers.add(Marker(
                                  anchor: Offset(0.5, 1.0),
                                  onTap: () {
                                    _showPopUp(campaignData);
                                  },
                                  markerId: MarkerId(
                                    "${_chars.codeUnitAt(_rnd.nextInt(_chars.length))}",
                                  ),
                                  icon: getMarkerOnMap(markerStatus),
                                  position: getLatLng!));
                            });

                            setState(() {
                              sendStatus = true;
                            });
                          }
                          if (sendStatus) {
                            FirebaseFunctions().addtems(leadsData!, 'leads',
                                'Lead Added Successfully', 'errorMsg');
                            setState(() {
                              sendStatus = false;
                            });
                          }
                        },
                        zoomGesturesEnabled: true,
                        zoomControlsEnabled: false,
                        mapType: mapType ? MapType.hybrid : MapType.normal,
                        polygons: _polygons,
                        polylines: _polyLines,
                        myLocationButtonEnabled: true,
                        initialCameraPosition: CameraPosition(
                          target: _coordinates,
                          zoom: 18,
                        ),
                        markers: Set<Marker>.of(_markers),
                        onMapCreated: (GoogleMapController controller) {
                          newGoogleMapController = controller;
                        },
                      ),
                    ),
                    widget.user == 0
                        ? Positioned(
                            top: 80,
                            left: 28,
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  color: isUserFilter
                                      ? ColorConstants().green
                                      : ColorConstants().white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: IconButton(
                                color: isUserFilter
                                    ? ColorConstants().white
                                    : ColorConstants().green,
                                onPressed: () {
                                  setState(() {
                                    isUserFilter = !isUserFilter;
                                  });
                                  print(isUserFilter);
                                },
                                icon: Icon(Icons.more_vert_outlined),
                              ),
                            ))
                        : Container(),
                    if (isUserFilter)
                      Positioned(
                        top: 140,
                        left: 30,
                        right: 170,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration:
                              BoxDecoration(color: ColorConstants().white),
                          width: 100,
                          height: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('All Users'),
                                  Checkbox(
                                    value: isAllUsers,
                                    onChanged: (value) {
                                      setState(() {
                                        this.isAllUsers = !isAllUsers;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Online'),
                                  Checkbox(
                                    value: isOnline,
                                    onChanged: (value) {
                                      setState(() {
                                        this.isOnline = !isOnline;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Offline'),
                                  Checkbox(
                                    value: isOffiline,
                                    onChanged: (value) {
                                      setState(() {
                                        this.isOffiline = !isOffiline;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              BottomButtonComponent(
                                buttonColor: ColorConstants().green,
                                textColor: ColorConstants().white,
                                buttonText: 'Save Filter',
                                onTap: () async {
                                  print(UserList_list);
                                  _markers.clear();
                                  for (var element in UserList_list) {
                                    print(element);

                                    if (isAllUsers) {
                                      print(element['avatar']);
                                      var dataBytes;
                                      var url = Uri.parse(element['avatar']);

                                      var request = await http.get(url);
                                      var bytes = request.bodyBytes;

                                      setState(() {
                                        dataBytes = bytes;
                                      });
                                      print(element);

                                      _markers.add(Marker(
                                          markerId: MarkerId(
                                            element['uid'],
                                          ),
                                          position: LatLng(
                                            element['lastLocation']['lat'],
                                            element['lastLocation']['lng'],
                                          ),
                                          icon: BitmapDescriptor.fromBytes(
                                              dataBytes.buffer.asUint8List()),
                                          infoWindow: InfoWindow(
                                              title: element['fullname'])));
                                    } else if (isOnline) {
                                      if ((element['lastLogin']) >
                                          (DateTime.now()
                                                  .millisecondsSinceEpoch) -
                                              5000000) {
                                        print(element['lastLogin']);
                                        print(DateTime.now()
                                            .millisecondsSinceEpoch);
                                        print(element['avatar']);
                                        var dataBytes;
                                        var url = Uri.parse(element['avatar']);

                                        var request = await http.get(url);
                                        var bytes = request.bodyBytes;

                                        setState(() {
                                          dataBytes = bytes;
                                        });
                                        print(element);

                                        _markers.add(Marker(
                                            markerId: MarkerId(
                                              element['uid'],
                                            ),
                                            position: LatLng(
                                              element['lastLocation']['lat'],
                                              element['lastLocation']['lng'],
                                            ),
                                            icon: BitmapDescriptor.fromBytes(
                                                dataBytes.buffer.asUint8List()),
                                            infoWindow: InfoWindow(
                                                title: element['fullname'])));
                                      }
                                    } else if (isOffiline) {
                                      if ((element['lastLogin']) <
                                          (DateTime.now()
                                                  .millisecondsSinceEpoch) -
                                              5000000) {
                                        print(element['avatar']);
                                        var dataBytes;
                                        var url = Uri.parse(element['avatar']);

                                        var request = await http.get(url);
                                        var bytes = request.bodyBytes;

                                        setState(() {
                                          dataBytes = bytes;
                                        });
                                        print(element);

                                        print(element['lastLogin']);
                                        print(DateTime.now()
                                            .millisecondsSinceEpoch);
                                        setState(() {
                                          _markers.add(Marker(
                                              markerId: MarkerId(
                                                element['uid'],
                                              ),
                                              position: LatLng(
                                                element['lastLocation']['lat'],
                                                element['lastLocation']['lng'],
                                              ),
                                              icon: BitmapDescriptor.fromBytes(
                                                  dataBytes.buffer
                                                      .asUint8List()),
                                              infoWindow: InfoWindow(
                                                  title: element['fullname'])));
                                        });
                                      }
                                    }
                                  }
                                },
                                paddingBottom: 0,
                                paddingLeft: 0,
                                paddingRight: 0,
                                paddingTop: 0,
                              )
                            ],
                          ),
                        ),
                      ),
                    widget.user == 1
                        ? Positioned(
                            top: 80,
                            left: 30,
                            right: 30,
                            child: InkWell(
                                onTap: () async {
                                  _clearPolygons();

                                  var place = await PlacesAutocomplete.show(
                                      context: context,
                                      apiKey: googleApikey,
                                      insetPadding: EdgeInsets.symmetric(
                                          horizontal: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              9.5,
                                          vertical: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              6.5),
                                      // mode: Mode.overlay,
                                      types: [],
                                      strictbounds: false,
                                      // components: [
                                      //   Component(Component.country, 'usa')
                                      // ],
                                      // google_map_webservice package
                                      onError: (err) {});

                                  if (place != null) {
                                    setState(() {
                                      location = place.description.toString();
                                    });

                                    //form google_maps_webservice package
                                    final plist = GoogleMapsPlaces(
                                      apiKey: googleApikey,
                                      apiHeaders:
                                          await GoogleApiHeaders().getHeaders(),
                                      //from google_api_headers package
                                    );
                                    String placeid = place.placeId ?? "0";
                                    final detail = await plist
                                        .getDetailsByPlaceId(placeid);
                                    final geometry = detail.result.geometry!;
                                    final lat = geometry.location.lat;
                                    final lang = geometry.location.lng;
                                    var newlatlang = LatLng(lat, lang);
                                    setState(() {
                                      _markers.add(Marker(
                                          markerId: MarkerId('1'),
                                          position: newlatlang));
                                    });
                                    //move map camera to selected place with animation
                                    newGoogleMapController.animateCamera(
                                        CameraUpdate.newCameraPosition(
                                            CameraPosition(
                                                target: newlatlang, zoom: 17)));
                                  }
                                },
                                child: Card(
                                  child: Container(
                                      padding: EdgeInsets.all(0),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Icon(Icons.search),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                150,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Text(
                                                location,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    height: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 30,
                                            child: Image(
                                                fit: BoxFit.fitHeight,
                                                image: NetworkImage(
                                                    'https://cdn.vox-cdn.com/thumbor/7WRwwPIyyQtq-Cd7nweT7opzKu4=/0x0:1280x800/920x613/filters:focal(538x298:742x502):format(webp)/cdn.vox-cdn.com/uploads/chorus_image/image/66260585/googlemaps.5.png')),
                                          )
                                        ],
                                      )),
                                )))
                        : Container(),
                    CurrentlyViewing(
                        selectedTerritory: selectedTerritory ??
                            StringConstants().selectTerritory,
                        onTap: () {
                          setState(() {
                            showTerritorries = !showTerritorries;
                          });
                        }),
                    SizedBox(
                      height: 17.h,
                    ),
                    if (widget.user == 0)
                      MapMenuButton(
                          onTap: () {
                            setState(() {
                              maps = !maps;
                            });
                          },
                          maps: maps),
                    MapTYpe(onTap: () {
                      setState(() {
                        mapType = !mapType;
                      });
                    }),
                    if (mapMarkerVisible)
                      widget.user == 1
                          ? MapMarkerSheet(
                              onTap: () {
                                if (isMarkerSheet) {
                                  setState(() {
                                    isMarkerSheet = !isMarkerSheet;
                                  });
                                  if (_showPersistantBottomSheetCallBack ==
                                      null) {
                                    Navigator.pop(context);
                                  }
                                } else {
                                  setState(() {
                                    isMarkerSheet = !isMarkerSheet;
                                  });
                                  _showBottomSheet();
                                }
                              },
                            )
                          : Container(),
                    if (maps) mapButtons(),
                    showTerritorries
                        ? Positioned(
                            top: 70,
                            right: 20,
                            height: MediaQuery.of(context).size.width / 1.5,
                            width: MediaQuery.of(context).size.width / 2,
                            child: ListView.builder(
                                itemCount: docs.length,
                                itemBuilder: (BuildContext context, index) {
                                  final Map<String, dynamic> data = docs[index]
                                      .data() as Map<String, dynamic>;
                                  return TerritorriesListing(
                                      onTap: () {
                                        print(data);
                                        setState(() {
                                          campaignData = data;
                                        });
                                        _polyLines.clear();
                                        _polygons.clear();
                                        _markers.clear();
                                        FirebaseFirestore.instance
                                            .collection('leads')
                                            .where('territoryId',
                                                isEqualTo: docs[index].id)
                                            .where('userId', isEqualTo: uid)
                                            .get()
                                            .then(
                                                (QuerySnapshot querySnapshot) {
                                          querySnapshot.docs.forEach((doc) {
                                            setState(() {
                                              selectedTerritory =
                                                  data['territoryname'];
                                              _markers.add(Marker(
                                                  onTap: () {
                                                    var data = {
                                                      'leadId': doc.id,
                                                      'territoryId':
                                                          doc["territoryId"],
                                                      'userId': doc["userId"]
                                                    };

                                                    _showPopUp(
                                                      data,
                                                    );
                                                  },
                                                  markerId: MarkerId(doc.id),
                                                  icon: getMarkerOnMap(
                                                      doc["status"]),
                                                  position: LatLng(
                                                      doc["setMarker"]['lat'],
                                                      doc["setMarker"]
                                                          ['lng'])));
                                            });
                                          });
                                        });
                                        _userPolyLinesLatLngList.clear();
                                        _polygons.clear();
                                        selectedUsers.clear();
                                        territortname.clear();
                                        setState(() {
                                          _coordinates = LatLng(
                                            data['setmarker']['lat'],
                                            data['setmarker']['lng'],
                                          );

                                          territoryData = data;
                                          territoryId = docs[index].id;
                                          mapMarkerVisible = true;
                                          newGoogleMapController.animateCamera(
                                            CameraUpdate.newCameraPosition(
                                              CameraPosition(
                                                target: LatLng(
                                                    data['setmarker']['lat'],
                                                    data['setmarker']['lng']),
                                                zoom: 18,
                                              ),
                                            ),
                                          );
                                          for (var i = 0;
                                              i < data['paths'].length;
                                              i++) {
                                            _userPolyLinesLatLngList.add(LatLng(
                                                data['paths'][i]['lat'],
                                                data['paths'][i]['lng']));
                                            setState(() {
                                              _polygons.add(
                                                Polygon(
                                                    polygonId: PolygonId(
                                                        docs[index].id),
                                                    points:
                                                        _userPolyLinesLatLngList,
                                                    strokeWidth: 2,
                                                    strokeColor: Colors.red,
                                                    fillColor: Colors.red
                                                        .withOpacity(0.2)),
                                              );
                                            });
                                          }
                                          print("location");
                                          print(
                                              "${data['setmarker']['lat']} ${data['setmarker']['lng']}");
                                          if (widget.user == 0) {
                                            _markers.add(Marker(
                                              markerId:
                                                  MarkerId(docs[index].id),
                                              position: LatLng(
                                                  data['setmarker']['lat'],
                                                  data['setmarker']['lng']),
                                              onTap: () {
                                                setState(() {
                                                  isUpdate = true;
                                                });

                                                openDialog(
                                                    data, docs[index].id);
                                              },
                                              icon: myIcon!,
                                            ));
                                          }
                                          showTerritorries = false;
                                        });
                                        isUpdate = false;
                                      },
                                      data: data);
                                }))
                        : Container(),
                    MapZoom(
                        fromTop: MediaQuery.of(context).size.height * 0.52,
                        iconData: Icons.add,
                        onTap: () async {
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
                        }),
                    MapZoom(
                        fromTop: MediaQuery.of(context).size.height * 0.6,
                        iconData: Icons.remove,
                        onTap: () async {
                          var currentZoomLevel =
                              await newGoogleMapController.getZoomLevel();
                          currentZoomLevel = currentZoomLevel - 1;
                          newGoogleMapController.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: _coordinates,
                                zoom: currentZoomLevel,
                              ),
                            ),
                          );
                        }),
                    CurrentLocation(onTap: () async {
                      _clearPolygons();
                      MapFunctions()
                          .getUserCurrentLocation()
                          .then((value) async {
                        _coordinates = LatLng(value.latitude, value.longitude);
                        setState(() {
                          _markers.add(
                            Marker(
                              markerId: MarkerId('1'),
                              position: LatLng(value.latitude, value.longitude),
                              infoWindow:
                                  InfoWindow(title: 'My Current Location'),
                            ),
                          );
                        });
                        CameraPosition cameraPosition = CameraPosition(
                            zoom: 18,
                            target: LatLng(
                                _coordinates.latitude, _coordinates.longitude));
                        newGoogleMapController.animateCamera(
                            CameraUpdate.newCameraPosition(cameraPosition));
                      });
                    }),
                  ],
                );
              }
              return const Center(child: CircularProgressIndicator());
            }));
  }

  _showPopUp(data) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: ColorConstants().white,
              title: SubHeadingAlertBox(text: 'Avaliable Campaigns'),
              contentPadding: EdgeInsets.all(0),
              // shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(20)),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('campaigns')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError)
                          return Text('Error = ${snapshot.error}');
                        if (snapshot.hasData) {
                          final docs = snapshot.data!.docs;
                          return ListView.builder(
                            itemCount: docs.length,
                            itemBuilder: (context, index) {
                              final Map<String, dynamic> campaignList =
                                  docs[index].data() as Map<String, dynamic>;

                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            campaignList['details'] ??
                                                "details",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                'Due Date',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(campaignList['date_range']
                                                      ['to'] ??
                                                  "date")
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  BottomButtonComponent(
                                      paddingBottom: 10,
                                      paddingLeft: 10,
                                      paddingRight: 10,
                                      paddingTop: 10,
                                      buttonColor: ColorConstants().green,
                                      buttonText: "View Campaign Details",
                                      textColor: ColorConstants().white,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CapaignDetailsScreen(
                                                      data: data,
                                                      campaignList:
                                                          campaignList,
                                                      campaignId: snapshot.data!
                                                          .docs[index].id)),
                                        );
                                      }),
                                  Divider()
                                ],
                              );
                            },
                          );
                        }
                        return SizedBox(
                            height: 50,
                            width: 50,
                            child: Center(child: CircularProgressIndicator()));
                      }),
                ),
              ),
            ));
  }

  void _showBottomSheet() {
    setState(() {
      _showPersistantBottomSheetCallBack = null;
      isMarkerSheet = true;
    });
    globalKey.currentState!
        .showBottomSheet((
          BuildContext context,
        ) {
          return Container(
            padding: EdgeInsets.all(16),
            height: 247.h,
            decoration: BoxDecoration(
                color: ColorConstants().white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                      margin: EdgeInsets.all(6),
                      height: 5,
                      width: 40,
                      color: ColorConstants().grey),
                ),
                Text(
                  "Campaign Status",
                  style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontWeight: FontWeight.w700,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Text(
                  'Specify the status by selecting the pin below',
                  style:
                      TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 44.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CompaignStatusIcons(
                      icon: ImageConstants().interestedMarker,
                      onTap: () {
                        setState(() {
                          markerStatus = 1;
                        });
                      },
                      color: ColorConstants().green,
                      text: 'Interested',
                    ),
                    CompaignStatusIcons(
                      icon: ImageConstants().notHomeMarker,
                      onTap: () {
                        setState(() {
                          markerStatus = 2;
                        });
                      },
                      color: ColorConstants().yellow,
                      text: 'Not Home',
                    ),
                    CompaignStatusIcons(
                      icon: ImageConstants().comeBackMarker,
                      onTap: () {
                        setState(() {
                          markerStatus = 3;
                        });
                      },
                      color: ColorConstants().orange,
                      text: 'Come Back',
                    ),
                    CompaignStatusIcons(
                      icon: ImageConstants().notInteredtedMarker,
                      onTap: () {
                        setState(() {
                          markerStatus = 4;
                        });
                      },
                      color: ColorConstants().red,
                      text: 'Not Interested',
                    ),
                    CompaignStatusIcons(
                      icon: ImageConstants().emptyPropertyMarket,
                      onTap: () {
                        setState(() {
                          markerStatus = 5;
                        });
                      },
                      color: ColorConstants().grey,
                      text: 'Empty Property',
                    ),
                  ],
                ),
              ],
            ),
          );
        })
        .closed
        .whenComplete(() {
          if (mounted) {
            setState(() {
              isMarkerSheet = false;
              _showPersistantBottomSheetCallBack = _showBottomSheet;
            });
          }
        });
  }

  displayBottomSheet(BuildContext context, data) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(left: 30, right: 31, top: 32),
        child: Container(
          width: 428.w,
          height: 390.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 5,
                    width: 35,
                    decoration: BoxDecoration(
                        color: ColorConstants().grey,
                        borderRadius: BorderRadius.circular(30)),
                  )
                ],
              ),
              SizedBox(
                height: 8.h,
              ),
              Text(
                data['territoryname'],
                style: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontWeight: FontWeight.w700,
                  fontSize: 18.sp,
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              Text(
                "Select the comeback date below",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      height: 20.h,
                      width: 172.w,
                      child: Text(
                        "Campaign Details",
                        style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp),
                      )),
                  Padding(
                    padding: EdgeInsets.only(left: 22.w),
                    child: Text(
                      data['created'],
                      style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontWeight: FontWeight.w500,
                          fontSize: 12.sp),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      height: 20.h,
                      width: 172.w,
                      child: Text(
                        "New Campaign",
                        style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp),
                      )),
                  SizedBox(
                    child: Padding(
                      padding: EdgeInsets.only(left: 93.w),
                      child: Text(
                        "30/02/2022",
                        style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                "Comback date",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 8.h,
              ),
              Container(
                height: 42.h,
                width: 365.w,
                child: TextFormField(
                  initialValue: DateTime.now().toString(),
                  readOnly: true,
                  onTap: () {
                    setState(() {
                      _selectDate(context);
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.calendar_today_outlined,
                      size: 20,
                      color: Colors.green,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.all(
                        Radius.circular(3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(3))),
                    hintText: 'Select Start Date',
                    contentPadding: EdgeInsets.only(left: 10.75.w, top: 10.h),
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 91.h,
              ),
              Container(
                width: 365.w,
                height: 48.h,
                child: MaterialButton(
                  highlightColor: Colors.green,
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      mapMarkerVisible = false;
                      _markers.clear();
                      _polygons.clear();
                      _polyLines.clear();
                    });
                    MapFunctions().sucessBottomSheet(context);
                  },
                  minWidth: double.infinity,
                  height: 54.h,
                  color: Color.fromRGBO(0, 146, 65, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    " Done",
                    style: TextStyle(color: Colors.white, fontSize: 20.sp),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future getTodolist() async {
    await FirebaseFirestore.instance.collection('users').get().then((value) {
      setState(() {
        _allUsers =
            List.from(value.docs.map((doc) => GetUsers.fromSnapshot(doc)));
      });
    });
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
                        controller: territortname,
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
                                _clearPolygons();

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
                                  dataListOfUserFroServer.clear();
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
                        items: ((_allUsers)).map((e) {
                          return MultiSelectItem<GetUsers>(
                              (e), e.fullname.toString());
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
                                print(isUpdate);
                                print(selectedTerritorries);
                                print(selectedUsers);

                                isUpdate == true
                                    ? dataUpdate = {
                                        "paths": data['paths'],
                                        "territoryname": data['territoryname'],
                                        "created": DateFormat("yyyy-MM-dd")
                                            .format(DateTime.now()),
                                        "assignees": jsonDecode(
                                            jsonEncode(selectedUsers)),
                                        'campaigns': selectedTerritorries,
                                        'setmarker': data['setmarker']
                                      }
                                    : dataSend = {
                                        "paths": path,
                                        "territoryname":
                                            territortname.value.text,
                                        "created": DateFormat("yyyy-MM-dd")
                                            .format(DateTime.now()),
                                        "assignees": jsonDecode(
                                            jsonEncode(selectedUsers)),
                                        'campaigns': selectedTerritorries!,
                                        'setmarker': {
                                          'lat': setMarker!.latitude,
                                          'lng': setMarker!.longitude
                                        }
                                      };

                                isUpdate == true
                                    ? FirebaseFunctions().updateItems(
                                        dataUpdate!,
                                        docsId,
                                        'territories',
                                        "Territory Update",
                                        "errorMsg")
                                    : FirebaseFunctions().addtems(
                                        dataSend!,
                                        'territories',
                                        "Terittory Added",
                                        "errorMsg");
                                _clearPolygons();

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
                    primary: Colors.white, shadowColor: Colors.transparent),
                onPressed: _toggleDrawing,
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

  _toggleDrawing() {
    maps = !maps;

    if (!_drawPolygonEnabled) {
      _clearPolygons();
    }
    setState(() => _drawPolygonEnabled = !_drawPolygonEnabled);
  }

  _onPanUpdate(DragUpdateDetails details) async {
    if (_clearDrawing) {
      _clearDrawing = false;
      _clearPolygons();
    }
    if (_drawPolygonEnabled) {
      late double x, y;
      if (Platform.isAndroid) {
        x = details.globalPosition.dx * 1.5;
        y = details.globalPosition.dy * 1.5;
      } else if (Platform.isIOS) {
        x = details.globalPosition.dx;
        y = details.globalPosition.dy;
      }
      dynamic xCoordinate = x.round();
      dynamic yCoordinate = y.round();
      if (_lastXCoordinate != null && _lastYCoordinate != null) {
        var distance = Math.sqrt(Math.pow(xCoordinate - _lastXCoordinate, 2) +
            Math.pow(yCoordinate - _lastYCoordinate, 2));
        if (distance > 80.0) return;
      }
      _lastXCoordinate = xCoordinate;
      _lastYCoordinate = yCoordinate;
      ScreenCoordinate screenCoordinate =
          ScreenCoordinate(x: xCoordinate, y: yCoordinate);
      final GoogleMapController controller = newGoogleMapController;
      LatLng latLng = await controller.getLatLng(screenCoordinate);
      try {
        setState(() {
          _userPolyLinesLatLngList.add(latLng);
        });
        _polyLines.removeWhere(
            (polyline) => polyline.polylineId.value == 'user_polyline');
        setState(() {
          _polyLines.add(
            Polyline(
              polylineId: PolylineId('user_polyline'),
              points: _userPolyLinesLatLngList,
              width: 2,
              color: Colors.red,
            ),
          );
        });
      } catch (e) {}
    }
  }

  _onPanEnd(DragEndDetails details) async {
    _lastXCoordinate = null;
    _lastYCoordinate = null;
    visibleRegion = (await newGoogleMapController.getVisibleRegion());
    setMarker = LatLng(
      (visibleRegion!.southwest.latitude + visibleRegion!.northeast.latitude) /
          2,
      (visibleRegion!.southwest.longitude +
              visibleRegion!.northeast.longitude) /
          2,
    );
    if (_drawPolygonEnabled) {
      _polygons
          .removeWhere((polygon) => polygon.polygonId.value == 'user_polygon');
      setState(() {
        _polygons.add(
          Polygon(
            polygonId:
                PolygonId("${_chars.codeUnitAt(_rnd.nextInt(_chars.length))}"),
            points: _userPolyLinesLatLngList,
            strokeWidth: 2,
            strokeColor: Colors.red,
            fillColor: Colors.red.withOpacity(0.2),
          ),
        );
      });

      _polygons.forEach((element) {
        var count = 0;
        for (var i = 0; i < element.points.length; i++) {
          path.add(({
            "lat": element.points[i].latitude,
            "lng": element.points[i].longitude
          }));
        }
      });
      setState(() {
        _markers.add(Marker(
            markerId:
                MarkerId("${_chars.codeUnitAt(_rnd.nextInt(_chars.length))}"),
            position: setMarker!,
            onTap: () {
              openDialog(null, null);
            },
            icon: myIcon!,
            visible: true));
        _clearDrawing = true;

        maps = !maps;
      });

      openDialog(null, null);

      _toggleDrawing();
      setState(() {
        isUpdate = false;
      });
    }
  }

  _clearPolygons() {
    setState(() {
      _markers.clear();
      _polyLines.clear();
      _polygons.clear();
      _userPolyLinesLatLngList.clear();
    });
  }

  getMarkerOnMap(int? markerStatus) {
    if (markerStatus == 1) {
      return interestedMarker;
    } else if (markerStatus == 2) {
      return notHomeMarker;
    } else if (markerStatus == 3) {
      return comeBackMarker;
    } else if (markerStatus == 4) {
      return notInteredtedMarker;
    } else if (markerStatus == 5) {
      return emptyPropertyMarket;
    }
  }
}
