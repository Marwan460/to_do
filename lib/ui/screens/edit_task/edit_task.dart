import 'package:flutter/material.dart';
import 'package:todo/ui/utils/app_colors.dart';

import '../../../model/user_dm.dart';
import '../../utils/app_style.dart';

class EditTask extends StatelessWidget {
  static const String routeName = "editTask";

  const EditTask({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome ${UserDM.currentUser!.userName}",
            style: AppStyle.appBarStyle),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 33,
          vertical: 115,
        ),
        child: Container(
          decoration: BoxDecoration(
              color: AppColors.white, borderRadius: BorderRadius.circular(15)),
          height: MediaQuery.of(context).size.height * 0.7,
          width: MediaQuery.of(context).size.width * 0.85,
          child: Column(
            children: [
              Text(
                "Edit Task",
                style:
                    AppStyle.titlesTextStyle.copyWith(color: AppColors.black),
              ),
              TextField(
                decoration: InputDecoration(label: Text("title")),
              ),
              TextField(
                decoration: InputDecoration(label: Text("description")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
