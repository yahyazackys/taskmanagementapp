// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:taskmanagementapp/controllers/task_controller.dart';
import 'package:taskmanagementapp/themes/theme.dart';

class PDFViewerScreen extends StatelessWidget {
  final _taskC = Get.put(TaskController());
  final String filePath;

  PDFViewerScreen({required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          'PDF Viewer',
          style: whiteTextStyle,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () {
              _taskC.downloadPDF(context);
            },
          ),
        ],
      ),
      body: PDFView(
        filePath: filePath,
      ),
    );
  }
}
