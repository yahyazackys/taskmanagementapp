import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cron/cron.dart';
import 'package:taskmanagementapp/controllers/task_controller.dart';
import 'package:taskmanagementapp/pages/Splash.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  final _taskC = Get.put(TaskController());
  final Cron _cron = Cron();

  WidgetsFlutterBinding.ensureInitialized();
  // const AndroidInitializationSettings initializationSettingsAndroid =
  //     AndroidInitializationSettings('');
  // const DarwinInitializationSettings initializationSettingsIOS =
  //     DarwinInitializationSettings();
  // const InitializationSettings initializationSettings = InitializationSettings(
  //     android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  // await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  _cron.schedule(Schedule.parse('0 0 * * *'), () async {
    await _taskC.updateDailyTaskStatusToFalse();
  });
  await clearNameUserUpdatedOnStartup();
  runApp(const MyApp());
}

Future<void> clearNameUserUpdatedOnStartup() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove("id_userUpdated");
  await prefs.remove("name_userUpdated");
  await prefs.remove("email_userUpdated");
  await prefs.remove("profession_userUpdated");
  await prefs.remove("nohp_userUpdated");

  await prefs.remove("id_user");
  await prefs.remove("name_user");
  await prefs.remove("email_user");
  await prefs.remove("profession_user");
  await prefs.remove("nohp_user");
  await prefs.remove("image_user");
  await prefs.remove("token_user");
  await prefs.remove("password_user");
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const Splash(),
      debugShowCheckedModeBanner: false,
    );
  }
}
