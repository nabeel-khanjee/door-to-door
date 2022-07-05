// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CampaignDetails extends StatefulWidget {
  const CampaignDetails({Key? key}) : super(key: key);

  @override
  State<CampaignDetails> createState() => _CampaignDetailsState();
}

class _CampaignDetailsState extends State<CampaignDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 32.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 32.w, right: 31.w),
            child: Container(
              height: 21.h,
              width: 365,
              child: Text(
                "Campaign Details",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.sp),
              ),
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 32.w, right: 31.w),
            child: Container(
              height: 21.h,
              width: 365,
              child: Text(
                "Answer the follwoing question to start the campaign",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.sp),
              ),
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 35.w, right: 29.w),
            child: Container(
              color: Colors.blue,
              height: 44.h,
              width: 340.w,
              child: Row(
                children: [
                  Column(
                    children: [
                      Container(
                          height: 20.h,
                          width: 160.w,
                          child: Text(
                            "Campaign Duration",
                            style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontWeight: FontWeight.w500,
                                fontSize: 12.sp),
                          )),
                      SizedBox(
                        height: 8.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 60),
                        child: Container(
                            child: Text(
                          "22/05/2022 - 28/05/2022",
                          style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontWeight: FontWeight.w400,
                              fontSize: 12.sp),
                        )),
                      ),
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
            ),
          ),
        ],
      ),
    );
  }
}
