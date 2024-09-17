import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../model/todo_dm.dart';
import '../../model/user_dm.dart';

abstract class TodoDao {
  TodoDao();

  static addTodoToFireStore(
      BuildContext context,
      TextEditingController titleController,
      TextEditingController descriptionController) {
    DateTime selectedDate = DateTime.now();
    CollectionReference todosCollection = FirebaseFirestore.instance
        .collection(UserDM.collectionName)
        .doc(UserDM.currentUser!.userId)
        .collection(TodoDM.collectionName);
    DocumentReference doc = todosCollection.doc();
    TodoDM todoDM = TodoDM(
        taskId: doc.id,
        title: titleController.text,
        description: descriptionController.text,
        isDone: false,
        date: selectedDate);
    doc.set(todoDM.toJason()).then((_) {
      /// this callback is called when future is completed
      Navigator.pop(context);
    }).onError((error, stackTrack) {
      /// this callback is called when the future throws an exception
    });
  }
}
