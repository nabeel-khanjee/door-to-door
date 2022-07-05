import 'package:flutter/material.dart';
import 'package:page/src/component/sub_heading_alertbox.dart';
import 'package:page/src/constants/string_constants.dart';
import 'package:page/src/component/text_component.dart';

class CampaignsCreated extends StatelessWidget {
  final Map<String, dynamic> data;
  const CampaignsCreated({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
    
      children: [
        SubHeadingAlertBox(
          text: StringConstants().campaignsCreated,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * .7,
          height: MediaQuery.of(context).size.width * .12,
          child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: false,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 100,
                childAspectRatio: 20,
                // crossAxisSpacing: 40,
                mainAxisExtent: 20,
              ),
              itemCount: data['assignees'].length,
              itemBuilder: (BuildContext ctx, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextCompnentAlertBox(
                      textMaxSize: 80,
                        prefixText: '◉',
                        text: data['assignees'][index]['fullname']),
                  ],
                );
              }),
        ),
      ],
    );
  }
}

