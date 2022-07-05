import 'package:flutter/material.dart';
import 'package:page/src/component/sub_heading_alertbox.dart';
import 'package:page/src/component/text_component.dart';

class CampaignFunctions {
  var todoEdittingcontroller;

  var value = false;

  Widget getCampaignComponent(type, data) {
    if (type == 'Text box') {
      // return Text(data.toString());
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SubHeadingAlertBox(text: data['label']),
          TextFormField(
            // initialValue: dataForEdit["title"],
            validator: (value) {
              if (value!.isEmpty) {
                return "field is required";
              }
              return null;
            },
            controller: todoEdittingcontroller,
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
                hintText: data['Write question'] != null
                    ? data['Write question']
                    : "Enter  Name",
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                  color: Color.fromRGBO(0, 0, 0, 1),
                )),
          ),
        ],
      );
    } else if (type == 'Checkboxes') {
      return Row(
        children: [
          Checkbox(
            value: value,
            onChanged: (value) {

              this.value = value!;
              print(this.value);
            },
          ),
          Column(
            children: [
              TextCompnentAlertBox(
                textMaxSize: 100,
                text: data['territoryname'] ?? "Name",
              ),
              TextCompnentAlertBox(
                textMaxSize: 100,
                text: data['created'] ?? "30/04/2022",
              ),
            ],
          ),
        ],
      );
      
    } else if (type == 'Radio buttons') {
      return Text(data.toString());
    } else if (type == 'Dropdowns') {
      return Text(data.toString());
    } else if (type == 'Text Area') {
      return Text(data.toString());
    } else if (type == 'text') {
      return Text(data.toString());
    } else {
      return Container();
    }
  }
}
