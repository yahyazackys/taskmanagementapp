import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:taskmanagementapp/controllers/task_controller.dart';
import 'package:taskmanagementapp/themes/theme.dart';

class PriorityTaskFormWidget extends StatefulWidget {
  const PriorityTaskFormWidget({super.key});

  @override
  State<PriorityTaskFormWidget> createState() => _PriorityTaskFormWidgetState();
}

class _PriorityTaskFormWidgetState extends State<PriorityTaskFormWidget> {
  final TaskController taskC = Get.put(TaskController());
  DateTime today = DateTime.now();
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  TimeOfDay? selectedTime;
  String selectedRepeat = 'Select Repeat';

  @override
  void initState() {
    super.initState();
    selectedStartDate = null;
    selectedEndDate = null;
  }

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

  Future<void> _selectRepeat(BuildContext context) async {
    String? selectedValue = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Repeat Reminder'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Every Day'),
                onTap: () {
                  Navigator.pop(context, 'Every Day');
                },
              ),
              ListTile(
                title: Text('Every 3 Days'),
                onTap: () {
                  Navigator.pop(context, '3 Days');
                },
              ),
              ListTile(
                title: Text('Every 7 Days'),
                onTap: () {
                  Navigator.pop(context, '7 Days');
                },
              ),
              // Tambahkan opsi lainnya sesuai kebutuhan
            ],
          ),
        );
      },
    );

    if (selectedValue != null) {
      setState(() {
        selectedRepeat = selectedValue;
        taskC.repeat.text = selectedRepeat;
      });
    }
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
        taskC.startDate.text =
            DateFormat('yyyy-MM-dd').format(selectedStartDate!);
        print('Selected Start Date: ${taskC.startDate.text}');
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
        taskC.endDate.text = DateFormat('yyyy-MM-dd').format(selectedEndDate!);
        print('Selected end Date: ${taskC.endDate.text}');
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
                    _showCalendarModal(context);
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
                            _showCalendarModal(context);
                          },
                          icon: Icon(
                            Icons.calendar_month_outlined,
                            size: 24,
                            color: primaryColor,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: TextField(
                            controller: taskC.startDate,
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
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: TextField(
                            controller: taskC.endDate,
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
              padding: EdgeInsets.symmetric(
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
                        SizedBox(
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
                  InkWell(
                    onTap: () {
                      _selectRepeat(context);
                    },
                    child: SizedBox(
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
                Row(
                  children: [
                    Text(
                      "To Do List",
                      style: primaryTextStyle.copyWith(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    String? newToDo; // Atur nilai awal sebagai null
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                onChanged: (value) {
                                  newToDo =
                                      value; // Update nilai newToDo saat ada perubahan pada TextField
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
                                    if (newToDo != null &&
                                        newToDo!.isNotEmpty) {
                                      taskC.addToDo(newToDo!, false);
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
                children: taskC.toDoList.isEmpty
                    ? [
                        Center(
                          child: Image.asset(
                            'assets/empty.png',
                            height: 100,
                          ),
                        ),
                      ]
                    : taskC.toDoList.map((item) {
                        final index = taskC.toDoList.indexOf(item);

                        return Container(
                          decoration: BoxDecoration(
                            color: whiteColor,
                            border: Border.all(
                              color: baseColor,
                              width: 0.2,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item,
                                style: primaryTextStyle.copyWith(fontSize: 15),
                                textAlign: TextAlign.center,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    taskC.toDoList.removeAt(index);
                                    taskC.toDoListStatus.removeAt(index);
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
                      }).toList()),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        taskC.toDoList.isEmpty
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
                  taskC.addPriorityTask();
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
    );
  }
}
