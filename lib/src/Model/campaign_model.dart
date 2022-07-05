import 'package:cloud_firestore/cloud_firestore.dart';

class Campaigns {
    final String? id;

  final String? details;
  final String name;
  final bool status;
  // final int salary;
  final DateRange date_range;
  // final List<String>? employeeTraits;
  Campaigns({
    this.id,
   required this.details,
    required this.name,
    required this.status,
    // required this.salary,
    required this.date_range,
    // this.employeeTraits
  });

  Map<String, dynamic> toMap() {
    return {
      'details': details,
      'name': name,
      'status': status,
      // 'salary': salary,
      'date_range': date_range.toMap(),
      // 'employeeTraits': employeeTraits
    };
  }

  Campaigns.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      :id = doc.id, 
      details = doc.data()!['details'],
        name = doc.data()!["name"],
        status = doc.data()!["status"],
        // salary = doc.data()!["salary"],
        date_range = DateRange.fromMap(doc.data()!["date_range"]);
  // employeeTraits = doc.data()?["employeeTraits"] == null
  //     ? null
  //     : doc.data()?["employeeTraits"].cast<String>();
}

class DateRange {
  final String from;
  final String to;

  DateRange({
    required this.from,
    required this.to,
  });

  Map<String, dynamic> toMap() {
    return {
      'from': from,
      'to': to,
    };
  }

  DateRange.fromMap(Map<String, dynamic> dateMap)
      : from = dateMap["from"],
        to = dateMap["to"]
  // cityName = dateMap["cityName"]
  ;
}
