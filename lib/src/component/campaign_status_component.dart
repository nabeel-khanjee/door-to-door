import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompaignStatusIcons extends StatelessWidget {
  final String icon;
  final Color color;
  final String text;
  final VoidCallback onTap;
  const CompaignStatusIcons({
    Key? key,
    required this.color,
    required this.text,
    required this.onTap,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            child: Image(
              height: 30,
              image: AssetImage(icon)),
            onTap: onTap,
          ),
          Text(
            text,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 10.sp),
          ),
        ],
      ),
    );
  }
}
