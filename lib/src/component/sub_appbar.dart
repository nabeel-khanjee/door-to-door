
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page/src/constants/colors.dart';

class SubAppbar extends StatelessWidget {
  final String text;
  const SubAppbar({
    Key? key, required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Size.fromHeight(kToolbarHeight).height,
      color: ColorConstants().white,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
              color: Colors.black,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
