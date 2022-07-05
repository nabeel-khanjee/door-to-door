import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:page/src/constants/colors.dart';

class FirebaseFunctions {
  void updateItems(Map<String, dynamic> data, String docId,
      String collectionName, String successMsg, String errorMsg) {
    print("${data}\n${docId}\n${collectionName}\n${successMsg}\n${errorMsg}");
    FirebaseFirestore.instance
        .collection(collectionName)
        .doc(docId)
        .update(data)
        .then((value) {
      if (successMsg.isNotEmpty) {
        Get.snackbar(
          "",
          "",

          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: ColorConstants().white,
          messageText: Text(successMsg),

          titleText: Text(
            "Success",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          margin: EdgeInsets.all(35),
          leftBarIndicatorColor: ColorConstants().green,
          
          // borderColor: ColorConstants().grey,
          // colorText: ColorConstants().grey,

          // duration: Duration(seconds: 4),
          //  icon: Icon(Icons.close),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          
          forwardAnimationCurve: Curves.easeOutBack,
        );
      }
    }).catchError((onError) => {
              Get.snackbar(
                "GeeksforGeeks",
                "Hello everyone",
                icon: Icon(Icons.person, color: Colors.white),
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                borderRadius: 20,
                margin: EdgeInsets.all(15),
                colorText: Colors.white,
                duration: Duration(seconds: 4),
                isDismissible: true,
                //  dismissDirection: SnackDismissDirection.HORIZONTAL,
                forwardAnimationCurve: Curves.easeOutBack,
              )
            });
  }

  void deleteItems(
      String docId, String collectionName, String successMsg, String errorMsg) {
    print("${docId}\n${collectionName}\n${successMsg}\n${errorMsg}");
    FirebaseFirestore.instance
        .collection(collectionName)
        .doc(docId)
        .delete()
        .then((value) {
          if (successMsg.isNotEmpty) {
        Get.snackbar(
          "",
          "",

          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: ColorConstants().white,
          messageText: Text(successMsg),

          titleText: Text(
            "Success",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          margin: EdgeInsets.all(35),
          leftBarIndicatorColor: ColorConstants().green,
          
          // borderColor: ColorConstants().grey,
          // colorText: ColorConstants().grey,

          // duration: Duration(seconds: 4),
          //  icon: Icon(Icons.close),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          
          forwardAnimationCurve: Curves.easeOutBack,
        );
      }
     })
        .catchError((onError) => {
        Get.snackbar(
          "",
          "",

          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: ColorConstants().white,
          messageText: Text(successMsg),

          titleText: Text(
            "Success",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          margin: EdgeInsets.all(35),
          leftBarIndicatorColor: ColorConstants().green,
          
          // borderColor: ColorConstants().grey,
          // colorText: ColorConstants().grey,

          // duration: Duration(seconds: 4),
          //  icon: Icon(Icons.close),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          
          forwardAnimationCurve: Curves.easeOutBack,
        )
       });
  }

  void addtems(Map<String, dynamic> data, String collectionName,
      String successMsg, String errorMsg) {
    print("${data}\n${collectionName}\n${successMsg}\n${errorMsg}");
    FirebaseFirestore.instance
        .collection(collectionName)
        .add(data)
        .then((value) {
          if (successMsg.isNotEmpty) {
        Get.snackbar(
          "",
          "",

          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: ColorConstants().white,
          messageText: Text(successMsg),

          titleText: Text(
            "Success",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          margin: EdgeInsets.all(35),
          leftBarIndicatorColor: ColorConstants().green,
          
          // borderColor: ColorConstants().grey,
          // colorText: ColorConstants().grey,

          // duration: Duration(seconds: 4),
          //  icon: Icon(Icons.close),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          
          forwardAnimationCurve: Curves.easeOutBack,
        );
      }
        }
      )
        .catchError((onError) => {
              Get.snackbar(
                "GeeksforGeeks",
                "Hello everyone",
                icon: Icon(Icons.person, color: Colors.white),
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                borderRadius: 20,
                margin: EdgeInsets.all(15),
                colorText: Colors.white,
                duration: Duration(seconds: 4),
                isDismissible: true,
                //  dismissDirection: SnackDismissDirection.HORIZONTAL,
                forwardAnimationCurve: Curves.easeOutBack,
              )
            });
  }
}
