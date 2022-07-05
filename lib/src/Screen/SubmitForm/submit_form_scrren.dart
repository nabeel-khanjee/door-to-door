import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:page/src/component/app_bar_component.dart';

class SubmitFormScreen extends StatefulWidget {
  const SubmitFormScreen({Key? key}) : super(key: key);

  @override
  State<SubmitFormScreen> createState() => _SubmitFormScreenState();
}

class _SubmitFormScreenState extends State<SubmitFormScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
      child: AppBarForApplication(
          leadingIcon: Icons.arrow_back_ios,
          actionIcon: Icons.notifications,
          leadingCallback: () {},
          actionCallback: () {}),
      preferredSize: Size.fromHeight(kToolbarHeight),
    ));
  }
}
