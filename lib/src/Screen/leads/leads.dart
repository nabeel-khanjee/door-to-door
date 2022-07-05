import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page/src/component/app_bar_component.dart';
import 'package:page/src/component/sub_appbar.dart';
import 'package:page/src/constants/colors.dart';

class LeadScreen extends StatefulWidget {
  const LeadScreen({Key? key}) : super(key: key);

  @override
  State<LeadScreen> createState() => _LeadScreenState();
}

String getImage(int i) {
  if (i == 1) {
    return 'images/interested_marker.png';
  } else if (i == 2) {
    return 'images/not_home.png';
  } else if (i == 3) {
    return 'images/come_back.png';
  } else if (i == 4) {
    return 'images/not_interested.png';
  } else if (i == 5) {
    return 'images/empty_property.png';
  } else
    return 'images/not_interested.png';
}

class _LeadScreenState extends State<LeadScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants().white,
      appBar: PreferredSize(
        child: Column(
          children: [
            AppBarForApplication(
                leadingIcon: Icons.arrow_back_ios,
                actionIcon: Icons.person,
                leadingCallback: () {},
                actionCallback: () {}),
                       SubAppbar(text: "My Leads"),

          ],
        ),
        preferredSize: Size.fromHeight(kToolbarHeight*2),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream:
                      FirebaseFirestore.instance.collection('leads').snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError)
                      return Text('Error = ${snapshot.error}');
                    if (snapshot.hasData) {
                      final docs = snapshot.data!.docs;
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: docs.length,
                          itemBuilder: (BuildContext context, index) {
                            final Map<String, dynamic> data =
                                docs[index].data() as Map<String, dynamic>;
                            return Column(
                              children: [
                                Divider(),
                                Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      children: [
                                        Image(
                                          height: 40,
                                          image: AssetImage(
                                              getImage(data['status'])),
                                        ),
                                        Spacer(),
                                        Column(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.3,
                                              child: Row(
                                                children: [
                                                  Text('interested'),
                                                  Spacer(),
                                                  Text('Status Update At',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.3,
                                              child: Row(
                                                children: [
                                                  Text('Postal Code 74400',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Spacer(),
                                                  Text('20/03/2022'),
                                                ],
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          });
                    }
                    return CircularProgressIndicator();
                  })
            ],
          ),
        ),
      ),
    );
  }
}
