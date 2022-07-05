import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page/src/constants/string_constants.dart';

class CurrentlyViewing extends StatelessWidget {
  final String selectedTerritory;
  final VoidCallback onTap;
  const CurrentlyViewing({
    Key? key,
    required this.onTap, required this.selectedTerritory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Row(
        children: [
          GestureDetector(
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
              ],
            ),
          ),
          GestureDetector(
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  height: 64.h,
                  width: 218.w,
                  // color: Colors.white,
                  child: Center(
                      child: MaterialButton(
                    onPressed: onTap,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                            // data!=null?
                            selectedTerritory
                            // :
                            // StringConstants()
                            //     .noTerritoryCreated
                            ),
                        Icon(Icons.keyboard_arrow_down_outlined),
                      ],
                    ),
                  )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
