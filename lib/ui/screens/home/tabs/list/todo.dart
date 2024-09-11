import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo/model/todo_dm.dart';
import 'package:todo/ui/utils/app_colors.dart';
import 'package:todo/ui/utils/app_style.dart';
import 'package:todo/ui/utils/todo_dao.dart';

import '../../../../../model/user_dm.dart';

class Todo extends StatefulWidget {
  final TodoDM? task;

  const Todo({
    super.key,
    required this.task,
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
        Container(
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
            ))
      ]),
      endActionPane: ActionPane(motion: const BehindMotion(), children: [
        Container(
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
            ))
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
          color: widget.task!.isDone! ? Colors.green : AppColors.primary,
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
            style: widget.task!.isDone!
                ? AppStyle.todoTextStyle.copyWith(color: Colors.green)
                : AppStyle.todoTextStyle,
          ),
          const Spacer(),
          Text(
            widget.task!.description,
            style: AppStyle.bodyTextStyle,
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
        crossFadeState = widget.task!.isDone!
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst;
        setState(() {});
      },
      child: AnimatedCrossFade(
          firstChild: Container(
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
          secondChild: const Text(
            "Done!",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green,
              fontSize: 22,
            ),
          ),
          crossFadeState: crossFadeState,
          duration: const Duration(
            milliseconds: 500,
          )),
    );
  }

  Future<void> editIsDone(String taskId) async {
    CollectionReference taskCollection =
        FirebaseFirestore.instance.collection(UserDM.collectionName);
    var taskDoc = taskCollection.doc(taskId);
    await taskDoc.update();
  }
}
