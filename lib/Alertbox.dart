import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GetUsers {
  String? id;
  String? fullname;

  GetUsers();
  Map<String, dynamic> toJson() => {'id': id, 'fullname': fullname};

  GetUsers.fromSnapshot(snapshot)
      : id = snapshot.id,
        fullname = snapshot.data()['fullname'];
}






class Alertbox extends StatefulWidget {
  const Alertbox({ Key? key }) : super(key: key);

  @override
  State<Alertbox> createState() => AlertboxState();
}

class AlertboxState extends State<Alertbox> {


    List<GetUsers> _allUsers = [];

  String? selectedCarType;


   @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
            insetPadding: EdgeInsets.fromLTRB(26, 0, 26, 0),
            title: Text(
              "Create New Territory",
              style: TextStyle(color: Colors.black, fontSize: 18.sp),
            ),
            content: Text(
              "Enter details here to create new territory",
              style: TextStyle(color: Colors.grey, fontSize: 12.sp),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 18.h),
                child: Container(
                  width: 305.w,
                  height: 22.h,
                  child: Text(
                    "Assign Territory To",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp),
                  ),
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.w, right: 20.w),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  height: 42.h,
                  width: 323.w,
                  child: DropdownButton(
                    focusColor: Colors.grey,
                    borderRadius: BorderRadius.all(
                      Radius.circular(3),
                    ),
                    dropdownColor: Colors.white,
                    alignment: AlignmentDirectional.center,
                    icon: Padding(
                      padding: EdgeInsets.only(
                        left: 170.w,
                      ),
                      child: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                    ),
                    iconSize: 20,
                    hint: Padding(
                      padding: EdgeInsets.only(
                          left: 8.0.w, right: 3.w, top: 8.h, bottom: 8.h),
                      child: Text(
                        'Select Assigned',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    value: selectedCarType,
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
                                right: 3.w, left: 8.w, top: 8.h, bottom: 8.h),
                            child: Text(
                              "${car.fullname}",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          value: "${car.id}",
                        );
                      },
                    ).toList(),
                  ),
                ),
              ),
              SizedBox(height: 25.h),
              Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: Container(
                  width: 305.w,
                  height: 22.h,
                  child: Text(
                    "Assign Campaign",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.only(left: 20.w, right: 20.w),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  height: 42.h,
                  width: 323.w,
                  child: DropdownButton(
                    focusColor: Colors.grey,
                    borderRadius: BorderRadius.all(
                      Radius.circular(3),
                    ),
                    dropdownColor: Colors.white,
                    alignment: AlignmentDirectional.center,
                    icon: Padding(
                      padding: EdgeInsets.only(
                        left: 170.w,
                      ),
                      child: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                    ),
                    iconSize: 20,
                    hint: Padding(
                      padding: EdgeInsets.only(
                          left: 8.0.w, right: 3.w, top: 8.h, bottom: 8.h),
                      child: Text(
                        'Select Assigned',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    value: selectedCarType,
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
                                right: 3.w, left: 8.w, top: 8.h, bottom: 8.h),
                            child: Text(
                              "${car.fullname}",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          value: "${car.id}",
                        );
                      },
                    ).toList(),
                  ),
                ),
              ),
              SizedBox(
                height: 35.h,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 23.w,
                  right: 1.w,
                ),
                child: Row(
                  children: [
                    Container(
                        width: 145.w,
                        height: 42.h,
                        child: ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(primary: Colors.grey),
                            onPressed: () {},
                            child: Text("Back"))),
                    SizedBox(
                      width: 10.w,
                    ),
                    Container(
                        width: 145.w,
                        height: 42.h,
                        child: ElevatedButton(
                            onPressed: () {}, child: Text("Next"))),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
            ],
          );
  }
}