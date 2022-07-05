// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page/Navbar.dart';
import 'package:intl/intl.dart';
import 'package:page/alltodoscreen.dart';

class GetUsers {
  String? id;
  String? fullName;

  GetUsers();
  Map<String, dynamic> toJson() => {'id': id, 'fullname': fullName};

  GetUsers.fromSnapshot(snapshot)
      : id = snapshot.id,
        fullName = snapshot.data()['fullname'];
}

class CreateTodo {
  // String? id;
  String? todotitle;
  String? tododescription;
  String? user;
  String? duedate;
}

class CreateNewToDo extends StatefulWidget {
  CreateNewToDo({Key? key, this.dataForEdit}) : super(key: key);
  final Map<String, dynamic>? dataForEdit;
  Map<String, dynamic> dataadd = {'': ""};

  @override
  State<CreateNewToDo> createState() =>
      _CreateNewToDoState(dataForEdit ?? dataadd);
}

class _CreateNewToDoState extends State<CreateNewToDo> {
  final Map<String, dynamic> dataForEdit;
  bool isEditScreen = false;
  void asd() {
    if (dataForEdit['user'] != null) {
      setState(() {
        isEditScreen = true;
      });
    } else {
      setState(() {
        isEditScreen = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    asd();
    getTodolist();
  }

  DateTime _date = DateTime.now();
  @override

  // Timestamp mytimestamp = Timestamp.fromDate(_date);
  // DateTime mydatetime = mytimestamp.toDate();
  var myFormat = DateFormat('d-MM-yyyy');

  _CreateNewToDoState(this.dataForEdit);

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? _datepicker = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
      initialDatePickerMode: DatePickerMode.day,
    );
    if (_datepicker != null && _datepicker != _date) {
      setState(() {
        _date = _datepicker;
        // print(_date.toString());
      });
    }
  }

  // Todo Text Controllers
  final TextEditingController assignuserscontroller = TextEditingController();
  final TextEditingController dateEdittingcotroller = TextEditingController();
  final TextEditingController todoEdittingcontroller = TextEditingController();
  final TextEditingController descriptionEdittingcontroller =
      TextEditingController();

  //signup and saving user info

  void todoer() async {
    FirebaseFirestore tb = FirebaseFirestore.instance;

    String todo_duedate = DateFormat("yyyy-MM-dd").format(_date);

    final user_index =
        _allUsers.indexWhere((element) => element.id == selectedCarType);

    tb.collection("todo-list").add({
      "todo_title": todoEdittingcontroller.text,
      "todo_description": descriptionEdittingcontroller.text,
      "user": _allUsers[user_index].toJson(),
      "due_date": todo_duedate,
      "status": 0
    });

    Navigator.push(context, MaterialPageRoute(builder: (context) => NavBar()));
  }

  List<GetUsers> _allUsers = [];

  Future getTodolist() async {
    await FirebaseFirestore.instance.collection('users').get().then((value) {
      // print(value.docs.first.id);
      setState(() {
        _allUsers =
            List.from(value.docs.map((doc) => GetUsers.fromSnapshot(doc)));
      });
    });
  }

  //Dropdownlist
  List<String> carTypesList = [];
  String? selectedCarType;

  final _formkey = GlobalKey<FormState>();

  gotonav() {
    if (_formkey.currentState!.validate()) {
      todoer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 926.h,
      // width: 428.w,
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
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => NavBar()));
            },
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
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: 32.w, right: 114.w, top: 27.5.h, bottom: 12.5.h),
                    child: Container(
                      height: 18.h,
                      width: 282.w,
                      child: Text(
                        !isEditScreen ? "Add New Todo" : "Update Todo",
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  Container(
                    height: 16.h,
                    width: 365.w,
                    child: Text(
                      !isEditScreen
                          ? "Enter fields here to create new todo"
                          : "Enter fields here to update todo",
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey),
                    ),
                  ),
                  SizedBox(height: 35.h),
                  Container(
                    height: 22.h,
                    width: 365.w,
                    child: Text(
                      "Todo",
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 32.w, right: 31.w),
                    child: Container(
                      height: 42.h,
                      width: 365.w,
                      child: TextFormField(
                        // initialValue: dataForEdit["title"],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "field is required";
                          }
                          return null;
                        },
                        controller: todoEdittingcontroller,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.all(
                                Radius.circular(3),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(3))),
                            hintText: dataForEdit['title'] != null
                                ? dataForEdit['title']
                                : "Enter todo Name",
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 13.sp,
                              color: Color.fromRGBO(0, 0, 0, 1),
                            )),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 35.h,
                  ),
                  Container(
                    height: 22.h,
                    width: 365.w,
                    child: Text(
                      "Todo Description",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(0, 0, 0, 1),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 11.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 32.w, right: 31.w),
                    child: Container(
                      height: 88.h,
                      width: 365.w,
                      child: TextFormField(
                        controller: descriptionEdittingcontroller,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Field is required";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.all(
                                Radius.circular(3),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(3))),
                            hintText: dataForEdit['des'] != null
                                ? dataForEdit['des']
                                : "Enter todo descriptio",
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 13.sp,
                                color: Color.fromRGBO(0, 0, 0, 1))),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 33.h,
                  ),
                  Container(
                    height: 22.h,
                    width: 365.w,
                    child: Text(
                      "Assign Todo",
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  isEditScreen
                      ? Padding(
                          padding: EdgeInsets.only(left: 22.w, right: 18.w),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                              ),
                            ),
                            height: 42.h,
                            width: 365.w,
                            child: DropdownButton(
                              focusColor: Colors.grey,
                              borderRadius: BorderRadius.all(
                                Radius.circular(3),
                              ),
                              dropdownColor: Colors.white,
                              alignment: AlignmentDirectional.center,
                              icon: Padding(
                                padding: EdgeInsets.only(
                                  left: 190.w,
                                ),
                                child: Icon(
                                  Icons.arrow_drop_down,
                                ),
                              ),
                              iconSize: 22,
                              hint: Padding(
                                padding: EdgeInsets.only(
                                    left: 5.0.w,
                                    right: 8.w,
                                    top: 8.h,
                                    bottom: 8.h),
                                child: Text(
                                  'Select Assignee',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              value: dataForEdit['user']['id'],
                              onChanged: (newValue) {
                                setState(
                                  () {
                                    selectedCarType = newValue.toString();
                                  },
                                );
                              },
                              items: _allUsers.map(
                                (car) {
                                  return DropdownMenuItem(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          right: 8.w,
                                          left: 8.w,
                                          top: 8.h,
                                          bottom: 8.h),
                                      child: Text(
                                        "${car.fullName}",
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    value: car.id,
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.only(left: 22.w, right: 18.w),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                              ),
                            ),
                            height: 42.h,
                            width: 365.w,
                            child: DropdownButton(
                              focusColor: Colors.grey,
                              borderRadius: BorderRadius.all(
                                Radius.circular(3),
                              ),
                              dropdownColor: Colors.white,
                              alignment: AlignmentDirectional.center,
                              icon: Padding(
                                padding: EdgeInsets.only(
                                  left: 190.w,
                                ),
                                child: Icon(
                                  Icons.arrow_drop_down,
                                ),
                              ),
                              iconSize: 22,
                              hint: Padding(
                                padding: EdgeInsets.only(
                                    left: 5.0.w,
                                    right: 8.w,
                                    top: 8.h,
                                    bottom: 8.h),
                                child: Text(
                                  'Select Assignee',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              onChanged: (newValue) {
                                setState(
                                  () {
                                    selectedCarType = newValue.toString();
                                  },
                                );
                              },
                              items: _allUsers.map(
                                (car) {
                                  return DropdownMenuItem(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          right: 8.w,
                                          left: 8.w,
                                          top: 8.h,
                                          bottom: 8.h),
                                      child: Text(
                                        "${car.fullName}",
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    value: car.id,
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                        ),
                  SizedBox(
                    height: 35.h,
                  ),
                  Container(
                    height: 22.h,
                    width: 365.w,
                    child: Text(
                      "Due Date",
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 32.w, right: 31.w),
                    child: Container(
                      height: 42.h,
                      width: 365.w,
                      child: TextFormField(
                        controller: dateEdittingcotroller,
                        readOnly: true,
                        onTap: () {
                          setState(() {
                            _selectDate(context);
                          });
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.calendar_today_outlined,
                            size: 20,
                            color: Colors.green,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.all(
                              Radius.circular(3),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3))),
                          hintText: dataForEdit['date'] != null
                              ? dataForEdit['date']
                              : (myFormat.format(_date)),
                          contentPadding:
                              EdgeInsets.only(left: 10.75.w, top: 10.h),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 90.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 32.w, right: 31.w),
                    child: MaterialButton(
                      onPressed: () {
                        gotonav();
                      },
                      minWidth: double.infinity,
                      height: 54.h,
                      color: Color.fromRGBO(0, 146, 65, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        !isEditScreen ? "Create Todo" : "Update Todo",
                        style: TextStyle(color: Colors.white, fontSize: 20.sp),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 42.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
