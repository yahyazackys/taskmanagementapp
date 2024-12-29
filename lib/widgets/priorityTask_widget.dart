import 'package:flutter/material.dart';
import 'package:taskmanagementapp/themes/theme.dart';

import '../models/task_model.dart';

// ignore: must_be_immutable
class PriorityWidget extends StatelessWidget {
  final TaskModel priority;

  const PriorityWidget({required this.priority, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<bool>? toDoListStatus = priority.toDoListStatus;

    DateTime endDate = DateTime.parse(priority.endDate);
    DateTime currentDate = DateTime.now();
    int remainingDays = endDate.difference(currentDate).inDays;
    int completedTasks = 0;
    for (bool status in toDoListStatus) {
      if (status) {
        completedTasks++;
      }
    }

    int totalTasks = toDoListStatus.length;
    double percentageBar = totalTasks > 0 ? completedTasks / totalTasks : 0.0;

    return Container(
      width: MediaQuery.of(context).size.width * 0.33,
      margin: const EdgeInsets.only(
        right: 20,
      ),
      height: 200,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$remainingDays days',
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Text(
            priority.title,
            style: whiteTextStyle.copyWith(
                fontSize: 14, fontWeight: FontWeight.w700),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Progress',
                style: whiteTextStyle.copyWith(
                  fontSize: 11,
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  backgroundColor: blackColor,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    whiteColor,
                  ),
                  value: percentageBar,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${(percentageBar * 100).toInt()}%',
                  style: whiteTextStyle.copyWith(
                    fontSize: 11,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
