import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo/model/todo_dm.dart';
import 'package:todo/ui/screens/edit_task/edit_task.dart';
import 'package:todo/ui/utils/app_colors.dart';
import 'package:todo/ui/utils/app_style.dart';
import 'package:todo/ui/utils/todo_dao.dart';
import '../../../../../model/user_dm.dart';

class Todo extends StatefulWidget {
  final TodoDM? task;
  final UserDM? userDM;

  const Todo({
    super.key,
    required this.task,
    this.userDM,
  });

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  CrossFadeState crossFadeState = CrossFadeState.showFirst;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      startActionPane: ActionPane(motion: const BehindMotion(), children: [
        GestureDetector(
          onTap: () {
            deleteTask(widget.task!.taskId);
          },
          child: Container(
              padding: const EdgeInsets.all(8),
              height: MediaQuery.of(context).size.height * 0.13,
              width: MediaQuery.of(context).size.width * 0.50,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Column(
                children: [
                  Spacer(),
                  Icon(Icons.delete),
                  Spacer(),
                  Text("Delete"),
                  Spacer(),
                ],
              )),
        )
      ]),
      endActionPane: ActionPane(motion: const BehindMotion(), children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(EditTask.routeName);
          },
          child: Container(
              padding: const EdgeInsets.all(8),
              height: MediaQuery.of(context).size.height * 0.13,
              width: MediaQuery.of(context).size.width * 0.50,
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Column(
                children: [
                  Spacer(),
                  Icon(Icons.edit),
                  Spacer(),
                  Text("Edit"),
                  Spacer(),
                ],
              )),
        )
      ]),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 26, vertical: 22),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        height: MediaQuery.of(context).size.height * 0.13,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          children: [
            buildVerticalLine(context),
            const SizedBox(width: 25),
            buildTodoInfo(),
            const Spacer(),
            buildTodoState()
          ],
        ),
      ),
    );
  }

  buildVerticalLine(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: widget.task!.isDone == true ? Colors.green : AppColors.primary,
          borderRadius: BorderRadius.circular(4)),
      height: MediaQuery.of(context).size.height * .07,
      width: 4,
    );
  }

  buildTodoInfo() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          Text(
            widget.task!.title,
            maxLines: 1,
            style: widget.task!.isDone == true
                ? AppStyle.todoTextStyle.copyWith(color: Colors.green)
                : AppStyle.todoTextStyle,
          ),
          const Spacer(),
          Text(
            widget.task!.description,
            style: widget.task!.isDone == true
                ? AppStyle.bodyTextStyle.copyWith(color: Colors.green)
                : AppStyle.bodyTextStyle,
          ),
          const Spacer()
        ],
      ),
    );
  }

  buildTodoState() {
    return GestureDetector(
      onTap: () {
        widget.task?.isDone = !widget.task!.isDone!;
        editIsDone(widget.task!.taskId);
      },
      child: widget.task!.isDone == true
          ? Text(
              "Done!",
              style: AppStyle.appBarStyle.copyWith(color: Colors.green),
            )
          : Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: const Icon(
                Icons.done_outline,
                color: AppColors.white,
                size: 25,
              ),
            ),
    );
  }

  Future<void> editIsDone(String taskId) async {
    CollectionReference todoCollection = FirebaseFirestore.instance
        .collection(UserDM.collectionName)
        .doc(UserDM.currentUser!.userId)
        .collection(TodoDM.collectionName);
    var taskDoc = todoCollection.doc(taskId);
    await taskDoc.update({"isDone": widget.task!.isDone!});
    setState(() {});
  }

  Future<void> deleteTask(String taskId) async {
    CollectionReference taskCollection = FirebaseFirestore.instance
        .collection(UserDM.collectionName)
        .doc(UserDM.currentUser!.userId)
        .collection(TodoDM.collectionName);
    var taskDoc = taskCollection.doc(taskId);
    await taskDoc.delete();
    TodoDao.getTodosListFromFireStore();
    setState(() {});
  }
}
