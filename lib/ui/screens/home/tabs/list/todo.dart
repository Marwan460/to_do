import 'package:flutter/material.dart';
import 'package:todo/model/todo_dm.dart';
import 'package:todo/ui/utils/app_colors.dart';
import 'package:todo/ui/utils/app_style.dart';

class Todo extends StatelessWidget {
  final TodoDM item;

  const Todo({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            item.title,
            maxLines: 1,
            style: AppStyle.todoTextStyle,
          ),
          const Spacer(),
          Text(
            item.description,
            style: AppStyle.bodyTextStyle,
          ),
          const Spacer()
        ],
      ),
    );
  }

  buildTodoState() {
    return Container(
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
    );
  }
}
