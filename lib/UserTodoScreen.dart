import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page/Gettododata.dart';
import 'package:intl/intl.dart';
import 'package:page/src/component/app_bar_component.dart';
import 'package:page/src/component/list_of_assignment_components.dart';
import 'package:page/src/component/tab_bar_component.dart';
import 'package:shared_preferences/shared_preferences.dart';

// dynamic data;
late DocumentSnapshot snapshot;

class UserTodoScreen extends StatefulWidget {
  const UserTodoScreen({Key? key}) : super(key: key);

  @override
  State<UserTodoScreen> createState() => _UserTodoScreenState();
}

class _UserTodoScreenState extends State<UserTodoScreen> {
  String currentUserId = "";

  Map<String, dynamic>? editdata;
  User? user = FirebaseAuth.instance.currentUser;
  bool alltodos = true;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  List<Getdata> _toDoDataList = [];

  @override
  void initState() {
    super.initState();
    getUserIdfromLocal();
  }

  getUserIdfromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    getTodolist(
        jsonDecode(prefs.getString("user").toString())["uid"].toString());
  }

  //  FETCHING DATA ACTIVE
  Future getTodolist(String id) async {
    await FirebaseFirestore.instance
        .collection('todo-list')
        .where('user.id', isEqualTo: id)
        .where('status', isEqualTo: 0)
        .get()
        .then((value) {
      setState(() {
        _toDoDataList =
            List.from(value.docs.map((doc) => (Getdata.fromSnapshot(doc))));
      });
    }).catchError((onError) => Fluttertoast.showToast(
            backgroundColor: Colors.green, msg: onError));
  }

  bool firstTab = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBarForApplication(
          actionCallback: () {},
          leadingCallback: () {},
          actionIcon: Icons.notifications_outlined,
          leadingIcon: Icons.arrow_back_ios,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TabBarComponent(
              onFirstTab: () {
                setState(() {
                  firstTab = true;
                  // Todo();
                });
              },
              onSecondTab: () {
                setState(() {
                  firstTab = false;
                  // Todo();
                });
              },
              selectedState: firstTab,
              firstField: "Current Assignment",
              secondField: 'Overdue',
            ),
            if (firstTab)
              ListOfAssignment(toDoDataList: _toDoDataList, isOverDue: false),
            if (!firstTab)
              ListOfAssignment(
                toDoDataList: _toDoDataList,
                isOverDue: true,
              ),
          ],
        ),
      ),
    );
  }
}
