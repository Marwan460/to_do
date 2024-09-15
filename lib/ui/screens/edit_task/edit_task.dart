import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo/ui/utils/app_colors.dart';
import 'package:todo/ui/utils/date_time_extension.dart';
import 'package:todo/ui/utils/todo_dao.dart';

import '../../../model/todo_dm.dart';
import '../../../model/user_dm.dart';
import '../../utils/app_style.dart';

class EditTask extends StatefulWidget {
  static const String routeName = "editTask";
  final TodoDM? task;

  const EditTask({
    super.key,
    this.task,
  });

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  DateTime selectedDate = DateTime.now();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      var taskModel = ModalRoute.of(context)!.settings.arguments as TodoDM;
      titleController.text = taskModel.title;
      descriptionController.text = taskModel.description;
      selectedDate = taskModel.date;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome ${UserDM.currentUser!.userName}",
            style: AppStyle.appBarStyle),
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            decoration: const BoxDecoration(
              color: AppColors.primary,
            ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * .08,
                vertical: MediaQuery.of(context).size.height * .05,
              ),
              child: Container(
                decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(15)),
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width * 0.85,
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Edit Task",
                        style: AppStyle.bottomSheetTitle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      TextField(
                        decoration: const InputDecoration(hintText: "title"),
                        controller: titleController,
                      ),
                      const SizedBox(height: 30),
                      TextField(
                        decoration:
                            const InputDecoration(hintText: "description"),
                        controller: descriptionController,
                      ),
                      const SizedBox(height: 30),
                      Text("Select date",
                          style:
                              AppStyle.bottomSheetTitle.copyWith(fontSize: 16)),
                      const SizedBox(height: 30),
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
                      const SizedBox(
                        height: 100,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            editTask();
                            setState(() {});
                          },
                          style: ButtonStyle(
                            shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25))),
                          ),
                          child: const Text("Save Changes")),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Future<void> editTask() async {
    CollectionReference todoCollection = FirebaseFirestore.instance
        .collection(UserDM.collectionName)
        .doc(UserDM.currentUser!.userId)
        .collection(TodoDM.collectionName);
    var taskDoc = todoCollection.doc(widget.task?.taskId);
    await taskDoc.update(widget.task?.toJason());
    print("taskdoc:$taskDoc");
  }
}
