import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBarForApplication extends StatelessWidget {
  const AppBarForApplication({
    Key? key,
    required this.leadingIcon,
    required this.actionIcon,
    required this.leadingCallback,
    required this.actionCallback, this.actionIconColor,
  }) : super(key: key);
  final IconData leadingIcon;
  final IconData actionIcon;
  final Color? actionIconColor;

  final VoidCallback leadingCallback;
  final VoidCallback actionCallback;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      leading: IconButton(
        icon: Icon(
          leadingIcon,
          color: Colors.black,
        ),
        onPressed: leadingCallback,
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(left: 117.w, right: 89.w),
          child: Container(
            width: 138.w,
            height: 29.44.h,
            child: Image.asset('images/appbar Vector.png'),
          ),
        ),
        IconButton(
          icon: Icon(
            actionIcon,
            color: actionIconColor??Colors.black,
          ),
          onPressed: actionCallback,
        ),
      ],
    );
  }
}
