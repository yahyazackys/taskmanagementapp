import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sp_util/sp_util.dart';
import 'package:taskmanagementapp/controllers/task_controller.dart';
import 'package:taskmanagementapp/pages/DetailPriorityTask.dart';
import 'package:taskmanagementapp/themes/theme.dart';
import 'package:taskmanagementapp/widgets/dailyTask_widget.dart';
import 'package:taskmanagementapp/widgets/priorityTask_widget.dart';

class LandingPage extends StatefulWidget {
  LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _taskC = Get.put(TaskController());
  double percentage = 80;
  late double percentageBar;
  String _formattedDate = '';

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    _formattedDate = DateFormat('EEEE, MMM d yyyy').format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formattedDate,
                        style: brownTextStyle.copyWith(
                          fontSize: 12,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.notifications,
                          size: 24,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //   "Welcome, yahya",
                      //   style: blackTextStyle.copyWith(
                      //     fontSize: 24,
                      //     fontWeight: FontWeight.w900,
                      //   ),
                      // ),
                      Text(
                        SpUtil.getString("name_userUpdated").toString() == ""
                            ? SpUtil.getString("name_user").toString()
                            : SpUtil.getString("name_userUpdated").toString(),
                        style: blackTextStyle.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        "have a nice day !",
                        style: brownTextStyle.copyWith(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Priority Task",
                        style: blackTextStyle.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Obx(() {
                        if (_taskC.priorityList.isEmpty) {
                          return Column(
                            children: [
                              Center(
                                child: Image.asset(
                                  'assets/empty.png',
                                  height: 100,
                                ),
                              ),
                              Text(
                                "Priority Task Empty",
                                style: blackTextStyle.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          );
                        } else {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: _taskC.priorityList.map((task) {
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(DetailPriorityTask(
                                      priority: task,
                                    ));
                                  },
                                  child: PriorityWidget(priority: task),
                                );
                              }).toList(),
                            ),
                          );
                        }
                      }),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Daily Task",
                        style: blackTextStyle.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Obx(() {
                        if (_taskC.allDailyList.isEmpty) {
                          return Column(
                            children: [
                              Center(
                                child: Image.asset(
                                  'assets/empty.png',
                                  height: 100,
                                ),
                              ),
                              Text(
                                "Daily Task Empty",
                                style: blackTextStyle.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          );
                        } else {
                          return SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: _taskC.allDailyList.map((task) {
                                return DailyTaskWidget(daily: task);
                              }).toList(),
                            ),
                          );
                        }
                      }),
                      // const SizedBox(
                      //   height: 16,
                      // ),
                      // SingleChildScrollView(
                      //   scrollDirection: Axis.vertical,
                      //   child: Column(
                      //     children: [
                      //       SizedBox(
                      //         width: MediaQuery.of(context).size.width,
                      //         child: ListView.builder(
                      //           scrollDirection: Axis.vertical,
                      //           shrinkWrap: true,
                      //           itemCount: _taskC.allPriorityList.length,
                      //           itemBuilder: (context, index) {
                      //             final task = _taskC.allPriorityList[index];
                      //             return SizedBox(
                      //               width: MediaQuery.of(context).size.width,
                      //               height: 180,
                      //               child: Stack(
                      //                 children: [
                      //                   Container(
                      //                     width: MediaQuery.of(context)
                      //                         .size
                      //                         .width,
                      //                     decoration: BoxDecoration(
                      //                       color: whiteColor,
                      //                       border: Border.all(
                      //                         color: baseColor,
                      //                         width: 0.7,
                      //                       ),
                      //                       borderRadius:
                      //                           BorderRadius.circular(10),
                      //                     ),
                      //                     padding: const EdgeInsets.symmetric(
                      //                       horizontal: 20,
                      //                       vertical: 16,
                      //                     ),
                      //                     margin: const EdgeInsets.symmetric(
                      //                       vertical: 8,
                      //                     ),
                      //                     child: Column(
                      //                       crossAxisAlignment:
                      //                           CrossAxisAlignment.start,
                      //                       children: [
                      //                         Row(
                      //                           mainAxisAlignment:
                      //                               MainAxisAlignment
                      //                                   .spaceBetween,
                      //                           children: [
                      //                             Text(
                      //                               task.title,
                      //                               style: primaryTextStyle
                      //                                   .copyWith(
                      //                                 fontWeight:
                      //                                     FontWeight.w500,
                      //                                 fontSize: 14,
                      //                               ),
                      //                             ),
                      //                             SizedBox(
                      //                               width: 30,
                      //                               child: Icon(
                      //                                 Icons.more_horiz,
                      //                                 size: 26,
                      //                                 color: primaryColor,
                      //                               ),
                      //                             ),
                      //                           ],
                      //                         ),
                      //                         const SizedBox(
                      //                           height: 12,
                      //                         ),
                      //                         Text(
                      //                           task.description,
                      //                           style:
                      //                               brownTextStyle.copyWith(
                      //                             fontSize: 12,
                      //                           ),
                      //                           overflow:
                      //                               TextOverflow.ellipsis,
                      //                           maxLines: 3,
                      //                           softWrap: false,
                      //                           textAlign: TextAlign.justify,
                      //                         ),
                      //                       ],
                      //                     ),
                      //                   ),
                      //                   Positioned(
                      //                     bottom: 20,
                      //                     right: 20,
                      //                     child: Text(
                      //                       "Feb, 21 - Mar, 23",
                      //                       style: blueTextStyle.copyWith(
                      //                         fontSize: 12,
                      //                       ),
                      //                     ),
                      //                   ),
                      //                   Container(
                      //                     height: 60,
                      //                     margin: const EdgeInsets.only(
                      //                       top: 60,
                      //                     ),
                      //                     decoration: const BoxDecoration(
                      //                       border: Border(
                      //                         left: BorderSide(
                      //                           color: Colors.black,
                      //                           width: 3,
                      //                         ),
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 ],
                      //               ),
                      //             );
                      //           },
                      //         ),
                      //       ),
                      //       if (_taskC.allPriorityList.isEmpty)
                      //         Padding(
                      //           padding: const EdgeInsets.symmetric(
                      //             horizontal: 20,
                      //             vertical: 50,
                      //           ),
                      //           child: Center(
                      //             child: Text(
                      //               "Task Empty",
                      //               style: blackTextStyle.copyWith(
                      //                 fontSize: 20,
                      //                 fontWeight: FontWeight.w700,
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
