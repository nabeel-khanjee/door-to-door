import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page/src/Screen/CampaignSelectionScreen/components/header_campaign_screen.dart';
import 'package:page/src/Screen/CampaignSelectionScreen/components/text_field_component.dart';
import 'package:page/src/Screen/CampaignSelectionScreen/functions/campaign_functions.dart';
import 'package:page/src/component/app_bar_component.dart';
import 'package:page/src/component/bottom_button_component.dart';
import 'package:page/src/component/sub_heading_alertbox.dart';
import 'package:page/src/component/text_component.dart';
import 'package:page/src/constants/colors.dart';
import 'package:page/src/firebase/firebase_functions.dart';

class CapaignDetailsScreen extends StatefulWidget {
  const CapaignDetailsScreen(
      {Key? key,
      required this.data,
      required this.campaignList,
      required this.campaignId})
      : super(key: key);
  final Map<String, dynamic> data;
  final Map<String, dynamic> campaignList;
  final String campaignId;
  @override
  State<CapaignDetailsScreen> createState() => _CapaignDetailsScreenState();
}

class _CapaignDetailsScreenState extends State<CapaignDetailsScreen> {
  TextEditingController textEditingController = TextEditingController();
  TextEditingController textAresEditingController = TextEditingController();
  List<Map<String, dynamic>> listCheckBox = [];
  String radioValue = '';
  int chechBoxCount = 0;

  Object? dropDownValue;

