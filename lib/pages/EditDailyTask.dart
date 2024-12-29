import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sp_util/sp_util.dart';
import 'package:taskmanagementapp/config/config.dart';
import 'package:taskmanagementapp/controllers/task_controller.dart';
import 'package:taskmanagementapp/home.dart';
import 'package:taskmanagementapp/models/daily_model.dart';
import 'package:taskmanagementapp/pages/LandingPage.dart';
import 'package:taskmanagementapp/themes/theme.dart';
import 'package:http/http.dart' as http;

class EditDailyTask extends StatefulWidget {
  const EditDailyTask({Key? key, required this.daily}) : super(key: key);

  final DailyTaskModel daily;

  @override
  State<EditDailyTask> createState() => _EditDailyTaskState();
}

class _EditDailyTaskState extends State<EditDailyTask> {
  final TaskController taskC = Get.put(TaskController());
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController reminder = TextEditingController();
  TextEditingController repeat = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      title.text = widget.daily.title;
      description.text = widget.daily.description;
      reminder.text = widget.daily.reminder.substring(0, 5);
      repeat.text = widget.daily.repeat;
    });
  }

  TimeOfDay? selectedTime = const TimeOfDay(hour: 0, minute: 0);
  String selectedRepeat = 'Every Day';

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.inputOnly,
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        reminder.text = selectedTime!.format(context);
      });
    }
  }

  Future<DailyTaskModel?> editDailyTask() async {
    var taskId = widget.daily.id;
    var url = Uri.parse('${Config.urlApi}daily-task/edit/$taskId');

    try {
      await SpUtil.getInstance();
      String token = SpUtil.getString("token_user") ?? "";
      if (token.isNotEmpty) {
        // Token memiliki isi, lakukan sesuatu di sini
        final response = await http.post(url, headers: {
          'Authorization': 'Bearer $token',
        }, body: {
          'title': title.text,
          'description': description.text,
          'reminder': reminder.text,
        });
        print(response.body);

        var responseDecode = json.decode(response.body);

        Map<String, dynamic> dataError = responseDecode["data"];
        print(dataError);

        if (response.statusCode == 200) {
          setState(() {
            // Update variabel dengan data terbaru
            title.text = responseDecode["data"]["title"];
            description.text = responseDecode["data"]["description"];
            reminder.text = responseDecode["data"]["reminder"].substring(0, 5);
            repeat.text = responseDecode["data"]["repeat"];
          });

          Get.snackbar(
            "Success",
            responseDecode["message"],
            snackPosition: SnackPosition.TOP,
            backgroundColor: primaryColor,
            colorText: Colors.white,
          );

          Get.offAll(Home(
            initialScreen: LandingPage(),
            onTabChanged: 0,
          ));

          return DailyTaskModel.fromJson(responseDecode);
        } else {
          Get.snackbar(
            "Error",
            responseDecode["message"] == "Error Validation"
                ? dataError.toString()
                : responseDecode["message"],
            margin: const EdgeInsets.all(10),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          throw Exception('Failed to edit user: ${response.statusCode}');
        }
      } else {
        throw Exception('Empty Token!');
      }
    } catch (e) {}
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColor,
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: primaryColor,
            ),
            child: SafeArea(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                margin: const EdgeInsets.only(
                  bottom: 760,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: 0,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: whiteColor,
                        ),
                        child: IconButton(
                          onPressed: () {
                            taskC.clearAddTask();
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back_sharp,
                            size: 20,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "Add Task",
                      style: whiteTextStyle.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.only(
              top: 60,
              bottom: 60,
              right: 20,
              left: 20,
            ),
            decoration: BoxDecoration(
              color: lightColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(60),
                topRight: Radius.circular(60),
              ),
            ),
            margin: const EdgeInsets.only(
              top: 160,
            ),
            child: ListView(
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
                          child: Container(
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
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 28,
                ),
                Column(
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
                            controller: title,
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
                            controller: description,
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
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: TextField(
                                        controller: reminder,
                                        enabled: false,
                                        decoration: InputDecoration(
                                          hintText:
                                              selectedTime!.format(context),
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
                                  controller: repeat,
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
                        editDailyTask();
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
          ),
        ],
      ),
    );
  }
}
