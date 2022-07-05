import 'package:flutter/material.dart';
import 'package:page/src/constants/colors.dart';

class TerritorriesListing extends StatelessWidget {
  final VoidCallback onTap;
  
  const TerritorriesListing({
    Key? key,
    required this.data,
    required this.onTap,
  }) : super(key: key);

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(5),
      elevation: 5,
      color: ColorConstants().white,
      child: ListTile(
        onTap: onTap,
        title: Text(data['territoryname']),
      ),
    );
  }
}
