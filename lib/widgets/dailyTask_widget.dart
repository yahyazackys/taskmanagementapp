import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskmanagementapp/controllers/task_controller.dart';
import 'package:taskmanagementapp/models/daily_model.dart';
import 'package:taskmanagementapp/themes/theme.dart';

class DailyTaskWidget extends StatefulWidget {
  const DailyTaskWidget({Key? key, required this.daily}) : super(key: key);

  final DailyTaskModel daily;

  @override
  State<DailyTaskWidget> createState() => _DailyTaskWidgetState();
}

class _DailyTaskWidgetState extends State<DailyTaskWidget>
    with SingleTickerProviderStateMixin {
  final _taskC = Get.put(TaskController());

  late AnimationController _animationController;
  late Animation<double> _animation;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = _animationController.drive(
      Tween<double>(begin: 0, end: 1).chain(
        CurveTween(curve: Curves.easeInOut),
      ),
    );
  }

  void toggleExpansion() {
    if (isExpanded) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final status = widget.daily.status;

    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: whiteColor,
        border: Border.all(color: baseColor, width: 0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: toggleExpansion,
                  child: Row(
                    children: [
                      isExpanded
                          ? Container(
                              width: 30,
                              alignment: Alignment.centerLeft,
                              child: Transform.rotate(
                                angle: isExpanded ? 3.1415 / 2 : 0,
                                child: Icon(
                                  Icons.arrow_forward_ios_sharp,
                                  size: 12,
                                  color: primaryColor,
                                ),
                              ),
                            )
                          : Container(
                              width: 30,
                              alignment: Alignment.centerLeft,
                              child: Icon(
                                Icons.arrow_forward_ios_sharp,
                                size: 12,
                                color: primaryColor,
                              ),
                            ),
                      Text(
                        widget.daily.title,
                        style: blackTextStyle.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  final newStatus = status == "on_going" ? "done" : "on_going";
                  _taskC.updateDailyTaskStatus(widget.daily.id, newStatus);

                  setState(() {
                    widget.daily.status = newStatus;
                  });
                },
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: primaryColor,
                      width: 2.0,
                    ),
                    color: status == "done" ? primaryColor : Colors.white,
                  ),
                  child: status == "done"
                      ? Center(
                          child: Container(
                            width: 20,
                            height: 20,
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
              ),
            ],
          ),
          if (isExpanded)
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _animation,
                  child: ClipRect(
                    child: Align(
                      heightFactor: _animation.value,
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          widget.daily.description,
                          textAlign: TextAlign.justify,
                          style: blackTextStyle.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          else
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _animation,
                  child: ClipRect(
                    child: Align(
                      heightFactor: _animation.value,
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          widget.daily.description,
                          textAlign: TextAlign.justify,
                          style: blackTextStyle.copyWith(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
