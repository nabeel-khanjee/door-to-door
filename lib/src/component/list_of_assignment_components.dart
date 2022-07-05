import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page/Gettododata.dart';
import 'package:intl/src/intl/date_format.dart';
import 'package:page/src/firebase/firebase_functions.dart';

class ListOfAssignment extends StatelessWidget {
  const ListOfAssignment({
    Key? key,
    required List<Getdata> toDoDataList,
    required this.isOverDue,
  })  : _toDoDataList = toDoDataList,
        super(key: key);

  final List<Getdata> _toDoDataList;
  final bool isOverDue;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> dataForUpdate;
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: _toDoDataList.length,
        itemBuilder: (BuildContext context, index) {
          return isOverDue
              ? DateTime.parse(_toDoDataList[index].duedate)
                      .isAfter(DateTime.now())
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 25.h,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 30.w, right: 28.w),
                              child: Container(
                                // color: Colors.red,
                                height: 44.h,
                                width: 249.w,
                                child: Text(
                                  // "Complete the surveys near your current location in 500 metres",
                                  "${_toDoDataList[index].tododescription}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.sp),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 6.w),
                              // color: Colors.yellow,
                              height: 44.h,
                              width: 95.w,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 12),
                                    child: Text(
                                      "Due Date",
                                      // DateFormat("dd-MM-yyyy").format(DateFormat("yyyy-MM-dd")
                                      //     .parse(_toDoDataList[index].duedate)),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.sp),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text(
                                        DateFormat("dd-MM-yyyy").format(
                                            DateFormat("yyyy-MM-dd").parse(
                                                _toDoDataList[index].duedate)),
                                        style: DateTime.parse(
                                                    _toDoDataList[index]
                                                        .duedate)
                                                .isAfter(DateTime.now())
                                            ? (TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 14.sp))
                                            : TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 14.sp)),
                                  ),
                                ],
                              ),
                            ),
                            // Padding(
                            //   padding: EdgeInsets.only(right: 1.w),
                            //   child: IconButton(
                            //     icon: Icon(
                            //       Icons.edit,
                            //       color: Colors.green,
                            //     ),
                            //     onPressed: () {
                            //       // editdata = {
                            //       //   "des":
                            //       //       _toDoDataList[index].tododescription ?? "dec1",
                            //       //   'date': _toDoDataList[index].duedate ?? "date1",
                            //       //   'title': _toDoDataList[index].todotitle ?? "title1",
                            //       //   'id': _toDoDataList[index].id ?? "id",
                            //       //   'user': jsonDecode(
                            //       //       _toDoDataList[index].user.toString()),
                            //       // };
                            //       // // print(editdata!['user']['fullname']);
                            //       // Navigator.push(
                            //       //     context,
                            //       //     MaterialPageRoute(
                            //       //         builder: (context) =>
                            //       //             CreateNewToDo(dataForEdit: editdata!)));
                            //     },
                            //   ),
                            // ),
                          ],
                        ),
                        // Padding(
                        //   padding: EdgeInsets.only(left: 28.w),
                        //   child: Container(
                        //     // color: Colors.yellow,
                        //     height: 44.h,
                        //     width: 295.w,
                        //     child: Text(
                        //       "Due Date",
                        //       // DateFormat("dd-MM-yyyy").format(DateFormat("yyyy-MM-dd")
                        //       //     .parse(_toDoDataList[index].duedate)),
                        //       style: TextStyle(
                        //           fontWeight: FontWeight.w400, fontSize: 14.sp),
                        //     ),
                        //   ),
                        // ),
                        SizedBox(
                          height: 32.h,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 32.w, right: 31.w),
                          child: MaterialButton(
                            onPressed: () {
                              print(_toDoDataList[0].toJson());
                              print(_toDoDataList[0].id);

                              dataForUpdate = {
                                "status": 1,
                                "id": _toDoDataList[index].id,
                                "todo_title": _toDoDataList[index].todotitle,
                                "todo_description":
                                    _toDoDataList[index].tododescription,
                                "due_date": _toDoDataList[index].duedate,
                                // "user": _toDoDataList[index].user,
                              };
                              FirebaseFunctions().updateItems(
                                  dataForUpdate,
                                  _toDoDataList[index].id!,
                                  'todo-list',
                                  "Data Upload Successfully",
                                  "Data Send Failed");
                              // print(_toDoDataList[0].toJson());
                            },
                            minWidth: double.infinity,
                            height: 55.h,
                            color: Color.fromRGBO(0, 146, 65, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              "Mark As Completed",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20.sp),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        Divider(
                          color: Colors.grey,
                          height: 5,
                          thickness: 1,
                          indent: 2,
                          endIndent: 2,
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                      ],
                    )
                  : Column()
              : DateTime.parse(_toDoDataList[index].duedate)
                      .isBefore(DateTime.now())
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 25.h,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 30.w, right: 28.w),
                              child: Container(
                                // color: Colors.red,
                                height: 44.h,
                                width: 249.w,
                                child: Text(
                                  // "Complete the surveys near your current location in 500 metres",
                                  "${_toDoDataList[index].tododescription}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.sp),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 6.w),
                              // color: Colors.yellow,
                              height: 44.h,
                              width: 95.w,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 12),
                                    child: Text(
                                      "Due Date",
                                      // DateFormat("dd-MM-yyyy").format(DateFormat("yyyy-MM-dd")
                                      //     .parse(_toDoDataList[index].duedate)),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.sp),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text(
                                        DateFormat("dd-MM-yyyy").format(
                                            DateFormat("yyyy-MM-dd").parse(
                                                _toDoDataList[index].duedate)),
                                        style: DateTime.parse(
                                                    _toDoDataList[index]
                                                        .duedate)
                                                .isAfter(DateTime.now())
                                            ? (TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 14.sp))
                                            : TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 14.sp)),
                                  ),
                                ],
                              ),
                            ),
                            // Padding(
                            //   padding: EdgeInsets.only(right: 1.w),
                            //   child: IconButton(
                            //     icon: Icon(
                            //       Icons.edit,
                            //       color: Colors.green,
                            //     ),
                            //     onPressed: () {
                            //       // editdata = {
                            //       //   "des":
                            //       //       _toDoDataList[index].tododescription ?? "dec1",
                            //       //   'date': _toDoDataList[index].duedate ?? "date1",
                            //       //   'title': _toDoDataList[index].todotitle ?? "title1",
                            //       //   'id': _toDoDataList[index].id ?? "id",
                            //       //   'user': jsonDecode(
                            //       //       _toDoDataList[index].user.toString()),
                            //       // };
                            //       // // print(editdata!['user']['fullname']);
                            //       // Navigator.push(
                            //       //     context,
                            //       //     MaterialPageRoute(
                            //       //         builder: (context) =>
                            //       //             CreateNewToDo(dataForEdit: editdata!)));
                            //     },
                            //   ),
                            // ),
                          ],
                        ),
                        // Padding(
                        //   padding: EdgeInsets.only(left: 28.w),
                        //   child: Container(
                        //     // color: Colors.yellow,
                        //     height: 44.h,
                        //     width: 295.w,
                        //     child: Text(
                        //       "Due Date",
                        //       // DateFormat("dd-MM-yyyy").format(DateFormat("yyyy-MM-dd")
                        //       //     .parse(_toDoDataList[index].duedate)),
                        //       style: TextStyle(
                        //           fontWeight: FontWeight.w400, fontSize: 14.sp),
                        //     ),
                        //   ),
                        // ),
                        SizedBox(
                          height: 32.h,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 32.w, right: 31.w),
                          child: MaterialButton(
                            onPressed: () {
                              print(_toDoDataList[0].toJson());
                              print(_toDoDataList[0].id);

                              dataForUpdate = {
                                "status": 1,
                                "id": _toDoDataList[index].id,
                                "todo_title": _toDoDataList[index].todotitle,
                                "todo_description":
                                    _toDoDataList[index].tododescription,
                                "due_date": _toDoDataList[index].duedate,
                                // "user": _toDoDataList[index].user,
                              };
                              FirebaseFunctions().updateItems(
                                  dataForUpdate,
                                  _toDoDataList[index].id!,
                                  'todo-list',
                                  "Data Upload Successfully",
                                  "Data Send Failed");
                              // print(_toDoDataList[0].toJson());
                            },
                            minWidth: double.infinity,
                            height: 55.h,
                            color: Color.fromRGBO(0, 146, 65, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              "Mark As Completed",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20.sp),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        Divider(
                          color: Colors.grey,
                          height: 5,
                          thickness: 1,
                          indent: 2,
                          endIndent: 2,
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                      ],
                    )
                  : Column();
        });
  }
}
