// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:sp_util/sp_util.dart';
import 'package:taskmanagementapp/config/config.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:taskmanagementapp/home.dart';
import 'package:taskmanagementapp/models/daily_model.dart';
import 'package:taskmanagementapp/models/task_model.dart';
import 'package:taskmanagementapp/pages/LandingPage.dart';
import 'package:taskmanagementapp/pages/ReportPdf.dart';
import 'package:taskmanagementapp/themes/theme.dart';
import 'package:path_provider/path_provider.dart';

class TaskController extends GetxController {
  var isEditing = false.obs;
  RxBool isLoading = false.obs;
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController reminder = TextEditingController();
  TextEditingController repeat = TextEditingController();
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();
  List<String> toDoList = [];
  List<bool> toDoListStatus = [];
  RxList<DailyTaskModel> allDailyList = RxList<DailyTaskModel>();
  RxList<TaskModel> allPriorityList = RxList<TaskModel>();
  RxList<TaskModel> priorityList = RxList<TaskModel>();
  RxList<TaskModel> donePriorityList = RxList<TaskModel>();
  RxList<TaskModel> upComingPriorityList = RxList<TaskModel>();
  TaskModel? priorityTaskById;
  DailyTaskModel? dailyTaskById;

  void clearAddTask() {
    title.clear();
    description.clear();
    reminder.clear();
    startDate.clear();
    endDate.clear();
    repeat.clear();
    toDoList.clear();
    toDoListStatus.clear();
  }

  void addToDo(String item, bool status) {
    toDoList.add(item);
    toDoListStatus.add(status ? true : false);
    update();
  }

