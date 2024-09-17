import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo/model/user_dm.dart';

import '../../model/todo_dm.dart';

class ListProvider extends ChangeNotifier {
  List<TodoDM> todosList = [];
  DateTime selectedCalenderDate = DateTime.now();

  Future<List<TodoDM>> getTodosListFromFireStore() async {
    CollectionReference todosCollection = FirebaseFirestore.instance
        .collection(UserDM.collectionName)
        .doc(UserDM.currentUser!.userId)
        .collection(TodoDM.collectionName);
    QuerySnapshot querySnapshot = await todosCollection.get();
    List<QueryDocumentSnapshot> documents = querySnapshot.docs;
    todosList = documents.map((doc) {
      Map<String, dynamic> json = doc.data() as Map<String, dynamic>;
      return TodoDM.fromJson(json);
    }).toList();
    todosList = todosList
        .where((todo) =>
            todo.date.year == selectedCalenderDate.year &&
            todo.date.month == selectedCalenderDate.month &&
            todo.date.day == selectedCalenderDate.day)
        .toList();
    todosList.sort((todo1, todo2) {
      return todo1.date.compareTo(todo2.date);
    });
    notifyListeners();
    return todosList;
  }
}
