
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomButtonComponent extends StatelessWidget {
  BottomButtonComponent({
    Key? key,
    required this.buttonColor,
    required this.textColor,
    required this.buttonText,
    this.icon,
    required this.onTap,
    this.paddingTop,
    this.paddingBottom,
    this.paddingRight,
    this.paddingLeft,
  }) : super(key: key);
  final Color buttonColor;
  final Color textColor;
  final String buttonText;
  double? paddingTop;
  double? paddingBottom;
  double? paddingRight;
  double? paddingLeft;

  IconData? icon;
  VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: paddingBottom ?? 50.h,
          left: paddingLeft ?? 32.w,
          right: paddingRight ?? 31.w,
          top: paddingTop ?? 0),
      child: MaterialButton(
        onPressed: onTap,
        minWidth: double.infinity,
        height: 54.h,
        color:buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon != null
                ? Icon(
                    icon,
                    color: textColor,
                  )
                : SizedBox(),
            Text(
              buttonText,
              style: TextStyle(color: textColor, fontSize: 20.sp),
            ),
          ],
        ),
      ),
    );
  }
}
