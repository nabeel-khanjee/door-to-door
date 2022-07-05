// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, no_logic_in_create_state, camel_case_types

// import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page/Navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:page/UserScreenNav.dart';
import 'package:page/alltodoscreen.dart';
import 'package:page/src/Screen/GoogleMap/app_google_map.dart';
import 'package:shared_preferences/shared_preferences.dart';

class signup extends StatefulWidget {
  final bool sup;
  const signup({Key? key, required this.sup}) : super(key: key);

  @override
  State<signup> createState() => _signupState(sup);
}

class _signupState extends State<signup> {
  User? user = FirebaseAuth.instance.currentUser;
  final gloablkey = GlobalKey<ScaffoldState>();

  void validation_of_form() {
    if (fullnameEdittingcontroller.text.length < 3) {
      Fluttertoast.showToast(msg: "name must be atleast 3 characters");
    } else if (!emailEdittingcontroller.text.contains("@")) {
      Fluttertoast.showToast(msg: "Email is not valid !");
    } else if (passwordEdittingcontroller.text.length < 6) {
      Fluttertoast.showToast(msg: "Password should be atleast 6 characters");
    } else {
      usersignup(gloablkey);
      Fluttertoast.showToast(msg: "Successfully Sign Up");
    }
  }

  bool sup;

  _signupState(this.sup);
  bool loginFail = false;
  String loginFailText = '';
  //  TextEditingController choosepasswordEdittingcontroller =
  //     TextEditingController();
  //signup controllers
  TextEditingController emailEdittingcontroller = TextEditingController();
  TextEditingController passwordEdittingcontroller = TextEditingController();
  TextEditingController fullnameEdittingcontroller = TextEditingController();

  //signin controllers
  TextEditingController semailEdittingcontroller = TextEditingController();
  TextEditingController spasswordEdittingcontroller = TextEditingController();
  TextEditingController sfullnameEdittingcontroller = TextEditingController();

  //signup and saving user info
  void usersignup(globalkey) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;

    final String fullname = fullnameEdittingcontroller.text;
    final String email = emailEdittingcontroller.text;
    final String password = passwordEdittingcontroller.text;

