import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:taskmanagementapp/themes/theme.dart';
import 'package:taskmanagementapp/widgets/dateList_widget.dart';

class CalendarTableWidget extends StatefulWidget {
  @override
  State<CalendarTableWidget> createState() => _CalendarTableWidgetState();
}

class _CalendarTableWidgetState extends State<CalendarTableWidget> {
  DateTime today = DateTime.now();

  final DateTime firstDayOfMonth =
      DateTime.now().subtract(Duration(days: DateTime.now().day - 1));

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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          TableCalendar(
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
            onDaySelected: _onDaySelected,
            selectedDayPredicate: (day) => isSameDay(day, today),
            calendarStyle: const CalendarStyle(
              selectedTextStyle: TextStyle(color: Colors.white),
              todayDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[200],
            child: Text(
                "Selected date : " + DateFormat('EEE, MMM d y').format(today)),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
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
          ),
          const SizedBox(
            height: 20,
          ),
          DateListWidget(),
        ],
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
                      fontWeight: FontWeight.bold,
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
