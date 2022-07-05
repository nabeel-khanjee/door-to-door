import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MapMarkerSheet extends StatelessWidget {
  final VoidCallback onTap;
  const MapMarkerSheet({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 275,
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
            child: IconButton(
              onPressed: onTap,
              icon: Icon(
                Icons.pin_drop,
                color: Colors.green,
              ),
            )),
      ),
    );
  }
}
