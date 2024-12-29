import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskmanagementapp/controllers/task_controller.dart';
import 'package:taskmanagementapp/themes/theme.dart';

class DailyTaskFormWidget extends StatefulWidget {
  const DailyTaskFormWidget({super.key});

  @override
  State<DailyTaskFormWidget> createState() => _DailyTaskFormWidgetState();
}

class _DailyTaskFormWidgetState extends State<DailyTaskFormWidget> {
  final TaskController taskC = Get.put(TaskController());

  String selectedRepeat = 'Every Day';
  // TimeOfDay? selectedTime = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay? selectedTime;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.inputOnly,
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        taskC.reminder.text = selectedTime?.format(context) ?? 'Select Time';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Title",
              style: primaryTextStyle.copyWith(
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: taskC.title,
                style: blackTextStyle.copyWith(
                  fontSize: 12,
                ),
                decoration: const InputDecoration(
                  hintStyle: TextStyle(fontSize: 13),

                  // hintText: 'Nama Lengkap',
                  iconColor: Color(0xff8D92A3),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(15),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 28,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Description",
              style: primaryTextStyle.copyWith(
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: taskC.description,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: blackTextStyle.copyWith(
                  fontSize: 12,
                ),
                decoration: const InputDecoration(
                  hintStyle: TextStyle(fontSize: 13),

                  // hintText: 'Nama Lengkap',
                  iconColor: Color(0xff8D92A3),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(15),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 28,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Reminder",
              style: primaryTextStyle.copyWith(
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: baseColor,
                ),
                borderRadius: BorderRadius.circular(10),
                color: whiteColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      _selectTime(context);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 24,
                          color: primaryColor,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: TextField(
                            controller: taskC.reminder,
                            enabled: false,
                            decoration: InputDecoration(
                              hintText:
                                  '${selectedTime?.format(context) ?? 'Select Time'}',
                              border: InputBorder.none,
                              hintStyle: primaryTextStyle.copyWith(
                                fontSize: 12,
                              ),
                            ),
                            style: primaryTextStyle.copyWith(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: TextField(
                      controller: taskC.repeat,
                      enabled: false,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: selectedRepeat,
                        border: InputBorder.none,
                        hintStyle: primaryTextStyle.copyWith(
                          fontSize: 12,
                        ),
                      ),
                      style: primaryTextStyle.copyWith(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        InkWell(
          onTap: () {
            taskC.addDailyTask();
          },
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: taskC.isLoading == true
                  ? CircularProgressIndicator(
                      color: whiteColor,
                    )
                  : Text(
                      'Submit',
                      style:
                          whiteTextStyle.copyWith(fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