  Future<void> openPDF(BuildContext context) async {
    var url = Uri.parse('${Config.urlApi}task/report');
    WidgetsFlutterBinding.ensureInitialized();

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
        if (response.headers['content-type'] == 'application/pdf') {
          final Directory appDir = await getApplicationDocumentsDirectory();
          final String pdfPath = '${appDir.path}/report.pdf';
          final File pdfFile = File(pdfPath);
          await pdfFile.writeAsBytes(response.bodyBytes);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PDFViewerScreen(
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

  Future<void> downloadPDF(BuildContext context) async {
    var url = Uri.parse('${Config.urlApi}task/report');
    WidgetsFlutterBinding.ensureInitialized();
    // FlutterDownloader.initialize(debug: true, ignoreSsl: true);

    try {
      await SpUtil.getInstance();
      String token = SpUtil.getString("token_user") ?? "";
      String email = SpUtil.getString("email_user") ?? "";

      if (token.isEmpty) {
        throw Exception('Empty Token!');
      }

      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        if (response.headers['content-type'] == 'application/pdf') {
          final time = DateTime.now().millisecondsSinceEpoch;
          final Directory appDir = await getApplicationDocumentsDirectory();
          final String pdfPath = '${appDir.path}/report-$email-$time.pdf';
          final File pdfFile = File(pdfPath);
          pdfFile.writeAsBytes(response.bodyBytes);
          Get.snackbar(
            "Success",
            'PDF Downloaded Successfully',
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color(0xffF1EAFF),
            colorText: primaryColor,
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

  Future<void> deleteDailyTask(int taskId) async {
    var url = Uri.parse('${Config.urlApi}priority-task/delete/$taskId');

    try {
      isLoading.value = true;
      await SpUtil.getInstance();
      String token = SpUtil.getString("token_user") ?? "";
      if (token.isNotEmpty) {
        final response = await http.post(url, headers: {
          'Authorization': 'Bearer $token',
        });
        var responseDecode = json.decode(response.body);

        if (response.statusCode == 200) {
          Get.snackbar(
            "Success",
            responseDecode["message"],
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color(0xffF1EAFF),
            colorText: primaryColor,
          );

          // Hapus tugas dari daftar
          allDailyList.removeWhere((task) => task.id == taskId);

          isLoading.value = false;
          Get.offAll(Home(
            initialScreen: LandingPage(),
            onTabChanged: 0,
          ));
        } else {
          isLoading.value = false;
          Get.snackbar(
            "Error",
            responseDecode["message"],
            margin: const EdgeInsets.all(10),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        throw Exception('Empty Token!');
      }
    } catch (e) {
      isLoading.value = false;
      print("Error: $e");
    }
  }

  Future<void> deletePriorityTask(int taskId) async {
    var url = Uri.parse('${Config.urlApi}priority-task/delete/$taskId');

    try {
      isLoading.value = true;
      await SpUtil.getInstance();
      String token = SpUtil.getString("token_user") ?? "";
      if (token.isNotEmpty) {
        final response = await http.post(url, headers: {
          'Authorization': 'Bearer $token',
        });
        var responseDecode = json.decode(response.body);

        if (response.statusCode == 200) {
          Get.snackbar(
            "Success",
            responseDecode["message"],
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color(0xffF1EAFF),
            colorText: primaryColor,
          );

          // Hapus tugas dari daftar
          allPriorityList.removeWhere((task) => task.id == taskId);
          priorityList.removeWhere((task) => task.id == taskId);
          upComingPriorityList.removeWhere((task) => task.id == taskId);
          donePriorityList.removeWhere((task) => task.id == taskId);

          isLoading.value = false;
          Get.offAll(Home(
            initialScreen: LandingPage(),
            onTabChanged: 0,
          ));
        } else {
          isLoading.value = false;
          Get.snackbar(
            "Error",
            responseDecode["message"],
            margin: const EdgeInsets.all(10),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        throw Exception('Empty Token!');
      }
    } catch (e) {
      isLoading.value = false;
      print("Error: $e");
    }
  }

  Future<void> deleteDonePriorityTask(int taskId) async {
    var url = Uri.parse('${Config.urlApi}priority-task/delete/$taskId');

    try {
      isLoading.value = true;
      await SpUtil.getInstance();
      String token = SpUtil.getString("token_user") ?? "";
      if (token.isNotEmpty) {
        final response = await http.post(url, headers: {
          'Authorization': 'Bearer $token',
        });
        var responseDecode = json.decode(response.body);

        if (response.statusCode == 200) {
          Get.snackbar(
            "Success",
            responseDecode["message"],
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color(0xffF1EAFF),
            colorText: primaryColor,
          );

          // Hapus tugas dari daftar
          allPriorityList.removeWhere((task) => task.id == taskId);
          donePriorityList.removeWhere((task) => task.id == taskId);

          isLoading.value = false;
          Get.offAll(Home(
            initialScreen: LandingPage(),
            onTabChanged: 0,
          ));
        } else {
          isLoading.value = false;
          Get.snackbar(
            "Error",
            responseDecode["message"],
            margin: const EdgeInsets.all(10),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        throw Exception('Empty Token!');
      }
    } catch (e) {
      isLoading.value = false;
      print("Error: $e");
    }
  }

  Future<void> deleteUpcomingPriorityTask(int taskId) async {
    var url = Uri.parse('${Config.urlApi}priority-task/delete/$taskId');

    try {
      isLoading.value = true;
      await SpUtil.getInstance();
      String token = SpUtil.getString("token_user") ?? "";
      if (token.isNotEmpty) {
        final response = await http.post(url, headers: {
          'Authorization': 'Bearer $token',
        });
        var responseDecode = json.decode(response.body);

        if (response.statusCode == 200) {
          Get.snackbar(
            "Success",
            responseDecode["message"],
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color(0xffF1EAFF),
            colorText: primaryColor,
          );

          // Hapus tugas dari daftar
          allPriorityList.removeWhere((task) => task.id == taskId);
          upComingPriorityList.removeWhere((task) => task.id == taskId);

          isLoading.value = false;
          Get.offAll(Home(
            initialScreen: LandingPage(),
            onTabChanged: 0,
          ));
        } else {
          isLoading.value = false;
          Get.snackbar(
            "Error",
            responseDecode["message"],
            margin: const EdgeInsets.all(10),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        throw Exception('Empty Token!');
      }
    } catch (e) {
      isLoading.value = false;
      print("Error: $e");
    }
  }

  Future<void> deleteOngoingPriorityTask(int taskId) async {
    var url = Uri.parse('${Config.urlApi}priority-task/delete/$taskId');

    try {
      isLoading.value = true;
      await SpUtil.getInstance();
      String token = SpUtil.getString("token_user") ?? "";
      if (token.isNotEmpty) {
        final response = await http.post(url, headers: {
          'Authorization': 'Bearer $token',
        });
        var responseDecode = json.decode(response.body);

        if (response.statusCode == 200) {
          Get.snackbar(
            "Success",
            responseDecode["message"],
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color(0xffF1EAFF),
            colorText: primaryColor,
          );

          // Hapus tugas dari daftar
          allPriorityList.removeWhere((task) => task.id == taskId);
          priorityList.removeWhere((task) => task.id == taskId);

          isLoading.value = false;
          Get.offAll(Home(
            initialScreen: LandingPage(),
            onTabChanged: 0,
          ));
        } else {
          isLoading.value = false;
          Get.snackbar(
            "Error",
            responseDecode["message"],
            margin: const EdgeInsets.all(10),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        throw Exception('Empty Token!');
      }
    } catch (e) {
      isLoading.value = false;
      print("Error: $e");
    }
  }

  Future<TaskModel?> addPriorityTask() async {
    var url = Uri.parse('${Config.urlApi}priority-task/add');

    try {
      isLoading.value = true;
      await SpUtil.getInstance();
      String token = SpUtil.getString("token_user") ?? "";
      if (token.isNotEmpty) {
        final response = await http.post(url, headers: {
          'Authorization': 'Bearer $token',
        }, body: {
          'title': title.text,
          'description': description.text,
          'start_date': startDate.text,
          'end_date': endDate.text,
          'reminder': reminder.text,
          'repeat': repeat.text,
          'to_do_list': jsonEncode(toDoList),
          'to_do_list_status': jsonEncode(toDoListStatus),
        });

        var responseDecode = json.decode(response.body);

        Map<String, dynamic> dataError = responseDecode["data"];

        if (response.statusCode == 200) {
          Get.snackbar(
            "Success",
            responseDecode["message"],
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color(0xffF1EAFF),
            colorText: primaryColor,
          );
          isLoading.value = false;
          Get.offAll(Home(
            initialScreen: LandingPage(),
            onTabChanged: 0,
          ));

          clearAddTask();
          return TaskModel.fromJson(responseDecode);
        } else {
          isLoading.value = false;

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
          return null;
        }
      } else {
        throw Exception('Empty Token!');
      }
    } catch (e) {
      isLoading.value = false;
      // Get.snackbar(
      //   "Error",
      //   e.toString(),
      //   margin: const EdgeInsets.all(10),
      //   snackPosition: SnackPosition.TOP,
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      // );
    }
    return null;
  }

  Future<TaskModel?> addDailyTask() async {
    var url = Uri.parse('${Config.urlApi}daily-task/add');

    try {
      isLoading.value = true;
      await SpUtil.getInstance();
      String token = SpUtil.getString("token_user") ?? "";
      if (token.isNotEmpty) {
        final response = await http.post(url, headers: {
          'Authorization': 'Bearer $token',
        }, body: {
          'title': title.text,
          'description': description.text,
          'reminder': reminder.text,
          'repeat': 'Every Day',
        });

        var responseDecode = json.decode(response.body);

        Map<String, dynamic> dataError = responseDecode["data"];

        if (response.statusCode == 200) {
          clearAddTask();

          Get.snackbar(
            "Success",
            responseDecode["message"],
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color(0xffF1EAFF),
            colorText: primaryColor,
          );
          isLoading.value = false;
          Get.offAll(Home(
            initialScreen: LandingPage(),
            onTabChanged: 0,
          ));

          return TaskModel.fromJson(responseDecode);
        } else {
          isLoading.value = false;

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
        }
      } else {
        throw Exception('Empty Token!');
      }
    } catch (e) {
      isLoading.value = false;
      // Get.snackbar(
      //   "Error : ",
      //   e.toString(),
      //   margin: const EdgeInsets.all(10),
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      // );
    }
    return null;
  }

  Future<TaskModel?> endPriorityTask(int taskId) async {
    try {
      await SpUtil.getInstance();
      String token = SpUtil.getString("token_user") ?? "";
      if (token.isNotEmpty) {
        var response = await http.post(
          Uri.parse('${Config.urlApi}task/end/$taskId'),
          headers: {'Authorization': 'Bearer $token'},
        );
        var responseDecode = json.decode(response.body);

        // Cek apakah respons memiliki data yang valid
        if (responseDecode != null && responseDecode is Map<String, dynamic>) {
          if (response.statusCode == 200) {
            Get.snackbar(
              "Success",
              responseDecode["message"],
              snackPosition: SnackPosition.TOP,
              backgroundColor: const Color(0xffF1EAFF),
              colorText: primaryColor,
            );
            Get.offAll(Home(
              initialScreen: LandingPage(),
              onTabChanged: 0,
            ));
            if (responseDecode.containsKey('data')) {
              priorityList.removeWhere((task) => task.id == taskId);
              return TaskModel.fromJson(responseDecode['data']);
            } else {
              print('Invalid response data');
            }
          } else {
            print('Failed to update ToDoList status');
          }
        } else {
          print('Invalid response format');
        }
      } else {
        throw Exception('Empty Token!');
      }
    } catch (e) {
      print("error status : ${e.toString()}");
    }
    return null;
  }

  Future<TaskModel?> updateToDoListStatus(
      int taskId, List<bool> toDoListStatusUpdated) async {
    try {
      await SpUtil.getInstance();
      String token = SpUtil.getString("token_user") ?? "";
      if (token.isNotEmpty) {
        var response = await http.post(
          Uri.parse('${Config.urlApi}task/update-status/$taskId'),
          headers: {'Authorization': 'Bearer $token'},
          body: {
            'to_do_list_status': json.encode(toDoListStatusUpdated),
          },
        );
        var responseDecode = json.decode(response.body);

        // Cek apakah respons memiliki data yang valid
        if (responseDecode != null && responseDecode is Map<String, dynamic>) {
          if (response.statusCode == 200) {
            print('ToDoList status updated successfully!');
            Get.snackbar(
              "Success",
              responseDecode["message"],
              snackPosition: SnackPosition.TOP,
              backgroundColor: const Color(0xffF1EAFF),
              colorText: primaryColor,
            );
            // Pastikan respons memiliki data task yang valid
            if (responseDecode.containsKey('data')) {
              return TaskModel.fromJson(responseDecode['data']);
            } else {
              print('Invalid response data');
            }
          } else {
            print('Failed to update ToDoList status');
          }
        } else {
          print('Invalid response format');
        }
      } else {
        throw Exception('Empty Token!');
      }
    } catch (e) {}
    return null;
  }

  Future<DailyTaskModel?> updateDailyTaskStatusToFalse() async {
    try {
      await SpUtil.getInstance();
      String token = SpUtil.getString("token_user") ?? "";
      if (token.isNotEmpty) {
        var response = await http.post(
          Uri.parse('${Config.urlApi}daily-task/update-status'),
          headers: {'Authorization': 'Bearer $token'},
        );
        var responseDecode = json.decode(response.body);

        // Cek apakah respons memiliki data yang valid
        if (responseDecode != null && responseDecode is Map<String, dynamic>) {
          if (response.statusCode == 200) {
            print('ToDoList status updated successfully!');
            Get.snackbar(
              "Success",
              responseDecode["message"],
              snackPosition: SnackPosition.TOP,
              backgroundColor: const Color(0xffF1EAFF),
              colorText: primaryColor,
            );
            // Pastikan respons memiliki data task yang valid
            if (responseDecode.containsKey('data')) {
              return DailyTaskModel.fromJson(responseDecode['data']);
            } else {
              print('Invalid response data');
            }
          } else {
            print('Failed to update ToDoList status');
          }
        } else {
          print('Invalid response format');
        }
      } else {
        throw Exception('Empty Token!');
      }
    } catch (e) {}
    return null;
  }

  Future<DailyTaskModel?> updateDailyTaskStatus(
      int taskId, String status) async {
    try {
      await SpUtil.getInstance();
      String token = SpUtil.getString("token_user") ?? "";
      if (token.isNotEmpty) {
        var response = await http.post(
          Uri.parse('${Config.urlApi}daily-task/update-status/$taskId'),
          headers: {'Authorization': 'Bearer $token'},
          body: {
            'status': status,
          },
        );
        var responseDecode = json.decode(response.body);

        // Cek apakah respons memiliki data yang valid
        if (responseDecode != null && responseDecode is Map<String, dynamic>) {
          if (response.statusCode == 200) {
            print('status updated successfully!');
            Get.snackbar(
              "Success",
              responseDecode["message"],
              snackPosition: SnackPosition.TOP,
              backgroundColor: const Color(0xffF1EAFF),
              colorText: primaryColor,
            );

            // Pastikan respons memiliki data task yang valid
            if (responseDecode.containsKey('data')) {
              return DailyTaskModel.fromJson(responseDecode['data']);
            } else {
              print('Invalid response data');
            }
          } else {
            print('Failed to update ToDoList status');
          }
        } else {
          print('Invalid response format');
        }
      } else {
        throw Exception('Empty Token!');
      }
    } catch (e) {}
    return null;
  }

  Future<List<TaskModel>> getTasks(String tipe) async {
    String endpoint = "";

    if (tipe == "priority") {
      endpoint = "priority-task";
    } else if (tipe == "done-priority") {
      endpoint = "priority-task/done";
    } else if (tipe == "upcoming-priority") {
      endpoint = "priority-task/up-coming";
    } else if (tipe == "all-priority") {
      endpoint = "priority-task/all";
    } else if (tipe == "all-daily") {
      endpoint = "daily-task/all";
    }

    List<TaskModel> listTasks = [];

    try {
      await SpUtil.getInstance();
      String token = SpUtil.getString("token_user") ?? "";
      var response =
          await http.get(Uri.parse(Config.urlApi + endpoint), headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        List listTaskResponse = responseBody['data'];
        print(listTaskResponse);

        listTaskResponse.forEach((json) {
          listTasks.add(TaskModel.fromJson(json));
        });
      } else {
        listTasks = [];
      }
    } catch (e) {
      print(e);
    }

    return listTasks;
  }

  Future<List<DailyTaskModel>> getDailyTasks(String tipe) async {
    String endpoint = "";

    if (tipe == "all-daily") {
      endpoint = "daily-task/all";
    }

    List<DailyTaskModel> listTasks = [];

    try {
      await SpUtil.getInstance();
      String token = SpUtil.getString("token_user") ?? "";
      var response =
          await http.get(Uri.parse(Config.urlApi + endpoint), headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        List listTaskResponse = responseBody['data'];
        print(listTaskResponse);

        listTaskResponse.forEach((json) {
          listTasks.add(DailyTaskModel.fromJson(json));
        });
      } else {
        listTasks = [];
      }
    } catch (e) {
      print(e);
    }

    return listTasks;
  }

  Future<void> fetchAllDaily() async {
    try {
      List<DailyTaskModel> tasks = await getDailyTasks("all-daily");
      if (tasks.isNotEmpty) {
        allDailyList.assignAll(tasks);
      }
    } catch (e) {
      print("errornya dalaah $e");
    }
    update();
  }

  Future<void> fetchAllPriority() async {
    try {
      List<TaskModel> tasks = await getTasks("all-priority");
      if (tasks.isNotEmpty) {
        allPriorityList.assignAll(tasks);
      }
    } catch (e) {
      print("error $e");
    }
    update();
  }

  Future<void> fetchPriority() async {
    try {
      List<TaskModel> tasks = await getTasks("priority");
      if (tasks.isNotEmpty) {
        priorityList.assignAll(tasks);
      }
    } catch (e) {
      print(e);
    }
    update();
  }

  Future<void> fetchDonePriority() async {
    try {
      List<TaskModel> tasks = await getTasks("done-priority");
      if (tasks.isNotEmpty) {
        donePriorityList.assignAll(tasks);
      }
    } catch (e) {
      print(e);
    }
    update();
  }

  Future<void> fetchUpComingPriority() async {
    try {
      List<TaskModel> tasks = await getTasks("upcoming-priority");
      if (tasks.isNotEmpty) {
        upComingPriorityList.assignAll(tasks);
      }
    } catch (e) {
      print(e);
    }
    update();
  }

  Future<TaskModel?> fetchPriorityTaskById(int taskId) async {
    try {
      await SpUtil.getInstance();
      String token = SpUtil.getString("token_user") ?? "";
      var response = await http.get(
          Uri.parse('${Config.urlApi}priority-task/detail/$taskId'),
          headers: {
            'Authorization': 'Bearer $token',
          });

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        priorityTaskById = TaskModel.fromJson(responseData['data']);
        update();
      } else {
        print('Failed to load task: ${response.statusCode}');
        priorityTaskById = null;
      }
    } catch (error) {
      print('Error fetching task: $error');
      priorityTaskById = null;
    }
    return null;
  }

  Future<DailyTaskModel?> fetchDailyTaskById(int taskId) async {
    try {
      await SpUtil.getInstance();
      String token = SpUtil.getString("token_user") ?? "";
      var response = await http.get(
          Uri.parse('${Config.urlApi}daily-task/detail/$taskId'),
          headers: {
            'Authorization': 'Bearer $token',
          });

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        dailyTaskById = DailyTaskModel.fromJson(responseData['data']);
        print(dailyTaskById);
        update();
      } else {
        print('Failed to load task: ${response.statusCode}');
        priorityTaskById = null;
      }
    } catch (error) {
      print('Error fetching task: $error');
      priorityTaskById = null;
    }
    return null;
  }
}
