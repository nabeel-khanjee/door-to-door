import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onTap;
  const SearchBar({
    Key? key,
    required this.controller, required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 22.h,
        ),
        Padding(
          padding: EdgeInsets.only(left: 32.w, right: 31.w),
          child: Container(
            height: 48.h,
            width: 365.w,
            child: TextFormField(
              onEditingComplete: onTap,
              controller: controller,
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(3))),
                  hintText: "Search territory",
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 13.sp,
                      color: Color.fromRGBO(0, 0, 0, 1))),
            ),
          ),
        ),
        SizedBox(height: 21.h),
      ],
    );
  }
}
