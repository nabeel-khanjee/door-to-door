import 'package:flutter/material.dart';
import 'package:page/src/component/sub_heading_alertbox.dart';

class TextFieldComponent extends StatelessWidget {
  const TextFieldComponent({
    Key? key,
    this.data,
    this.i,
    required this.textEditingController,
    this.textAreaSize,
    this.subHeading, this.hintText,
  }) : super(key: key);
  final String? subHeading;
  final Map<String, dynamic>? data;
  final int? i;
  final String? hintText;
  final int? textAreaSize;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SubHeadingAlertBox(text: subHeading ?? data!['questions'][i]['value']),
        TextFormField(
          maxLines: textAreaSize,
          validator: (value) {
            if (value!.isEmpty) {
              return "field is required";
            }
            return null;
          },
          controller: textEditingController,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.all(
                  Radius.circular(3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(3))),
              hintText:  hintText!=null ? hintText: data!['questions'][i]['placeholder'] != null
                  ? data!['questions'][i]['placeholder']
                  : "Enter Name",
              hintStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 13,
                color: Color.fromRGBO(0, 0, 0, 1),
              )),
        ),
      ],
    );
  }
}
