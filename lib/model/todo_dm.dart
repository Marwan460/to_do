import 'package:cloud_firestore/cloud_firestore.dart';

class TodoDM {
  static const String collectionName = "todo";
  late String taskId;
  late String title;
  late String description;
  late bool? isDone;
  late DateTime date;

  TodoDM(
      {required this.taskId,
      required this.title,
      required this.description,
      this.isDone = false,
      required this.date});

  TodoDM.fromJson(Map<String, dynamic> json) {
    taskId = json["id"];
    title = json["title"];
    description = json["description"];
    Timestamp timestamp = json["date"];
    date = timestamp.toDate();
    isDone = json["isDone"];
  }

  Map<String, dynamic> toJason() {
    return {
      "id": taskId,
      "title": title,
      "description": description,
      "date": date,
      "isDone": isDone,
    };
  }
}
