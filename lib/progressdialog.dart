// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ProgressDialaog extends StatelessWidget {
  String message;
  ProgressDialaog({required this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black, 
      child: Container(
        margin: EdgeInsets.all(15),
        // width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(children: [
          SizedBox(width: 6),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          SizedBox(width: 26),
          Text(
            message,
            style: TextStyle(color: Colors.white),
          ),
        ]),
      ),
    );
  }
}
