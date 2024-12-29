import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:taskmanagementapp/themes/theme.dart';

class DateListWidget extends StatefulWidget {
  @override
  State<DateListWidget> createState() => _DateListWidgetState();
}

class _DateListWidgetState extends State<DateListWidget> {
  final DateTime firstDayOfMonth =
      DateTime.now().subtract(Duration(days: DateTime.now().day - 1));

  final DateTime today = DateTime.now();

  late DateTime selectedDate;

  // final PageController pageController =
  @override
  void initState() {
    super.initState();
    selectedDate = today;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: daysInMonth(selectedDate.year, selectedDate.month),
        itemBuilder: (context, index) {
          DateTime date =
              DateTime(selectedDate.year, selectedDate.month, index + 1);

          return DateItem(
            date: date,
            isToday: isToday(date),
            isSelected: isSameDay(selectedDate, date),
            onSelect: () {
              setState(() {
                selectedDate = today;
              });
            },
          );
        },
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
    required this.date,
    required this.isToday,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: isSelected
          ? Container(
              width: 56,
              height: 50,
              margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat.E().format(date).substring(0, 3),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    DateFormat.d().format(date),
                    style: TextStyle(
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
              margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Color(0xffF1EAFF),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat.E().format(date).substring(0, 3),
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                  SizedBox(height: 4.0),
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
