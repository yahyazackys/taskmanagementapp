import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskmanagementapp/controllers/task_controller.dart';
import 'package:taskmanagementapp/pages/Calendar.dart';
import 'package:taskmanagementapp/pages/LandingPage.dart';
import 'package:taskmanagementapp/pages/Profile.dart';
import 'package:taskmanagementapp/pages/ProgressTask.dart';
import 'package:taskmanagementapp/themes/theme.dart';

class Home extends StatefulWidget {
  final Widget initialScreen;
  final int onTabChanged;
  const Home(
      {Key? key, required this.initialScreen, required this.onTabChanged})
      : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _taskC = Get.put(TaskController());
  late Widget currentScreen;
  int currentTab = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      _taskC.fetchAllPriority();
      _taskC.fetchAllDaily();
      _taskC.fetchPriority();
      _taskC.fetchUpComingPriority();
      _taskC.fetchDonePriority();
    });
    currentScreen = widget.initialScreen;
    currentTab = widget.onTabChanged;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: currentScreen,
      bottomNavigationBar: BottomAppBar(
        color: whiteColor,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Home
              IconButton(
                onPressed: () {
                  setState(() {
                    currentScreen = LandingPage();
                    currentTab = 0;
                  });
                },
                icon: Icon(
                  Icons.home,
                  size: 30,
                  color:
                      currentTab == 0 ? primaryColor : const Color(0xffF1EAFF),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    currentScreen = Calendar();
                    currentTab = 1;
                  });
                },
                icon: Icon(
                  Icons.calendar_month_outlined,
                  size: 30,
                  color:
                      currentTab == 1 ? primaryColor : const Color(0xffF1EAFF),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    currentScreen = const ProgressTask();
                    currentTab = 2;
                  });
                },
                icon: Icon(
                  Icons.analytics_outlined,
                  size: 30,
                  color:
                      currentTab == 2 ? primaryColor : const Color(0xffF1EAFF),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    currentScreen = const Profile();
                    currentTab = 3;
                  });
                },
                icon: Icon(
                  Icons.person_3_rounded,
                  size: 30,
                  color:
                      currentTab == 3 ? primaryColor : const Color(0xffF1EAFF),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
