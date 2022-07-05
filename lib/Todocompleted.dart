// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:page/createnewtodo.dart';

// class TodocompleteTab extends StatefulWidget {
//   const TodocompleteTab({ Key? key }) : super(key: key);

//   @override
//   State<TodocompleteTab> createState() => _TodocompleteTabState();
// }

// class _TodocompleteTabState extends State<TodocompleteTab> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//       child: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.only(top: 25.h, left: 32.w, right: 31.w),
//             child: Container(
//               height: 44.h,
//               width: 365.w,
//               child: Text(
//                 "Complete the surveys near your current location in 500 metres",
//                 style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 10.h,
//           ),
//           Padding(
//             padding: EdgeInsets.only(left: 32.w, right: 296.w),
//             child: Row(
//               children: [
//                 Container(
//                   height: 33.h,
//                   width: 33.w,
//                   child: CircleAvatar(
//                       minRadius: 20,
//                       maxRadius: 40,
//                       backgroundImage: AssetImage("images/Avatar1.png")),
//                 ),
//                 Container(
//                   height: 33.h,
//                   width: 33.w,
//                   child: CircleAvatar(
//                       minRadius: 10,
//                       maxRadius: 20,
//                       backgroundImage: AssetImage("images/Avatar2.png")),
//                 ),
//                 Container(
//                   height: 33.h,
//                   width: 33.w,
//                   child: CircleAvatar(
//                       minRadius: 10,
//                       maxRadius: 20,
//                       backgroundImage: AssetImage("images/Avatar3.png")),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 69.h,
//           ),
//           Divider(
//             color: Colors.grey,
//             height: 5,
//             thickness: 1,
//             indent: 2,
//             endIndent: 2,
//           ),
//           SizedBox(
//             height: 25.h,
//           ),
//           Padding(
//             padding: EdgeInsets.only(left: 32.w, right: 31.w),
//             child: Container(
//               height: 44.h,
//               width: 365.w,
//               child: Text(
//                 "Complete the surveys near your current location in 500 metres",
//                 style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 10.h,
//           ),
//           Padding(
//             padding: EdgeInsets.only(left: 32.w, right: 296.w),
//             child: Row(
//               children: [
//                 Container(
//                   height: 33.h,
//                   width: 33.w,
//                   child: CircleAvatar(
//                       minRadius: 20,
//                       maxRadius: 40,
//                       backgroundImage: AssetImage("images/Avatar1.png")),
//                 ),
//                 Container(
//                   height: 33.h,
//                   width: 33.w,
//                   child: CircleAvatar(
//                       minRadius: 10,
//                       maxRadius: 20,
//                       backgroundImage: AssetImage("images/Avatar2.png")),
//                 ),
//                 Container(
//                   height: 33.h,
//                   width: 33.w,
//                   child: CircleAvatar(
//                       minRadius: 10,
//                       maxRadius: 20,
//                       backgroundImage: AssetImage("images/Avatar3.png")),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 69.h,
//           ),
//           Divider(
//             color: Colors.grey,
//             height: 5,
//             thickness: 1,
//             indent: 2,
//             endIndent: 2,
//           ),
//           SizedBox(
//             height: 25.h,
//           ),
//           Padding(
//             padding: EdgeInsets.only(left: 32.w, right: 31.w),
//             child: Container(
//               height: 44.h,
//               width: 365.w,
//               child: Text(
//                 "Complete the surveys near your current location in 500 metres",
//                 style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 10.h,
//           ),
//           Padding(
//             padding: EdgeInsets.only(left: 32.w, right: 296.w),
//             child: Row(
//               children: [
//                 Container(
//                   height: 33.h,
//                   width: 33.w,
//                   child: CircleAvatar(
//                       minRadius: 20,
//                       maxRadius: 40,
//                       backgroundImage: AssetImage("images/Avatar1.png")),
//                 ),
//                 Container(
//                   height: 33.h,
//                   width: 33.w,
//                   child: CircleAvatar(
//                       minRadius: 10,
//                       maxRadius: 20,
//                       backgroundImage: AssetImage("images/Avatar2.png")),
//                 ),
//                 Container(
//                   height: 33.h,
//                   width: 33.w,
//                   child: CircleAvatar(
//                       minRadius: 10,
//                       maxRadius: 20,
//                       backgroundImage: AssetImage("images/Avatar3.png")),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 69.h,
//           ),
//           Divider(
//             color: Colors.grey,
//             height: 5,
//             thickness: 1,
//             indent: 2,
//             endIndent: 2,
//           ),
//         ],
//       ),
//       ),
//        floatingActionButton: FloatingActionButton(
//           backgroundColor: Colors.green,
//           onPressed: () {
//             Navigator.push(context,
//                 MaterialPageRoute(builder: (context) => CreateNewToDo()));
//           },
//           child: Icon(
//             Icons.add_box_rounded,
//             // color: Colors.green,
//           ),
//         ),
//     );
//   }
// }