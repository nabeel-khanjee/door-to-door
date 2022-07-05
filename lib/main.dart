import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:page/CampaignDetails.dart';
import 'package:page/Deletetodo.dart';
import 'package:page/GMap.dart';
import 'package:page/GmapTerritory.dart';
import 'package:page/Manageterritories.dart';
import 'package:page/alltodoscreen.dart';
import 'package:page/createnewtodo.dart';
import 'package:page/firstscreen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page/src/constants/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  
}

class MyApp extends StatelessWidget {
  // final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return ScreenUtilInit(
      builder: (child) => GetMaterialApp(
        
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
          canvasColor: Colors.transparent,
          scaffoldBackgroundColor: ColorConstants().white
        ),
        home: Firstscreen(),
        routes: {
          // "/Deletetodo" :(context) =>
          "/Alltodo": (context) => Alltodos(),
          // "/Createnewtodo": (context) => CreateNewToDo(),
        },
        
      ),

      designSize: Size(428, 926),
    );
  }
}
