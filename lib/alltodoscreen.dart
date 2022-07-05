// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page/Deletetodo.dart';
import 'package:page/Gettododata.dart';
import 'package:page/createnewtodo.dart';
import 'package:intl/intl.dart';
// import 'dart:html';

dynamic data;
late DocumentSnapshot snapshot;

class Alltodos extends StatefulWidget {
  const Alltodos({Key? key}) : super(key: key);

  @override
  State<Alltodos> createState() => _AlltodosState();
}

class _AlltodosState extends State<Alltodos> {
  Map<String, dynamic>? editdata;
  User? user = FirebaseAuth.instance.currentUser;
  bool alltodos = true;

  List<Getdata> _toDoDataList = [];

  @override
  void initState() {
    super.initState();
    getTodolist();
  }

  //  FETCHING DATA
  Future getTodolist() async {
    final uid = user?.uid;

    await FirebaseFirestore.instance
        .collection('todo-list')
        // .where('user_uid', isEqualTo: uid)
        .get()
        .then((value) {
      setState(() {
        _toDoDataList =
            List.from(value.docs.map((doc) => (Getdata.fromSnapshot(doc))));
      });
    });

    // _toDoDataList =
    //     List.from(querySnapshot.docs.map((doc) => Getdata.fromSnapshot(doc)));

    // for (int i = 0; i < _toDoDataList.length; i++) {
    //   print(_toDoDataList[i].tododescription);
    // }
  }

  // void deltodo(int index) {
  //   setState(() {
  //     DeleteTodo().deletetoDo("${_toDoDataList[index].id}");
  //   });
  // }

  SingleChildScrollView todomethod(List<Getdata> _toDoDataList) {
    return SingleChildScrollView(
      child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _toDoDataList.length,
          itemBuilder: (BuildContext context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 25.h,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 32.w, right: 33.w),
                      child: Container(
                        height: 44.h,
                        width: 295.w,
                        child: Text(
                          // todo_description,
                          "${_toDoDataList[index].tododescription}",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 14.sp),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 1.w),
                      child: IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.green,
                        ),
                        onPressed: () {
                          editdata = {
                            "des":
                                _toDoDataList[index].tododescription ?? "dec1",
                            'date': _toDoDataList[index].duedate ?? "date1",
                            'title': _toDoDataList[index].todotitle ?? "title1",
                            'id': _toDoDataList[index].id ?? "id",
                            'user': jsonDecode(
                                _toDoDataList[index].user.toString()),
                          };
                          // print(editdata!['user']['fullname']);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CreateNewToDo(dataForEdit: editdata!)));
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 28.w),
                  child: Container(
                    // color: Colors.yellow,
                    height: 44.h,
                    width: 295.w,
                    child: Text(
                      DateFormat("dd-MM-yyyy").format(DateFormat("yyyy-MM-dd")
                          .parse(_toDoDataList[index].duedate)),
                      style: TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 14.sp),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 32.w, right: 31.w),
                  child: MaterialButton(
                    onPressed: () {
                      // deltodo(0);
                      // setState
                      DeleteTodo().deletetoDo("${_toDoDataList[index].id}");
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Alltodos()));
                    },
                    minWidth: double.infinity,
                    height: 55.h,
                    color: Color.fromRGBO(210, 47, 39, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      "Delete Task",
                      style: TextStyle(color: Colors.white, fontSize: 20.sp),
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
            );
          }),
    );
  }

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> toDocompleted() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('todo-list').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('Error = ${snapshot.error}');
          if (snapshot.hasData) {
            final docs = snapshot.data!.docs;
            return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: docs.length,
                itemBuilder: (BuildContext context, index) {
                  final Map<String, dynamic> data =
                      docs[index].data() as Map<String, dynamic>;

                  return Container(
                    child: Column(
                      children: [
                        if (data['status'] == 1)
                          Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 25.h, left: 32.w, right: 31.w),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // SubHeadingAlertBox(text: data['todo_title']),

                                      // SubHeadingAlertBox(text: data['due_date']),
                                    ]),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 25.h, left: 32.w, right: 31.w),
                                child: Container(
                                  height: 44.h,
                                  width: 365.w,
                                  child: Text(
                                    data['todo_description'],
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(left: 32.w, right: 296.w),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 33.h,
                                      width: 33.w,
                                      child: CircleAvatar(
                                          minRadius: 20,
                                          maxRadius: 40,
                                          backgroundImage:
                                              AssetImage("images/Avatar1.png")),
                                    ),
                                    Container(
                                      height: 33.h,
                                      width: 33.w,
                                      child: CircleAvatar(
                                          minRadius: 10,
                                          maxRadius: 20,
                                          backgroundImage:
                                              AssetImage("images/Avatar2.png")),
                                    ),
                                    Container(
                                      height: 33.h,
                                      width: 33.w,
                                      child: CircleAvatar(
                                          minRadius: 10,
                                          maxRadius: 20,
                                          backgroundImage:
                                              AssetImage("images/Avatar3.png")),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 69.h,
                              ),
                              Divider(
                                color: Colors.grey,
                                height: 5,
                                thickness: 1,
                                indent: 2,
                                endIndent: 2,
                              ),
                            ],
                          ),
                      ],
                    ),
                  );
                });
          }
          return CircularProgressIndicator();
        });
  }

  @override
  Widget build(BuildContext context) {
    // print(_toDoDataList);
    // getTodolist();

    return Container(
      height: 926.h,
      width: 428.w,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(left: 117.w, right: 89.w),
              child: Container(
                width: 138.w,
                height: 29.44.h,
                child: IconButton(
                  // Icons.arrow_back_ios_new_rounded
                  icon: Image.asset('images/appbar Vector.png'),
                  onPressed: () {},
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.notifications_none,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          alltodos = true;
                          // Todo();
                        });
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 64.h,
                            width: 214.w,
                            color: Colors.white,
                            child: Center(
                              child: Text(
                                "All Todos",
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        !alltodos ? Colors.grey : Colors.black),
                              ),
                            ),
                          ),
                          if (alltodos)
                            // todomethod(),
                            // Todo(),
                            Container(
                              margin: EdgeInsets.only(top: 1.h),
                              height: 3.h,
                              width: 214.w,
                              color: alltodos ? Colors.green : Colors.grey,
                            ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          alltodos = false;
                        });
                      },
                      child: Column(
                        children: [
                          Container(
                            color: Colors.white,
                            height: 64.h,
                            width: 214.w,
                            // color: Colors.white,
                            child: Center(
                              child: Text(
                                "completed",
                                style: TextStyle(
                                    color:
                                        !alltodos ? Colors.black : Colors.grey,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          if (!alltodos)
                            Container(
                              margin: EdgeInsets.only(top: 1.h),
                              height: 3.h,
                              width: 214.w,
                              color: !alltodos ? Colors.green : Colors.grey,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (alltodos) todomethod(_toDoDataList),
                if (!alltodos)
                  // TodocompleteTab(),
                  toDocompleted(),
                //  CreateNewToDo(),

                SizedBox(
                  height: 25.h,
                ),
                // toDocompleted(),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CreateNewToDo()));
          },
          child: Icon(
            Icons.add_box_rounded,
            // color: Colors.green,
          ),
        ),
      ),
    );
  }

  // String convertDate(Timestamp dateTime) {
  //   DateTime d = dateTime.toDate();
  //   return d.toString();
  // }
}
