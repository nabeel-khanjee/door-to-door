import 'package:flutter/material.dart';

class TextCompnentAlertBox extends StatelessWidget {
  final String text;
  final String suffixText;
  final String prefixText;
  final double? textMaxSize;
  

  const TextCompnentAlertBox({
    Key? key,
    required this.text,
    this.suffixText = '',
    this.prefixText = '',  this.textMaxSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: textMaxSize?? 66,
      child: Text(
        "$prefixText $text $suffixText",
        overflow: TextOverflow.ellipsis,
        // softWrap: true,
      ),
    );
  }
}
