// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GmapTerritory extends StatefulWidget {
  const GmapTerritory({Key? key}) : super(key: key);

  @override
  State<GmapTerritory> createState() => _GmapTerritoryState();
}

class _GmapTerritoryState extends State<GmapTerritory> {
  DateTime _date = DateTime.now();
  //  var myFormat = DateFormat('d-MM-yyyy');

  Future<Null> _selectDate(BuildContext context) async {
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
        // print(_date.toString());
      });
    }
  }

  final TextEditingController dateEdittingcotroller = TextEditingController();
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex =
      CameraPosition(target: LatLng(24.9008, 67.1681), zoom: 14.4746);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
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
        children: [
          GoogleMap(
            mapType: MapType.hybrid,
            myLocationButtonEnabled: true,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          // Container(child: displayBottomSheet(context),),
          FloatingActionButton(onPressed: () {
            displayBottomSheet(context);
          }),
        ],
      ),
      // bottomSheet: BottomSheetWidget(
      //   title: 'Territory 01'
      // ),
    );
  }

  sucessBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(left: 30, right: 31, top: 32),
        child: Container(
          width: 428.w,
          height: 267.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "👋 Success",
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
                'This campaign has been set to comeback status successfully. You can view this campaign in your todo list to check the comeback time anytime.',
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 63.h,
              ),
              Container(
                width: 365.w,
                height: 48.h,
                child: MaterialButton(
                  highlightColor: Colors.green,
                  onPressed: () {
                    Navigator.pop(context);
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

  displayBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      
      shape: RoundedRectangleBorder(
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
              Text(
                "Territory 01",
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
                children: [
                  Column(
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
                      SizedBox(
                        height: 8.h,
                      ),
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
                    ],
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  Column(
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                          height: 20.h,
                          width: 160.w,
                          child: Padding(
                            padding: EdgeInsets.only(left: 22.w),
                            child: Text(
                              "Campaign Starting From",
                              style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.sp),
                            ),
                          )),
                      SizedBox(
                        height: 8.h,
                      ),
                      Container(
                        height: 20.h,
                        width: 160.w,
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
                  controller: dateEdittingcotroller,
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
                    // (myFormat.format(_date)),
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
                    sucessBottomSheet();
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
}
