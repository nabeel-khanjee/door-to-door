import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';

class MapFunctions {
  
   Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print("Error of current location" + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }
  
    sucessBottomSheet(context) {
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
                    "Done",
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