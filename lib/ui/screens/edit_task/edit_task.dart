import 'package:flutter/material.dart';
import 'package:todo/ui/screens/home/tabs/setting.dart';
import 'package:todo/ui/utils/app_colors.dart';
import 'package:todo/ui/utils/date_time_extension.dart';
import '../../../model/todo_dm.dart';
import '../../../model/user_dm.dart';
import '../../utils/app_style.dart';
import '../home/tabs/list/list_tab.dart';

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
  GlobalKey<ListTabState> listTabKey = GlobalKey();
  List<Widget> tabs = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      var taskModel = ModalRoute.of(context)!.settings.arguments as TodoDM;
      titleController.text = taskModel.title;
      descriptionController.text = taskModel.description;
      selectedDate = taskModel.date;
    });
    super.initState();
    tabs = [
      ListTab(
        key: listTabKey,
      ),
      const Setting()
    ];
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
                          showMyDatePicker();
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
                          onPressed: () async {
                            widget.task?.title = titleController.text;
                            widget.task?.description =
                                descriptionController.text;
                            widget.task?.date = selectedDate;
                            await listTabKey.currentState
                                ?.getTodosListFromFireStore();
                            Navigator.pop(context);
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

  Future<void> showMyDatePicker() async {
    selectedDate = await showDatePicker(
            context: context,
            initialDate: selectedDate,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 365))) ??
        selectedDate;
    setState(() {});
  }

// Future<void> editTask() async {
//   CollectionReference todoCollection = FirebaseFirestore.instance
//       .collection(UserDM.collectionName)
//       .doc(UserDM.currentUser!.userId)
//       .collection(TodoDM.collectionName);
//   var taskDoc = todoCollection.doc(widget.task?.taskId);
//   await taskDoc.update(widget.task?.toJason());
//   print("taskdoc:$taskDoc");
// }
}
