import 'package:cloud_firestore/cloud_firestore.dart';


class DeleteTodo {
  void deletetoDo(String id) async {
    // print(id);

    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("todo-list").doc(id).delete();
    // Get.back();
    
     
  }
}
