import 'package:flutter/material.dart';
import 'package:taskmanagementapp/themes/theme.dart';
import 'package:taskmanagementapp/widgets/dailyTaskForm_widget.dart';
import 'package:taskmanagementapp/widgets/priorityTaskForm_widget.dart';

class AddTaskFormWidget extends StatefulWidget {
  const AddTaskFormWidget({super.key});

  @override
  State<AddTaskFormWidget> createState() => _AddTaskFormWidgetState();
}

class _AddTaskFormWidgetState extends State<AddTaskFormWidget> {
  bool priorityToggled = true;
  bool dailyToggled = false;

  void priorityToggleButton() {
    setState(() {
      if (!priorityToggled) {
        priorityToggled = true;
        dailyToggled = false;
      }
    });
  }

  void dailyToggleButton() {
    setState(() {
      if (!dailyToggled) {
        dailyToggled = true;
        priorityToggled = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Category",
              style: primaryTextStyle.copyWith(
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: GestureDetector(
                    onTap: priorityToggleButton,
                    child: priorityToggled
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              border: Border.all(
                                color: baseColor,
                                width: 0.2,
                              ),
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              // horizontal: 20,
                              vertical: 16,
                            ),
                            child: Text(
                              "Priority Task",
                              style: whiteTextStyle.copyWith(
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: whiteColor,
                              border: Border.all(
                                color: baseColor,
                                width: 0.2,
                              ),
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              // horizontal: 20,
                              vertical: 16,
                            ),
                            child: Text(
                              "Priority Task",
                              style: primaryTextStyle.copyWith(
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Flexible(
                  flex: 1,
                  child: GestureDetector(
                      onTap: dailyToggleButton,
                      child: dailyToggled
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                border: Border.all(
                                  color: baseColor,
                                  width: 0.2,
                                ),
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                // horizontal: 20,
                                vertical: 16,
                              ),
                              child: Text(
                                "Daily Task",
                                style: whiteTextStyle.copyWith(
                                  fontSize: 15,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: whiteColor,
                                border: Border.all(
                                  color: baseColor,
                                  width: 0.2,
                                ),
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                // horizontal: 20,
                                vertical: 16,
                              ),
                              child: Text(
                                "Daily Task",
                                style: primaryTextStyle.copyWith(
                                  fontSize: 15,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 28,
        ),
        priorityToggled
            ? const PriorityTaskFormWidget()
            : const DailyTaskFormWidget(),
      ],
    );
  }
}
