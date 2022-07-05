import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MapMenuButton extends StatelessWidget {
  const MapMenuButton({
    Key? key,
    this.maps = false , required this.onTap,
  }) : super(key: key);
  final VoidCallback onTap;
  final bool maps;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 90.h, right: 31.w),
      child: Align(
        alignment: Alignment.topRight,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            color: maps ? Colors.green : Colors.white,
            height: 45.h,
            width: 45.w,
            child: Icon(
              Icons.menu,
              color: maps ? Colors.white : Colors.green,
            ),
          ),
        ),
      ),
    );
  }
}
