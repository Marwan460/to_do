import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo/model/todo_dm.dart';
import 'package:todo/model/user_dm.dart';
import 'package:todo/ui/utils/date_time_extension.dart';
import 'package:todo/ui/utils/todo_dao.dart';
import '../../utils/app_style.dart';

class AddBottomSheet extends StatefulWidget {
  const AddBottomSheet({super.key});

  @override
  State<AddBottomSheet> createState() => _AddBottomSheetState();

  static Future show(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: const AddBottomSheet(),
          );
        });
  }
}

class _AddBottomSheetState extends State<AddBottomSheet> {
  DateTime selectedDate = DateTime.now();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Add new task",
            style: AppStyle.bottomSheetTitle,
            textAlign: TextAlign.center,
          ),
          TextField(
            decoration: const InputDecoration(hintText: "Enter task title"),
            controller: titleController,
          ),
          const SizedBox(height: 10),
          TextField(
            decoration:
                const InputDecoration(hintText: "Enter task description"),
            controller: descriptionController,
          ),
          const SizedBox(height: 10),
          Text("Select date",
              style: AppStyle.bottomSheetTitle.copyWith(fontSize: 16)),
          const SizedBox(height: 10),
          InkWell(
            onTap: () {
              TodoDao.showMyDatePicker(context);
            },
            child: Text(
              selectedDate.toFormattedDate,
              style: AppStyle.normalGreyTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
          ElevatedButton(
              onPressed: () {
                TodoDao.addTodoToFireStore(
                    context, titleController, descriptionController);
                setState(() {});
              },
              child: const Text("Add")),
        ],
      ),
    );
  }

}
