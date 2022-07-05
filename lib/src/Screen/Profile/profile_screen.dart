import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/route_manager.dart';
import 'package:page/Navbar.dart';
import 'package:page/UserScreenNav.dart';
import 'package:page/src/Model/user_model.dart';
import 'package:page/src/Screen/CampaignSelectionScreen/components/text_field_component.dart';
import 'package:page/src/component/app_bar_component.dart';
import 'package:page/src/component/bottom_button_component.dart';
import 'package:page/src/component/sub_appbar.dart';
import 'package:page/src/component/sub_heading_alertbox.dart';
import 'package:page/src/component/text_component.dart';
import 'package:page/src/constants/colors.dart';
import 'package:page/src/firebase/firebase_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreem extends StatefulWidget {
  const ProfileScreem({Key? key}) : super(key: key);

  @override
  State<ProfileScreem> createState() => _ProfileScreemState();
}

class _ProfileScreemState extends State<ProfileScreem> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneEditingController = TextEditingController();

  Map<String, String>? data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        
        .get()
        .then((value) {
      print(value.data());
      loggedInUser = UserModel.fromDocumentSnapshot(value);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants().white,
      bottomNavigationBar: BottomButtonComponent(
          buttonColor: ColorConstants().green,
          textColor: ColorConstants().white,
          buttonText: 'Save Changes',
          paddingTop: 0,
          onTap: () {
            data = {
              'fullname': nameController.value.text.isNotEmpty
                  ? nameController.value.text
                  : loggedInUser.fullname!,
              'phone': phoneEditingController.value.text.isNotEmpty
                  ? phoneEditingController.value.text
                  : loggedInUser.phone!
            };
            FirebaseFunctions().updateItems(
                data!, user!.uid, "users", 'User Profile Updated', 'errorMsg');
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => loggedInUser.role == "User"
                      ? UserScreenNav(
                          currentScreen: ProfileScreem(),
                          currentTab: 3,
                        )
                      : NavBar(
                          currentScreen: ProfileScreem(),
                          currentTab: 3,
                        ),
                ));
          }),
      appBar: PreferredSize(
        child: Column(
          children: [
            AppBarForApplication(
                leadingIcon: Icons.arrow_back_ios,
                actionIcon: Icons.person,
                leadingCallback: () {},
                actionCallback: () {}),
            // Divider(),
          ],
        ),
        preferredSize: Size.fromHeight(kToolbarHeight),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SubAppbar(text: 'Profile Setting'),

            Divider(
              height: 1,
            ),
            loggedInUser.role != null
                ? Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image(
                                    image: NetworkImage(loggedInUser.avatar ??
                                        'https://images.unsplash.com/photo-1616597082843-de7ce757d548?ixid=MXwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw0N3x8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60')),
                              ),
                            ),
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: ColorConstants().green,
                                      borderRadius: BorderRadius.circular(30)),
                                  child: GestureDetector(
                                    child: IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.edit,
                                          color: ColorConstants().white,
                                        )),
                                  ),
                                ))
                          ],
                        ),
                        SubHeadingAlertBox(text: loggedInUser.fullname!),
                        TextFieldComponent(
                          textEditingController: nameController,
                          subHeading: "Name",
                          hintText: loggedInUser.fullname ?? "Name",
                        ),
                        TextFieldComponent(
                            textEditingController: phoneEditingController,
                            subHeading: "Phone",
                            hintText: loggedInUser.phone ?? "Phone"),
                      ],
                    ),
                  )
                : Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.3),
                    child: CircularProgressIndicator()),

            // Text(loggedInUser.role!),

            //     })
          ],
        ),
      ),
    );
  }
}
