import 'dart:convert';

import 'package:page/alltodoscreen.dart';

class Getdata {
  String? id;
  String? todotitle;
  String? tododescription;
  String ? user;

  var duedate;

  Getdata();
  Map<String, dynamic> toJson() => {
        'id': id,
        'todo_title': todotitle,
        'todo_description': tododescription,
        'due_date': duedate.toString(),
        'user': user
      };

  Getdata.fromSnapshot(snapshot)
      : id = snapshot.id,
        todotitle = snapshot.data()['todo_title'],
        tododescription = snapshot.data()['todo_description'],
        duedate = snapshot.data()['due_date'],
        user= jsonEncode (snapshot.data() ['user']);
}
