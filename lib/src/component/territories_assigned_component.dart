import 'package:flutter/material.dart';
import 'package:page/src/Screen/ManageTerritoried/manage_territories.dart';
import 'package:page/src/component/sub_heading_alertbox.dart';
import 'package:page/src/constants/string_constants.dart';
import 'package:page/src/component/text_component.dart';

class TerritoriesAssigned extends StatelessWidget {
  final Map<String, dynamic> data;
  TerritoriesAssigned({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SubHeadingAlertBox(text: StringConstants().territoryAssigned),
        SizedBox(
          width: MediaQuery.of(context).size.width * .7,
          height: MediaQuery.of(context).size.width * .25,
          child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: false,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 150,
                childAspectRatio: 40,
                crossAxisSpacing: 40,
                mainAxisExtent: 40,
              ),
              itemCount: data['assignees'].length,
              itemBuilder: (BuildContext ctx, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image(
                            image: NetworkImage(data['assignees'][index]
                                    ['avatar'] ??
                                'https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60')),
                      ),
                    ),
                    TextCompnentAlertBox(
                      textMaxSize: 70,
                        text: data['assignees'][index]['fullname']),
                  ],
                );
              }),
        ),
      ],
    );
  }
}