  Map<String, Object?>? dataSet;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Column(
          children: [
            AppBarForApplication(
              leadingIcon: Icons.arrow_back_ios,
              actionIcon: Icons.notifications_none_outlined,
              leadingCallback: () {},
              actionCallback: () {},
              actionIconColor: ColorConstants().green,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Center(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('campaign-questionnaire')
                      .where('campaignId', isEqualTo: widget.campaignId)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError)
                      return Text('Error = ${snapshot.error}');
                    if (snapshot.hasData) {
                      final docs = snapshot.data!.docs;
                      return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final Map<String, dynamic> data =
                              docs[index].data() as Map<String, dynamic>;
                          return Column(children: [
                            HeaderCampaignScreen(widget: widget),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 50,
                            ),
                            for (var i = 0; i < data['questions'].length; i++)
                              if (data['questions'][i]['answer']['type'] ==
                                  'Checkboxes')
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SubHeadingAlertBox(
                                          text: data['questions'][i]['value']),
                                      GridView.builder(
                                        gridDelegate:
                                            SliverGridDelegateWithMaxCrossAxisExtent(
                                                maxCrossAxisExtent: 250,
                                                mainAxisSpacing: 1,
                                                mainAxisExtent:
                                                    data['questions'][i]
                                                                    ['answer']
                                                                ['options']
                                                            .length *
                                                        16.00),
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: data['questions'][i]
                                                ['answer']['options']
                                            .length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          listCheckBox.add({
                                            "status": data['questions'][i]
                                                    ['answer']['options'][index]
                                                ['value']['status'],
                                            'value': data['questions'][i]
                                                    ['answer']['options'][index]
                                                ['value']['getData'],
                                          });
                                          chechBoxCount = data['questions'][i]
                                                  ['answer']['options']
                                              .length;

                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Checkbox(
                                                value: listCheckBox[index]
                                                    ['status'],
                                                onChanged: (value) {
                                                  setState(() {
                                                    listCheckBox[index]
                                                        ['status'] = value;
                                                  });
                                                },
                                              ),
                                              Text(
                                                listCheckBox[index]['value'] ??
                                                    "Name",
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ])
                              else if (data['questions'][i]['answer']['type'] ==
                                  'Radio buttons')
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SubHeadingAlertBox(
                                        text: data['questions'][i]['value']),
                                    GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithMaxCrossAxisExtent(
                                              maxCrossAxisExtent: 250,
                                              mainAxisSpacing: 1,
                                              mainAxisExtent: data['questions']
                                                              [i]['answer']
                                                          ['options']
                                                      .length *
                                                  16.00),
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: data['questions'][i]['answer']
                                              ['options']
                                          .length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Radio(
                                                groupValue: data['questions'][i]
                                                        ['answer']['options']
                                                    [index]['value'],
                                                value: radioValue,
                                                onChanged: (value) {
                                                  setState(() {
                                                    chechBoxCount = 0;
                                                    radioValue =
                                                        data['questions'][i]
                                                                    ['answer']
                                                                ['options']
                                                            [index]['value'];
                                                  });
                                                }),
                                            Text(
                                              data['questions'][i]['answer']
                                                          ['options'][index]
                                                      ['value'] ??
                                                  "Name",
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                )
                              else if (data['questions'][i]['answer']['type'] ==
                                  'Dropdowns')
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SubHeadingAlertBox(
                                        text: data['questions'][i]['value']),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      child: DropdownButton(
                                        isExpanded: true,
                                        focusColor: Colors.grey,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(3),
                                        ),
                                        dropdownColor: Colors.white,
                                        alignment: AlignmentDirectional.center,
                                        icon: Padding(
                                          padding: EdgeInsets.only(
                                            left: 140.w,
                                          ),
                                          child: Icon(
                                            Icons.arrow_drop_down,
                                            color: Colors.black,
                                          ),
                                        ),
                                        iconSize: 20,
                                        hint: Padding(
                                          padding: EdgeInsets.only(
                                              left: 3.0.w,
                                              right: 3.w,
                                              top: 8.h,
                                              bottom: 8.h),
                                          child: Text(
                                            'Select Campaign',
                                            style: TextStyle(
                                              fontSize: 15.sp,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        value: dropDownValue,
                                        items: ((data['questions'][i]['answer']
                                                ['options'] as List))
                                            .map((items) {
                                          return DropdownMenuItem(
                                              value: items, child: Text(items));
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            dropDownValue = newValue;
                                          });
                                        },
                                      ),
                                    )
                                  ],
                                )
                              else if (data['questions'][i]['answer']['type'] ==
                                  'Text box')
                                TextFieldComponent(
                                    textAreaSize: 4,
                                    data: data,
                                    i: i,
                                    textEditingController:
                                        textEditingController)
                              else if (data['questions'][i]['answer']['type'] ==
                                  'text')
                                TextFieldComponent(
                                    textAreaSize: 1,
                                    data: data,
                                    i: i,
                                    textEditingController:
                                        textEditingController),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 50,
                            ),
                            BottomButtonComponent(
                                buttonColor: ColorConstants().green,
                                textColor: ColorConstants().white,
                                buttonText: 'Submit Answers',
                                paddingBottom: 0,
                                paddingLeft: 0,
                                paddingRight: 0,
                                paddingTop: 0,
                                onTap: () {
                                  print(radioValue);
                                  print(textAresEditingController.value.text);
                                  print(textEditingController.value.text);
                                  print(dropDownValue);
                                  List<Map<String, dynamic>> chechBoxValue = [];
                                  for (var i = 0; i < chechBoxCount; i++) {
                                    print(listCheckBox[i]['value']);
                                    print(listCheckBox[i]['status']);
                                    chechBoxValue.add({
                                      'value': listCheckBox[i]['value'],
                                      'status': listCheckBox[i]['status']
                                    });
                                  }
                                  dataSet = {
                                    'dropdownValue': dropDownValue,
                                    'text': textEditingController.value.text,
                                    'textArea':
                                        textAresEditingController.value.text,
                                    'radioValue': radioValue,
                                    'chechbocValue': chechBoxValue
                                  };

                                  setState(() {});

                                  FirebaseFunctions().addtems(dataSet!,
                                      'answers', 'Successfully Submited', 'errorMsg');

                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  
                                }),
                          ]);
                        },
                      );
                    }
                    return Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 2.5),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  })),
        ),
      ),
    );
  }
}

