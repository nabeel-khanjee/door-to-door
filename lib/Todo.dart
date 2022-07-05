// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:page/createnewtodo.dart';

// class Todo extends StatefulWidget {
//   const Todo({Key? key}) : super(key: key);

//   @override
//   State<Todo> createState() => _TodoState();
// }

// class _TodoState extends State<Todo> {
//   // bool alltask = true;
//   int _currentindex = 0;
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Container(
//         height: 926.h,
//         width: 428.w,
//         child: Scaffold(
//           backgroundColor: Colors.white,
//           body: todomethod(),
//         ),
//       ),
      
//     );
//   }
//   SingleChildScrollView todomethod() {
//     return SingleChildScrollView(
//           child: Container(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
           
//                 SizedBox(
//                   height: 25.h,
//                 ),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.only(left: 32.w, right: 40.w),
//                       child: Container(
//                         height: 44.h,
//                         width: 295.w,
//                         child: Text(
//                           "Complete the surveys near your current location in 500 metres",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w400, fontSize: 14.sp),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(right: 4.w),
//                       child: Icon(
//                         Icons.edit,
//                         color: Colors.green,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(left: 28.w),
//                   child: Container(
//                     // color: Colors.yellow,
//                     height: 44.h,
//                     width: 295.w,
//                     child: Text(
//                       " Due Date",
//                       style: TextStyle(
//                           fontWeight: FontWeight.w400, fontSize: 14.sp),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 25.h,
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(left: 32.w, right: 31.w),
//                   child: MaterialButton(
//                     onPressed: () {},
//                     minWidth: double.infinity,
//                     height: 55.h,
//                     color: Color.fromRGBO(210, 47, 39, 1),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     child: Text(
//                       "Delete Task",
//                       style: TextStyle(color: Colors.white, fontSize: 20.sp),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 30.h,
//                 ),
//                 Divider(
//                   color: Colors.grey,
//                   height: 5,
//                   thickness: 1,
//                   indent: 2,
//                   endIndent: 2,
//                 ),
//                 SizedBox(
//                   height: 25.h,
//                 ),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.only(left: 32.w, right: 40.w),
//                       child: Container(
//                         height: 44.h,
//                         width: 295.w,
//                         child: Text(
//                           "Complete the surveys near your current location in 500 metres",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w400, fontSize: 14),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(right: 4.w),
//                       child: Icon(
//                         Icons.edit,
//                         color: Colors.green,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(left: 28.w),
//                   child: Container(
//                     // color: Colors.yellow,
//                     height: 44.h,
//                     width: 295.w,
//                     child: Text(
//                       " Due Date",
//                       style: TextStyle(
//                           fontWeight: FontWeight.w400, fontSize: 14.sp),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 25.h,
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(left: 32.w, right: 31.w),
//                   child: MaterialButton(
//                     onPressed: () {},
//                     minWidth: double.infinity,
//                     height: 55.h,
//                     color: Color.fromRGBO(210, 47, 39, 1),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     child: Text(
//                       "Delete Task",
//                       style: TextStyle(color: Colors.white, fontSize: 20.sp),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 30.h,
//                 ),
//                 Divider(
//                   color: Colors.grey,
//                   height: 5,
//                   thickness: 1,
//                   indent: 2,
//                   endIndent: 2,
//                 ),
//                 SizedBox(
//                   height: 25.h,
//                 ),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.only(left: 32.w, right: 40.w),
//                       child: Container(
//                         height: 44.h,
//                         width: 295.w,
//                         child: Text(
//                           "Complete the surveys near your current location in 500 metres",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w400, fontSize: 14.sp),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(right: 4.w),
//                       child: Icon(
//                         Icons.edit,
//                         color: Colors.green,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(left: 28.w),
//                   child: Container(
//                     // color: Colors.yellow,
//                     height: 44.h,
//                     width: 295.w,
//                     child: Text(
//                       " Due Date",
//                       style: TextStyle(
//                           fontWeight: FontWeight.w400, fontSize: 14.sp),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 22.h,
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(left: 32.w, right: 31.w),
//                   child: MaterialButton(
//                     onPressed: () {},
//                     minWidth: double.infinity,
//                     height: 55.h,
//                     color: Color.fromRGBO(210, 47, 39, 1),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     child: Text(
//                       "Delete Task",
//                       style: TextStyle(color: Colors.white, fontSize: 20.sp),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 15.h,
//                 ),
//               ],
//             ),
//           ),
//         );
//   }
// }
