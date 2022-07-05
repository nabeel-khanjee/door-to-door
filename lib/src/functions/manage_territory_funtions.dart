import 'package:flutter/material.dart';
import 'package:page/src/Screen/ManageTerritoried/manage_territories.dart';
import 'package:page/src/component/bottom_button_component.dart';
import 'package:page/src/component/sub_heading_alertbox.dart';
import 'package:page/src/component/territories_assigned_component.dart';
import 'package:page/src/constants/colors.dart';
import 'package:page/src/constants/string_constants.dart';

import '../component/campaing_created_aleart_box.dart';
import '../component/text_component.dart';

class ManageTerritoriesFunction {
  String popupData(int index) {
    if (index == 0) {
      return "Edit territory";
    }
    if (index == 1) {
      return "View territory details";
    }
    if (index == 2) {
      return "Delete territory";
    }
    return '';
  }

  Future<dynamic> showAlertDialog(BuildContext context, Object index, data) {
    return showDialog(
      // useSafeArea: true,
      context: context,

      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          insetPadding: EdgeInsets.fromLTRB(26, 0, 26, 0),
          content: SizedBox(
            height: MediaQuery.of(context).size.height / 1.9,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(StringConstants().territoryDetails),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close_rounded))
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TerritoriesAssigned(data: data),
                    CampaignsCreated(data: data),
                    SubHeadingAlertBox(
                        text: StringConstants().territoryCreated),
                    TextCompnentAlertBox(
                      textMaxSize: 200,
                        suffixText: '(1 week ago)', text: data['created']),
                    BottomButtonComponent(
                        paddingBottom: 0,
                        paddingLeft: 0,
                        paddingRight: 0,
                        paddingTop: 10,
                        onTap: () {},
                        icon: Icons.file_download_outlined,
                        buttonColor: ColorConstants().green,
                        textColor: ColorConstants().white,
                        buttonText: StringConstants().downloadDetails)
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
