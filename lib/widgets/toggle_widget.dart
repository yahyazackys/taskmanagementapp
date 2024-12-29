import 'package:flutter/material.dart';
import 'package:taskmanagementapp/themes/theme.dart';

class ToggleWidget extends StatefulWidget {
  ToggleWidget({Key? key}) : super(key: key);

  @override
  State<ToggleWidget> createState() => _ToggleWidgetState();
}

class _ToggleWidgetState extends State<ToggleWidget> {
  bool isToggled = false;

  void toggleButton() {
    setState(() {
      isToggled = !isToggled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleButton,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: primaryColor,
            width: 2.0,
          ),
          color: isToggled ? primaryColor : Colors.white,
        ),
        child: isToggled
            ? Center(
                child: Container(
                  width: 20, // Adjust the width of the inner circle
                  height: 20, // Adjust the height of the inner circle
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: whiteColor,
                      width: 1,
                    ),
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
