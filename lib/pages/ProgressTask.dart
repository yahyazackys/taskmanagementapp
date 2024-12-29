import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sp_util/sp_util.dart';
import 'package:taskmanagementapp/config/config.dart';
import 'package:taskmanagementapp/controllers/task_controller.dart';
import 'package:taskmanagementapp/pages/EditPriorityTask.dart';
import 'package:taskmanagementapp/themes/theme.dart';
import 'package:http/http.dart' as http;

class ProgressTask extends StatefulWidget {
  const ProgressTask({Key? key}) : super(key: key);

  @override
  State<ProgressTask> createState() => _ProgressTaskState();
}

class _ProgressTaskState extends State<ProgressTask> {
  final _taskC = Get.put(TaskController());

  Future<void> downloadAndOpenPDF(BuildContext context) async {
    var url = Uri.parse('${Config.urlApi}task/report');

    try {
      await SpUtil.getInstance();
      String token = SpUtil.getString("token_user") ?? "";

      if (token.isEmpty) {
        throw Exception('Empty Token!');
      }

      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        // Check if response contains PDF content
        if (response.headers['content-type'] == 'application/pdf') {
          final Directory appDir = await getApplicationDocumentsDirectory();
          final String pdfPath = '${appDir.path}/report.pdf';
          final File pdfFile = File(pdfPath);
          await pdfFile.writeAsBytes(response.bodyBytes);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PDFView(
                filePath: pdfPath,
              ),
            ),
          );
        } else {
          print('Response is not a PDF: ${response.headers['content-type']}');
        }
      } else {
        print('Failed to load PDF report: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
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
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 60,
                // decoration: BoxDecoration(
                //   color: blueColor,
                // ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: 0,
                      child: Container(
                        width: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.asset('assets/logo.png'),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: InkWell(
                        onTap: () {
                          _taskC.openPDF(context);
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
                                    Icons.download,
                                    color: whiteColor,
                                    size: 20,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    'Report',
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
                    ),
                  ],
                ),
              ),
            ),
            DefaultTabController(
              length: 3,
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
                          'On Going',
                          style: primaryTextStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Up Coming',
                          style: primaryTextStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Done',
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
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: _taskC.priorityList.length,
                                  itemBuilder: (context, index) {
                                    final task = _taskC.priorityList[index];
                                    return SizedBox(
                                      width: MediaQuery.of(context).size.width,
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
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 16,
                                            ),
                                            margin: const EdgeInsets.symmetric(
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
                                                                  .deleteOngoingPriorityTask(
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
                                                  textAlign: TextAlign.justify,
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
                                  },
                                ),
                              ),
                              if (_taskC.priorityList.isEmpty)
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
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: _taskC.upComingPriorityList.length,
                                  itemBuilder: (context, index) {
                                    final task =
                                        _taskC.upComingPriorityList[index];
                                    return SizedBox(
                                      width: MediaQuery.of(context).size.width,
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
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 16,
                                            ),
                                            margin: const EdgeInsets.symmetric(
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
                                                                  .deleteUpcomingPriorityTask(
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
                                                  textAlign: TextAlign.justify,
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
                                  },
                                ),
                              ),
                              if (_taskC.upComingPriorityList.isEmpty)
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
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: _taskC.donePriorityList.length,
                                  itemBuilder: (context, index) {
                                    final task = _taskC.donePriorityList[index];
                                    return SizedBox(
                                      width: MediaQuery.of(context).size.width,
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
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 16,
                                            ),
                                            margin: const EdgeInsets.symmetric(
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
                                                            setState(() {
                                                              _taskC
                                                                  .deleteDonePriorityTask(
                                                                task.id,
                                                              );
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
                                                  textAlign: TextAlign.justify,
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
                                  },
                                ),
                              ),
                              if (_taskC.donePriorityList.isEmpty)
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
}
