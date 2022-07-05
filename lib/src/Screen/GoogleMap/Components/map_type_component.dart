
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MapTYpe extends StatelessWidget {
  final VoidCallback onTap;
  const MapTYpe({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 340,
      // top: 50,
      right: 28,

      child: Container(
        height: 58.h,
        width: 58.w,
        child: FloatingActionButton(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.sp)),
            onPressed: onTap,
            child: Icon(
              Icons.person_pin,
              color: Colors.green,
            )),
      ),
    );
  }
}

