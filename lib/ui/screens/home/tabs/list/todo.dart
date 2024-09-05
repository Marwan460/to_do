import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo/model/todo_dm.dart';
import 'package:todo/ui/utils/app_colors.dart';
import 'package:todo/ui/utils/app_style.dart';

class Todo extends StatefulWidget {
  final TodoDM? task;
  final TodoDM item;

  const Todo({
    super.key,
    required this.item,
    this.task,
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
        SlidableAction(
          onPressed: (context) {},
          label: "delete",
          backgroundColor: Colors.red,
          icon: Icons.delete,
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24), topLeft: Radius.circular(24)),
        )
      ]),
      endActionPane: ActionPane(motion: const BehindMotion(), children: [
        SlidableAction(
          onPressed: (context) {},
          foregroundColor: AppColors.white,
          label: "Edit",
          backgroundColor: Colors.teal,
          icon: Icons.edit,
          borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(24), topRight: Radius.circular(24)),
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
          color: AppColors.primary, borderRadius: BorderRadius.circular(4)),
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
            widget.item.title,
            maxLines: 1,
            style: AppStyle.todoTextStyle,
          ),
          const Spacer(),
          Text(
            widget.item.description,
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
}
