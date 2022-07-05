// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:page/screentwo.dart';

class Firstscreen extends StatefulWidget {
  const Firstscreen({Key? key}) : super(key: key);

  @override
  State<Firstscreen> createState() => _FirstscreenState();
}

class _FirstscreenState extends State<Firstscreen> {
  @override
   initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => Secondscreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 146, 65, 1),
      body: Container(
          // height: 400,
          // width: 600,
          // margin: EdgeInsets.only(top: 395,bottom: 493,left: 127,right: 127),
          // padding: EdgeInsets.only(top: 395,bottom: 493,left: 127,right: 127),
          child: Center(
        child: Container(
          padding: EdgeInsets.only(top: 250),
          child: Column(
            children: [
              Image.asset("images/VectorFS.png"),
              SizedBox(
                height: 15,
              ),
              Text(
                "DOOR 2 DOOR",
                style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontSize: 25,
                    fontWeight: FontWeight.w800),
              ),
              Text(
                "Experience the Power of Door to door",
                style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
