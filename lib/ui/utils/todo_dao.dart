import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/user_dm.dart';

abstract class TodoDao {
  static Future<void> editIsDone(
      String itemId, Map<String, dynamic> updates) async {
    CollectionReference taskCollection =
        FirebaseFirestore.instance.collection(UserDM.collectionName);
    var taskDoc = taskCollection.doc(itemId);
    await taskDoc.update(updates);
  }
}