    try {
      final UserCredential x = (await auth.createUserWithEmailAndPassword(
          email: email, password: password));
      db
          .collection("users")
          .doc(x.user?.uid)
          .set({"email": email, "fullname": fullname, "USERS": User});

      print("user is registered");
    } catch (e) {
      print("error");
    }
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => NavBar()));
  }

  //functionality for sign in
  void usersignin(gloablkey) async {
    // final gloablkey = GlobalKey<ScaffoldState>();

    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;
    final String email = semailEdittingcontroller.text;
    final String password = spasswordEdittingcontroller.text;

    // obtain shared preferences
    final prefs = await SharedPreferences.getInstance();
    // var u = {user: {'uid': ''}};
    await auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then(
      (user) {
        return db
            .collection("users")
            .doc(user.user?.uid)
            .get()
            .then<dynamic>((DocumentSnapshot snapshot) async {
          Object u = {
            'uid': user.user?.uid,
            'fullname': jsonDecode(jsonEncode(snapshot.data()))['fullname'],
            'email': jsonDecode(jsonEncode(snapshot.data()))['email']
          };

          prefs.setString("user", jsonEncode(u));

          // u = jsonDecode(jsonEncode(snapshot.data()));

          if (jsonDecode(jsonEncode(snapshot.data()))['role'] == "Admin") {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => NavBar()));
          } else {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => UserScreenNav(
                      currentScreen: AppGoogleMap(
                        user: 1,
                      ),
                      currentTab: 0,
                    )));
          }
        });
      },
    ).catchError((e) {
      print(e);
      setState(() {
        loginFailText = "Email / Password is invalid";
        loginFail = true;
      });
    });

    // final DocumentSnapshot snapshot =
    //     await db.collection("users").doc(user.user?.uid).get();
    // final data = snapshot.data();

    // print(prefs.getString("user"));
    // print(jsonDecode(prefs.getString("user").toString())['uid']);

    //check if data recieve from firebase
  }

  final _formkey = GlobalKey<FormState>();
  loggedin(globalkey) {
    if (_formkey.currentState!.validate()) {
      usersignin(gloablkey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: 926.h,
            width: 428.w,
            child: Stack(
              children: [
                Positioned(
                  // top: 60,
                  top: 40,
                  child: Container(
                    height: 990.h,
                    // width: 360,
                    padding: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width - 40,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: SingleChildScrollView(
                      child: Column(children: [
                        Column(
                          children: [
                            SizedBox(
                              height: 10.h,
                            ),
                            Image.asset("images/Vectorr.png"),
                            SizedBox(
                              height: 20.h,
                            ),
                            Text(
                              "DOOR 2 DOOR",
                              style: TextStyle(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Text(
                              "Experience the Power of Door to door",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.sp,
                                  color: Color.fromRGBO(0, 0, 0, 0.6)),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 27.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  sup = false;
                                });
                              },
                              child: Column(
                                children: [
                                  ///PADDING REMOVE Then Aligned
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 20.5.h, bottom: 20.5.h),
                                    child: Text(
                                      "Sign in",
                                      style: TextStyle(
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.bold,
                                          color: !sup
                                              ? Colors.black
                                              : Colors.grey),
                                    ),
                                  ),
                                  if (!sup)
                                    Container(
                                      margin: EdgeInsets.only(top: 3.h),
                                      height: 3.h,
                                      width: 140.w,
                                      color: Colors.green,
                                    ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  sup = true;
                                });
                              },
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 20.5.h, bottom: 20.5.h),
                                    child: Text(
                                      "Sign up",
                                      style: TextStyle(
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              sup ? Colors.black : Colors.grey),
                                    ),
                                  ),
                                  if (sup)
                                    Container(
                                      margin: EdgeInsets.only(top: 1.h),
                                      height: 3.h,
                                      width: 140.w,
                                      color: Colors.green,
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (sup) buildSignUp(),
                        if (!sup) buildSignin(gloablkey),
                      ]),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSignin(globalkey) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Form(
        key: _formkey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(height: 24.h),
          Text(
            "Enter the details below",
            style: TextStyle(fontSize: 15, color: Color.fromRGBO(0, 0, 0, 0.6)),
          ),
          SizedBox(
            height: 34.h,
          ),
          Container(
            // height: 22,
            // width: 364,
            child: Text(
              "Email",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: Color.fromRGBO(0, 0, 0, 1),
                // fontStyle: FontStyle.roboto,
              ),
            ),
          ),
          SizedBox(
            height: 11.h,
          ),
          TextFormField(
            controller: semailEdittingcontroller,
            obscureText: false,
            validator: (value) {
              if (value!.isEmpty) {
                return "Field is Empty";
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.mail_outline,
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
                    borderRadius: BorderRadius.all(Radius.circular(3))),
                hintText: "Enter your email",
                hintStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 13.sp,
                    color: Color.fromRGBO(0, 0, 0, 1))),
          ),
          SizedBox(
            height: 25.h,
          ),
          Container(
            child: Text(
              "Password",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: Color.fromRGBO(0, 0, 0, 1),
                // fontStyle: FontStyle.roboto,
              ),
            ),
          ),
          SizedBox(
            height: 11.h,
          ),
          TextFormField(
            controller: spasswordEdittingcontroller,
            obscureText: true,
            validator: (value) {
              if (value!.isEmpty) {
                return "Field is Empty";
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
                errorText: loginFail ? this.loginFailText : null,
                prefixIcon: Icon(
                  Icons.lock_outline_rounded,
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
                    borderRadius: BorderRadius.all(Radius.circular(3))),
                hintText: "Enter your password",
                hintStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 13.sp,
                    color: Color.fromRGBO(0, 0, 0, 1))),
          ),
          SizedBox(
            height: 136.h,
          ),
          MaterialButton(
            onPressed: () {
              loggedin(gloablkey);
              // NavBar();
              // Navigator.of(context).pushReplacement(
              //     MaterialPageRoute(builder: (context) => Home()));
            },
            minWidth: double.infinity,
            height: 55.h,
            color: Color.fromRGBO(0, 146, 65, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  top: 15.h, bottom: 15.h, left: 10.w, right: 10.w),
              child: Text(
                "Sign in",
                style: TextStyle(
                    color: Colors.white,
                    // backgroundColor: Color.fromRGBO(0, 146, 65, 1),
                    fontSize: 20.sp),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget buildSignUp() {
    return SingleChildScrollView(
      child: Container(
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 24.h,
              ),
              Padding(
                padding: EdgeInsets.only(right: 8.0.w),
                child: Text(
                  "Enter the details below to sign up now",
                  style: TextStyle(
                      fontSize: 15, color: Color.fromRGBO(0, 0, 0, 0.6)),
                ),
              ),
              SizedBox(
                height: 32.h,
              ),
              Text(
                "Full Name",
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 11.h,
              ),
              TextField(
                controller: fullnameEdittingcontroller,
                obscureText: false,
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.person_outlined,
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
                        borderRadius: BorderRadius.all(Radius.circular(3))),
                    hintText: "Enter your full name",
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 13.sp,
                        color: Color.fromRGBO(0, 0, 0, 1))),
              ),
              SizedBox(
                height: 25.h,
              ),
              Text(
                "Email",
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 11.h,
              ),
              TextField(
                controller: emailEdittingcontroller,
                obscureText: false,
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.mail_outline_rounded,
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
                        borderRadius: BorderRadius.all(Radius.circular(3))),
                    hintText: "Enter your Email address",
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 13.sp,
                        color: Color.fromRGBO(0, 0, 0, 1))),
              ),
              SizedBox(
                height: 25.h,
              ),
              Text(
                "Choose Password",
                // textAlign: TextAlign.left,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 11.h,
              ),
              TextField(
                controller: passwordEdittingcontroller,
                obscureText: false,
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock_outline,
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
                        borderRadius: BorderRadius.all(Radius.circular(3))),
                    hintText: "Enter you password",
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 13.sp,
                        color: Color.fromRGBO(0, 0, 0, 1))),
              ),
              SizedBox(
                height: 59.h,
              ),
              MaterialButton(
                onPressed: () {
                  validation_of_form();
                  NavBar();
                },
                minWidth: double.infinity,
                height: 55.h,
                color: Color.fromRGBO(0, 146, 65, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  "Sign up",
                  style: TextStyle(color: Colors.white, fontSize: 20.sp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
