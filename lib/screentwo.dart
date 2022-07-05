// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:page/auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Secondscreen extends StatefulWidget {
  const Secondscreen({Key? key}) : super(key: key);

  @override
  State<Secondscreen> createState() => _SecondscreenState();
}

class _SecondscreenState extends State<Secondscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: 926.h,
          padding: EdgeInsets.only(top: 155.h),
          child: Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                Image.asset("images/Vectorr.png"),
                SizedBox(
                  height: 15.h,
                ),
                Text(
                  "DOOR 2 DOOR",
                  style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w800),
                ),
                Text(
                  "Experience the Power of Door to door",
                  style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 0.6),
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(
                  height: 321.sp,
                ),
                Padding(
                  padding:  EdgeInsets.only(left: 32.w, right: 32.w),
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => signup(sup: true)));
                    },
                    minWidth: double.infinity,
                    height: 52,
                    color: Color.fromRGBO(0, 146, 65, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 15.h, bottom: 15.h, left: 10.w, right: 10.w),
                      child: Text(
                        "Sign up",
                        style: TextStyle(color: Colors.white, fontSize: 20.sp),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  "or",
                  style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 0.6),
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding:  EdgeInsets.only(left: 32.w, right: 32.w),
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => signup(sup: false)));
                    },
                    // minWidth: ,
                    minWidth: double.infinity,
                    height: 52,
                    // color: Color.fromRGBO(0, 146, 65, 1),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Color.fromRGBO(0, 146, 65, 1)),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 15.h, bottom: 15.h, left: 10.w, right: 10.w),
                      child: Text(
                        "Sign in",
                        style: TextStyle(
                            color: Color.fromRGBO(0, 146, 65, 1), fontSize: 20.sp),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
