import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CurrentLocation extends StatelessWidget {
  const CurrentLocation({
    Key? key,
    required this.onTap,
  }) : super(key: key);
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 339.w, right: 31.w, top: 630.h),
      child: Container(
        height: 58.h,
        width: 58.w,
        child: FloatingActionButton(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.sp)),
            onPressed: onTap,
            child: Icon(
              Icons.my_location_outlined,
              color: Colors.green,
            )),
      ),
    );
  }
}
