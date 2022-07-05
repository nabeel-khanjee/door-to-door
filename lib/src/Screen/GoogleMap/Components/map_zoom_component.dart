import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MapZoom extends StatelessWidget {
  final IconData iconData;
  final VoidCallback onTap;
  final double fromTop;
  const MapZoom({
    Key? key,
    required this.onTap,
    required this.iconData, required this.fromTop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 339.w, right: 31.w, top: fromTop),
      child: Container(
        height: 58.h,
        width: 58.w,
        child: FloatingActionButton(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.sp)),
            onPressed: onTap,
            child: Icon(
              iconData,
              color: Colors.green,
            )),
      ),
    );
  }
}
