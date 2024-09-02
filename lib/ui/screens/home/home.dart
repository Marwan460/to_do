import 'package:flutter/material.dart';
import 'package:todo/ui/screens/home/tabs/list/list_tab.dart';
import 'package:todo/ui/screens/home/tabs/setting.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_style.dart';
import '../add_bottom_sheet/add_bottom_sheet.dart';

class Home extends StatefulWidget {
  static const String routeName = "home";

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;
  GlobalKey<ListTabState> listTabKey = GlobalKey();
  List<Widget> tabs = [];

  @override
  void initState() {
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
        title: const Text("To Do List", style: AppStyle.appBarStyle),
      ),
      body: tabs[currentIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: buildFab(),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  Widget buildBottomNavigationBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 10,
      clipBehavior: Clip.hardEdge,
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (tappedIndex) {
          currentIndex = tappedIndex;
          setState(() {});
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "List"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "setting"),
        ],
      ),
    );
  }

  buildFab() => FloatingActionButton(
        onPressed: () async {
          await AddBottomSheet.show(context);
          listTabKey.currentState?.getTodosListFromFireStore();
        },
        backgroundColor: AppColors.primary,
        shape: const StadiumBorder(
            side: BorderSide(color: AppColors.white, width: 4)),
        child: const Icon(Icons.add),
      );
}
