import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TabBarComponent extends StatefulWidget {
  TabBarComponent(
      {Key? key,
      required this.firstField,
      required this.onFirstTab,
      required this.onSecondTab,
      required this.secondField,  this.selectedState=true})
      : super(key: key);
  final String firstField;
  final String secondField;
  final VoidCallback onFirstTab;
  final VoidCallback onSecondTab;
   bool selectedState;

  @override
  State<TabBarComponent> createState() => _TabBarComponentState();
}

class _TabBarComponentState extends State<TabBarComponent> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: widget.onFirstTab,
          child: Column(
            children: [
              Container(
                height: 64.h,
                width: 214.w,
                color: Colors.white,
                child: Center(
                  child: Text(
                    widget.firstField,
                    style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: widget.selectedState ? Colors.grey : Colors.black),
                  ),
                ),
              ),
              if (widget.selectedState)
                // todomethod(),
                // Todo(),
                Container(
                  margin: EdgeInsets.only(top: 1.h),
                  height: 3.h,
                  width: 214.w,
                  color: widget.selectedState ? Colors.green : Colors.grey,
                ),
            ],
          ),
        ),
        GestureDetector(
          onTap: widget.onSecondTab,
          child: Column(
            children: [
              Container(
                color: Colors.white,
                height: 64.h,
                width: 214.w,
                // color: Colors.white,
                child: Center(
                  child: Text(
                    widget.secondField,
                    style: TextStyle(
                        color: !widget.selectedState ? Colors.black : Colors.grey,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              if (!widget.selectedState)
                Container(
                  margin: EdgeInsets.only(top: 1.h),
                  height: 3.h,
                  width: 214.w,
                  color: !widget.  selectedState ? Colors.green : Colors.grey,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
