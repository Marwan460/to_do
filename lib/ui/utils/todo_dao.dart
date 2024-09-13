import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/todo_dm.dart';
import '../../model/user_dm.dart';

abstract class TodoDao {
  static void getTodosListFromFireStore() async {
    List<TodoDM> todosList = [];
    CollectionReference todoCollection = FirebaseFirestore.instance
        .collection(UserDM.collectionName)
        .doc(UserDM.currentUser!.userId)
        .collection(TodoDM.collectionName);
    QuerySnapshot querySnapshot = await todoCollection.get();
    List<QueryDocumentSnapshot> documents = querySnapshot.docs;
    todosList = documents.map((doc) {
      Map<String, dynamic> json = doc.data() as Map<String, dynamic>;
      return TodoDM.fromJson(json);
    }).toList();
    var selectedCalenderDate;
    todosList = todosList
        .where((todo) =>
            todo.date.year == selectedCalenderDate?.year &&
            todo.date.month == selectedCalenderDate?.month &&
            todo.date.day == selectedCalenderDate?.day)
        .toList();
  }

  static Future<void> editIsDone(
      String itemId, Map<String, dynamic> updates) async {
    CollectionReference taskCollection =
        FirebaseFirestore.instance.collection(UserDM.collectionName);
    var taskDoc = taskCollection.doc(itemId);
    await taskDoc.update(updates);
  }
}
