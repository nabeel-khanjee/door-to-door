
import 'package:flutter/material.dart';
import 'package:page/src/Screen/CampaignSelectionScreen/campaign_selection_screen.dart';
import 'package:page/src/component/sub_heading_alertbox.dart';
import 'package:page/src/constants/colors.dart';

class HeaderCampaignScreen extends StatelessWidget {
  const HeaderCampaignScreen({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final CapaignDetailsScreen widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SubHeadingAlertBox(text: "Campaign Details",
        ),
        Text('Answer the follwoing question to start the campaign',
        style: TextStyle(color: ColorConstants().grey),
        ),
        SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Campaign Duration',style: TextStyle(fontWeight: FontWeight.bold),),
            Text('Campaign Milestone',style: TextStyle(fontWeight: FontWeight.bold),)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${widget.campaignList['date_range']['to']} - ${widget.campaignList['date_range']['from']}'),
            Text('7 days ( 1 week )')
          ],
        )
      ],
    );
  }
}
