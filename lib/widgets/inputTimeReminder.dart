import 'package:flutter/material.dart';

class TimeInputDialog extends StatefulWidget {
  final TimeOfDay? initialTime;

  const TimeInputDialog({Key? key, this.initialTime}) : super(key: key);

  @override
  _TimeInputDialogState createState() => _TimeInputDialogState();
}

class _TimeInputDialogState extends State<TimeInputDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialTime?.format(context) ?? '',
    );
  }

  Future<TimeOfDay?> _selectTime(BuildContext context) async {
    return await showDialog<TimeOfDay>(
      context: context,
      builder: (BuildContext context) {
        return TimeInputDialog(
          initialTime: TimeOfDay.now(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Time'),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.datetime,
        decoration: InputDecoration(
          hintText: 'HH:mm',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final String? timeText = _controller.text;
            if (timeText != null && timeText.isNotEmpty) {
              final List<String> parts = timeText.split(':');
              if (parts.length == 2) {
                final int hour = int.tryParse(parts[0]) ?? 0;
                final int minute = int.tryParse(parts[1]) ?? 0;
                if (hour >= 0 && hour < 24 && minute >= 0 && minute < 60) {
                  final TimeOfDay selectedTime =
                      TimeOfDay(hour: hour, minute: minute);
                  Navigator.of(context).pop(selectedTime);
                }
              }
            }
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}
