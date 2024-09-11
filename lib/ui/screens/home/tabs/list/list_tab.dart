import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:todo/ui/screens/home/tabs/list/todo.dart';
import 'package:todo/ui/utils/date_time_extension.dart';
import '../../../../../model/todo_dm.dart';
import '../../../../../model/user_dm.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_style.dart';

class ListTab extends StatefulWidget {
  const ListTab({super.key});

  @override
  State<ListTab> createState() => ListTabState();
}

class ListTabState extends State<ListTab> {
  DateTime selectedCalenderDate = DateTime.now();
  List<TodoDM> todosList = [];

  @override
  void initState() {
    super.initState();
    getTodosListFromFireStore();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildCalender(),
        Expanded(
          flex: 75,
          child: ListView.builder(
              itemCount: todosList.length,
              itemBuilder: (context, index) {
                return Todo(task: todosList[index]);
              }),
        )
      ],
    );
  }

  buildCalender() {
    return Expanded(
      flex: 25,
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                  child: Container(
                color: AppColors.primary,
              )),
              Expanded(
                  child: Container(
                color: AppColors.bgColor,
              ))
            ],
          ),
          EasyInfiniteDateTimeLine(
              firstDate: DateTime.now().subtract(const Duration(days: 365)),
              focusDate: selectedCalenderDate,
              lastDate: DateTime.now().add(const Duration(days: 365)),
              itemBuilder: (context, date, isSelected, onTap) {
                return InkWell(
                  onTap: () {
                      selectedCalenderDate = date;
                      getTodosListFromFireStore();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(22)),
                    child: Column(
                      children: [
                        const Spacer(),
                        Text(
                          date.dayName,
                          style: isSelected
                              ? AppStyle.selectedCalendarDayStyle
                              : AppStyle.unSelectedCalendarDayStyle,
                        ),
                        const Spacer(),
                        Text(
                          date.day.toString(),
                          style: isSelected
                              ? AppStyle.selectedCalendarDayStyle
                              : AppStyle.unSelectedCalendarDayStyle,
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }

  void getTodosListFromFireStore() async {
    CollectionReference todoCollection =
    FirebaseFirestore.instance
        .collection(UserDM.collectionName)
        .doc(UserDM.currentUser!.userId)
        .collection(TodoDM.collectionName);
    QuerySnapshot querySnapshot = await todoCollection.get();
    List<QueryDocumentSnapshot> documents = querySnapshot.docs;
    todosList = documents.map((doc) {
      Map<String, dynamic> json = doc.data() as Map<String, dynamic>;
      return TodoDM.fromJson(json);
    }).toList();
    todosList = todosList
        .where((todo) =>
            todo.date.year == selectedCalenderDate.year &&
            todo.date.month == selectedCalenderDate.month &&
            todo.date.day == selectedCalenderDate.day)
        .toList();
    setState(() {});
  }
}
