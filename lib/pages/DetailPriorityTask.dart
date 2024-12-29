// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskmanagementapp/controllers/task_controller.dart';
import 'package:taskmanagementapp/models/task_model.dart';
import 'package:taskmanagementapp/themes/theme.dart';
import 'package:intl/intl.dart';

class DetailPriorityTask extends StatefulWidget {
  const DetailPriorityTask({Key? key, required this.priority})
      : super(key: key);
  final TaskModel priority;

  @override
  State<DetailPriorityTask> createState() => _DetailPriorityTaskState();
}

class _DetailPriorityTaskState extends State<DetailPriorityTask> {
  final _taskC = Get.put(TaskController());
  @override
  void initState() {
    super.initState();
    setState(() {
      _fetchPriorityTaskById();
    });
  }

  Future<void> _fetchPriorityTaskById() async {
    _taskC.fetchPriorityTaskById(widget.priority.id);
  }

  bool isToggled = false;

  @override
  Widget build(BuildContext context) {
    List<String>? toDoList = widget.priority.toDoList;
    List<bool>? toDoListStatus = widget.priority.toDoListStatus;

    int completedTasks = 0;
    for (bool status in toDoListStatus) {
      if (status) {
        completedTasks++;
      }
    }

    int totalTasks = toDoListStatus.length;
    double percentageBar = totalTasks > 0 ? completedTasks / totalTasks : 0.0;

    void toggleButton(int index) {
      setState(() {
        toDoListStatus[index] = !toDoListStatus[index];
        // Jika widget tidak diperbarui setelah pembaruan status, pastikan untuk memanggil fungsi setState pada akhir
        _taskC.updateToDoListStatus(widget.priority.id, toDoListStatus);
      });
    }

    DateTime createdAt = widget.priority.createdAt.toLocal();
    DateTime malaysiaTime = createdAt.add(Duration(hours: 8));
    DateTime startDate = DateTime.parse(widget.priority.startDate);
    DateTime endDate = DateTime.parse(widget.priority.endDate);
    DateTime currentDate = DateTime.now();

    int remainingMonths = (endDate.year - currentDate.year) * 12 +
        endDate.month -
        currentDate.month;
    int remainingDays = endDate.day - currentDate.day;
    int remainingHours = malaysiaTime.hour - DateTime.now().hour;

    if (remainingDays < 0) {
      remainingMonths--;
      remainingDays += DateTime(currentDate.year, currentDate.month + 1, 0).day;
    }

    if (remainingHours < 0) {
      remainingDays--;
      remainingHours += 24;
    }

    return Scaffold(
      backgroundColor: lightColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GetBuilder<TaskController>(
                    builder: (controller) {
                      return Text(
                        controller.priorityTaskById?.title ?? 'No data',
                        style: primaryTextStyle.copyWith(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                  GestureDetector(
                    onTap: (() {
                      Navigator.pop(context);
                    }),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.clear,
                        size: 20,
                        color: whiteColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ListView(
                shrinkWrap: true,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "start",
                                style: brownTextStyle.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              GetBuilder<TaskController>(
                                builder: (controller) {
                                  return Text(
                                    DateFormat('d MMM yyyy')
                                        .format(DateTime.parse(
                                      widget.priority.startDate,
                                    )),
                                    style: brownTextStyle.copyWith(
                                      fontSize: 13,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "end",
                                style: brownTextStyle.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              GetBuilder<TaskController>(
                                builder: (controller) {
                                  return Text(
                                    DateFormat('d MMM yyyy').format(
                                        DateTime.parse(
                                            widget.priority.endDate)),
                                    style: brownTextStyle.copyWith(
                                      fontSize: 13,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.28,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 20,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "$remainingMonths",
                                    style: whiteTextStyle.copyWith(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "months",
                                    style: whiteTextStyle.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.28,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 20,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "$remainingDays",
                                    style: whiteTextStyle.copyWith(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "days",
                                    style: whiteTextStyle.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.28,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 20,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "$remainingHours",
                                    style: whiteTextStyle.copyWith(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "hours",
                                    style: whiteTextStyle.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      Text(
                        "Description",
                        style: brownTextStyle.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      GetBuilder<TaskController>(
                        builder: (controller) {
                          return Text(
                            controller.priorityTaskById?.description ??
                                'No data',
                            style: brownTextStyle.copyWith(
                              fontWeight: FontWeight.w100,
                            ),
                            textAlign: TextAlign.justify,
                          );
                        },
                      ),
                      const SizedBox(
                        height: 28,
                      ),
                      Text(
                        "Progress",
                        style: brownTextStyle.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Stack(
                        children: [
                          SizedBox(
                            height: 24,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: LinearProgressIndicator(
                                backgroundColor: baseColor,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  primaryColor,
                                ),
                                value: percentageBar,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: Center(
                              child: Text(
                                '${(percentageBar * 100).toInt()}%',
                                style: whiteTextStyle.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 28,
                      ),
                      Text(
                        "To do list",
                        style: brownTextStyle.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: toDoList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(
                              bottom: 16,
                            ),
                            decoration: BoxDecoration(
                              color: whiteColor,
                              border: Border.all(
                                color: baseColor,
                                width: 0.2,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  toDoList[index],
                                  style: primaryTextStyle.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    toggleButton(index);
                                  },
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: primaryColor,
                                        width: 2.0,
                                      ),
                                      color: toDoListStatus[index]
                                          ? primaryColor
                                          : Colors.white,
                                    ),
                                    child: toDoListStatus[index]
                                        ? Center(
                                            child: Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: whiteColor,
                                                  width: 1,
                                                ),
                                              ),
                                            ),
                                          )
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      InkWell(
                        onTap: () {
                          _taskC.endPriorityTask(widget.priority.id);
                        },
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: _taskC.isLoading == true
                                ? CircularProgressIndicator(
                                    color: whiteColor,
                                  )
                                : Text(
                                    'End Task',
                                    style: whiteTextStyle.copyWith(
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ),
                      ),
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
