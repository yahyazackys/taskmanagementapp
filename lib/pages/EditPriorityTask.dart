import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sp_util/sp_util.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:taskmanagementapp/config/config.dart';
import 'package:taskmanagementapp/controllers/task_controller.dart';
import 'package:taskmanagementapp/home.dart';
import 'package:taskmanagementapp/models/task_model.dart';
import 'package:taskmanagementapp/pages/LandingPage.dart';
import 'package:taskmanagementapp/themes/theme.dart';
import 'package:http/http.dart' as http;

class EditPriorityTask extends StatefulWidget {
  const EditPriorityTask({Key? key, required this.priority}) : super(key: key);

  final TaskModel priority;

  @override
  State<EditPriorityTask> createState() => _EditPriorityTaskState();
}

class _EditPriorityTaskState extends State<EditPriorityTask> {
  final TaskController taskC = Get.put(TaskController());
  TextEditingController title = TextEditingController();
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController reminder = TextEditingController();
  TextEditingController repeat = TextEditingController();
  List<String> toDoList = [];
  List<bool> toDoListStatus = [];
  DateTime today = DateTime.now();
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  @override
  void initState() {
    super.initState();
    setState(() {
      title.text = widget.priority.title;
      startDate.text = widget.priority.startDate;
      endDate.text = widget.priority.endDate;
      description.text = widget.priority.description;
      reminder.text = widget.priority.reminder.substring(0, 5);
      repeat.text = widget.priority.repeat;
      toDoList = widget.priority.toDoList;
      toDoListStatus = widget.priority.toDoListStatus;
      print(toDoList);
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

  void addToDo(String item, bool status) {
    toDoList.add(item);
    toDoListStatus.add(status ? true : false);
    // update();
  }

  Future<TaskModel?> editPriorityTask() async {
    var taskId = widget.priority.id;
    var url = Uri.parse('${Config.urlApi}priority-task/edit/$taskId');

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
          // 'start_date': startDate.text,
          'end_date': endDate.text,
          'reminder': reminder.text,
          'repeat': repeat.text,
          'to_do_list': jsonEncode(toDoList),
          'to_do_list_status': jsonEncode(toDoListStatus),
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

          return TaskModel.fromJson(responseDecode);
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

  void _onStartDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      selectedStartDate = day;
    });
  }

  void _onEndDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      selectedEndDate = day;
    });
  }

  bool isBeforeToday(DateTime day) {
    final DateTime now = DateTime.now();
    return day.isBefore(DateTime(now.year, now.month, now.day));
  }

  Future<void> _showCalendarModal(BuildContext context) async {
    final DateTime? pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      builder: (BuildContext builder) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: TableCalendar(
            focusedDay: today,
            locale: "en_US",
            firstDay: DateTime.utc(2023, 1, 1),
            lastDay: DateTime(2024, 12 + 1, 0),
            calendarFormat: CalendarFormat.month,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            availableGestures: AvailableGestures.all,
            onDaySelected: (day, focusedDay) {
              Navigator.pop(context, day);
              _onStartDaySelected(day, focusedDay);
            },
            selectedDayPredicate: (day) => isSameDay(day, selectedStartDate),
            enabledDayPredicate: (day) => !isBeforeToday(day),
            calendarStyle: const CalendarStyle(
              selectedTextStyle: TextStyle(color: Colors.white),
              todayDecoration: BoxDecoration(
                color: Color(0xffC6C2C2),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Color(0xff12486B),
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        selectedStartDate = pickedDate;
        // Menggunakan format yang diharapkan oleh sistem (YYYY-MM-DD)
        startDate.text = DateFormat('yyyy-MM-dd').format(selectedStartDate!);
        print('Selected Start Date: ${startDate.text}');
      });
    }
  }

  Future<void> _showCalendarModal2(BuildContext context) async {
    final DateTime? pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      builder: (BuildContext builder) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: TableCalendar(
            focusedDay: today,
            locale: "en_US",
            firstDay: DateTime.utc(2023, 1, 1),
            lastDay: DateTime(2024, 12 + 1, 0),
            calendarFormat: CalendarFormat.month,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            availableGestures: AvailableGestures.all,
            onDaySelected: (day, focusedDay) {
              Navigator.pop(context, day);
              _onEndDaySelected(day, focusedDay);
            },
            selectedDayPredicate: (day) => isSameDay(day, selectedEndDate),
            enabledDayPredicate: (day) => !isBeforeToday(day),
            calendarStyle: const CalendarStyle(
              selectedTextStyle: TextStyle(color: Colors.white),
              todayDecoration: BoxDecoration(
                color: Color(0xffC6C2C2),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Color(0xff12486B),
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        selectedEndDate = pickedDate;
        endDate.text = DateFormat('yyyy-MM-dd').format(selectedEndDate!);
        print('Selected end Date: ${endDate.text}');
      });
    }
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
                      "Edit Task",
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
                              "Priority Task",
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Start",
                              style: primaryTextStyle.copyWith(
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            GestureDetector(
                              onTap: () {
                                // _showCalendarModal(context);
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.42,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: lightColor,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  color: baseColor,
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        // _showCalendarModal(context);
                                      },
                                      icon: Icon(
                                        Icons.calendar_month_outlined,
                                        size: 24,
                                        color: primaryColor,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: TextField(
                                        controller: startDate,
                                        enabled: false,
                                        decoration: InputDecoration(
                                          hintText: selectedStartDate != null
                                              ? DateFormat('yyyy-MM-dd')
                                                  .format(selectedStartDate!)
                                              : 'Select Start Date',
                                          border: InputBorder.none,
                                          hintStyle: primaryTextStyle,
                                        ),
                                        style: primaryTextStyle.copyWith(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "End",
                              style: primaryTextStyle.copyWith(
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            GestureDetector(
                              onTap: () {
                                _showCalendarModal2(context);
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.42,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: baseColor,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  color: whiteColor,
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        _showCalendarModal2(context);
                                      },
                                      icon: Icon(
                                        Icons.calendar_month_outlined,
                                        size: 24,
                                        color: primaryColor,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: TextField(
                                        controller: endDate,
                                        enabled: false,
                                        decoration: InputDecoration(
                                          hintText: selectedEndDate != null
                                              ? DateFormat('yyyy-MM-dd')
                                                  .format(selectedEndDate!)
                                              : 'Select End Date',
                                          border: InputBorder.none,
                                          hintStyle: primaryTextStyle,
                                        ),
                                        style: primaryTextStyle.copyWith(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "To Do List",
                              style: primaryTextStyle.copyWith(
                                fontSize: 14,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    String newToDo = '';
                                    // List<String> jsonList =
                                    //     taskC.toDoList.map((item) => '"$item"').toList();
                                    // String jsonString = '[' + jsonList.join(',') + ']';

                                    return Container(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextField(
                                            onChanged: (value) {
                                              newToDo = value;
                                            },
                                            decoration: const InputDecoration(
                                              hintText: 'Tambah To Do',
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                if (newToDo.isNotEmpty) {
                                                  addToDo(newToDo, false);
                                                  // print(jsonString);

                                                  // taskC.toDoList.clear();
                                                }
                                              });
                                              Navigator.pop(context);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: primaryColor,
                                            ),
                                            child: Text(
                                              'Add',
                                              style: whiteTextStyle,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.add,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Column(
                          children: toDoList.isEmpty
                              ? [
                                  Center(
                                    child: Image.asset(
                                      'assets/empty.png',
                                      height: 100,
                                    ),
                                  ),
                                ]
                              : [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: toDoList.map((item) {
                                      final index = toDoList.indexOf(item);

                                      return Container(
                                        decoration: BoxDecoration(
                                          color: whiteColor,
                                          border: Border.all(
                                            color: baseColor,
                                            width: 0.2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 16),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              toDoList[index],
                                              style: primaryTextStyle.copyWith(
                                                  fontSize: 15),
                                              textAlign: TextAlign.center,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  toDoList.removeAt(index);
                                                  toDoListStatus
                                                      .removeAt(index);
                                                });
                                              },
                                              child: Icon(
                                                Icons.delete,
                                                size: 24,
                                                color: primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    toDoList.isEmpty
                        ? InkWell(
                            onTap: null,
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                color: baseColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: taskC.isLoading == true
                                    ? CircularProgressIndicator(
                                        color: whiteColor,
                                      )
                                    : Text(
                                        'Submit',
                                        style: sub2TextStyle.copyWith(
                                            fontWeight: FontWeight.bold),
                                      ),
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              editPriorityTask();
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
