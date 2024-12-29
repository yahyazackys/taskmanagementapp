import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:taskmanagementapp/controllers/task_controller.dart';
import 'package:taskmanagementapp/pages/AddTask.dart';
import 'package:taskmanagementapp/pages/EditDailyTask.dart';
import 'package:taskmanagementapp/pages/EditPriorityTask.dart';
import 'package:taskmanagementapp/themes/theme.dart';

class Calendar extends StatefulWidget {
  Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final _taskC = Get.put(TaskController());

  DateTime today = DateTime.now();
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = today;
  }

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
      selectedDate = day;
    });
  }

  // Fungsi untuk menampilkan kalender sebagai modal
  Future<void> _showCalendarModal(BuildContext context) async {
    final DateTime? pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      builder: (BuildContext builder) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: TableCalendar(
            focusedDay: today,
            locale: "en_US",
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime(2024, 12 + 1, 0),
            calendarFormat: CalendarFormat.month,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            availableGestures: AvailableGestures.all,
            onDaySelected: (day, focusedDay) {
              Navigator.pop(context, day);
              _onDaySelected(day, focusedDay);
            },
            selectedDayPredicate: (day) => isSameDay(day, today),
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

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColor,
      body: SafeArea(
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
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
                        Text(
                          '${DateFormat.MMMM().format(selectedDate)}, ${DateFormat.y().format(selectedDate)}',
                          style: primaryTextStyle.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddTask(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.add,
                                color: whiteColor,
                                size: 20,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                'Add Task',
                                style: whiteTextStyle.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 72,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount:
                          daysInMonth(selectedDate.year, selectedDate.month),
                      itemBuilder: (context, index) {
                        DateTime date = DateTime(
                            selectedDate.year, selectedDate.month, index + 1);

                        return DateItem(
                          date: date,
                          isToday: isToday(date),
                          isSelected: isSameDay(selectedDate, date),
                          onSelect: () {
                            setState(() {
                              selectedDate = date;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    indicatorColor: primaryColor,
                    indicator: const UnderlineTabIndicator(
                        borderSide: BorderSide(width: 1.5),
                        insets: EdgeInsets.symmetric(horizontal: 96)),
                    tabs: [
                      Tab(
                        child: Text(
                          'Priority Task',
                          style: primaryTextStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Daily Task',
                          style: primaryTextStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: TabBarView(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              if (_taskC.allPriorityList.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 50,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Task Empty",
                                      style: blackTextStyle.copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 520,
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: _taskC.allPriorityList.length,
                                  itemBuilder: (context, index) {
                                    final task = _taskC.allPriorityList[index];
                                    DateTime startDate =
                                        DateTime.parse(task.startDate);
                                    DateTime endDate =
                                        DateTime.parse(task.endDate);

                                    if (selectedDate.isAfter(startDate
                                            .subtract(Duration(days: 1))) &&
                                        selectedDate.isBefore(
                                            endDate.add(Duration(days: 1)))) {
                                      return SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 180,
                                        child: Stack(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                color: whiteColor,
                                                border: Border.all(
                                                  color: baseColor,
                                                  width: 0.7,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  10,
                                                ),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 20,
                                                vertical: 16,
                                              ),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                vertical: 8,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        task.title,
                                                        style: primaryTextStyle
                                                            .copyWith(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              Get.to(
                                                                  EditPriorityTask(
                                                                priority: task,
                                                              ));
                                                            },
                                                            child: SizedBox(
                                                              width: 30,
                                                              child: Icon(
                                                                Icons.edit,
                                                                size: 20,
                                                                color:
                                                                    primaryColor,
                                                              ),
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                _taskC
                                                                    .deletePriorityTask(
                                                                        task.id);
                                                              });
                                                            },
                                                            child: SizedBox(
                                                              width: 30,
                                                              child: Icon(
                                                                Icons.delete,
                                                                size: 20,
                                                                color:
                                                                    primaryColor,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 12,
                                                  ),
                                                  Text(
                                                    task.description,
                                                    style:
                                                        brownTextStyle.copyWith(
                                                      fontSize: 12,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 3,
                                                    softWrap: false,
                                                    textAlign:
                                                        TextAlign.justify,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 20,
                                              right: 20,
                                              child: Text(
                                                '${DateFormat('MMM d').format(DateTime.parse(
                                                  task.startDate,
                                                ))} - ${DateFormat('MMM d').format(DateTime.parse(
                                                  task.endDate,
                                                ))}',
                                                style: blueTextStyle.copyWith(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 60,
                                              margin: const EdgeInsets.only(
                                                top: 60,
                                              ),
                                              decoration: const BoxDecoration(
                                                border: Border(
                                                  left: BorderSide(
                                                    color: Colors.black,
                                                    width: 3,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 50,
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Task Empty",
                                          style: blackTextStyle.copyWith(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              if (_taskC.allDailyList.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 50,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Task Empty",
                                      style: blackTextStyle.copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 520,
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: _taskC.allDailyList.length,
                                  itemBuilder: (context, index) {
                                    final task = _taskC.allDailyList[index];
                                    return Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: whiteColor,
                                        border: Border.all(
                                          color: baseColor,
                                          width: 0.7,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          10,
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 16,
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                task.title,
                                                style: blackTextStyle.copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Get.to(EditDailyTask(
                                                        daily: task,
                                                      ));
                                                    },
                                                    child: SizedBox(
                                                      width: 30,
                                                      child: Icon(
                                                        Icons.edit,
                                                        size: 20,
                                                        color: primaryColor,
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        _taskC.deleteDailyTask(
                                                          task.id,
                                                        );
                                                      });
                                                    },
                                                    child: SizedBox(
                                                      width: 30,
                                                      child: Icon(
                                                        Icons.delete,
                                                        size: 20,
                                                        color: primaryColor,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  int daysInMonth(int year, int month) {
    // Calculate the number of days in a month
    final lastDay = DateTime(year, month + 1, 0);
    return lastDay.day;
  }

  bool isToday(DateTime date) {
    return today.year == date.year &&
        today.month == date.month &&
        today.day == date.day;
  }
}

class DateItem extends StatelessWidget {
  final DateTime date;
  final bool isToday;
  final bool isSelected;
  final VoidCallback onSelect;

  DateItem({
    Key? key,
    required this.date,
    required this.isToday,
    required this.isSelected,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          onSelect();
        }
      },
      child: isSelected
          ? Container(
              width: 56,
              height: 50,
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat.E().format(date).substring(0, 3),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    DateFormat.d().format(date),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
          : Container(
              width: 56,
              height: 50,
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: const Color(0xffF1EAFF),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat.E().format(date).substring(0, 3),
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    DateFormat.d().format(date),
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
