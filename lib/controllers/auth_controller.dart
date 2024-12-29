import 'dart:convert';

import 'package:taskmanagementapp/config/config.dart';
import 'package:taskmanagementapp/home.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sp_util/sp_util.dart';
import 'package:taskmanagementapp/pages/LandingPage.dart';
import 'package:taskmanagementapp/pages/Login.dart';
import 'package:taskmanagementapp/themes/theme.dart';

class AuthController extends GetxController {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController profession = TextEditingController();
  TextEditingController noHp = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  TextEditingController emailLogin = TextEditingController();
  TextEditingController passwordLogin = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool isObescure = true.obs;
  RxBool isObescure2 = true.obs;
  RxString token = ''.obs;

  void clearInputan() {
    name.clear();
    email.clear();
    profession.clear();
    noHp.clear();
    password.clear();
    confirmPassword.clear();
    emailLogin.clear();
    passwordLogin.clear();
  }

  // register
  Future register() async {
    // url endpoint
    var url = Uri.parse("${Config.urlApi}register");

    try {
      isLoading.value = true;
      final response = await http.post(url, body: {
        'name': name.text,
        'email': email.text,
        'profession': profession.text,
        'no_hp': noHp.text,
        'password': password.text,
        'password_confirmation': confirmPassword.text,
      });

      print(response.body);

      var responseDecode = json.decode(response.body);

      Map<String, dynamic> dataError = responseDecode["data"];
      print(dataError);

      // cek statusCode dari response
      if (response.statusCode == 200) {
        clearInputan();

        // tampilkan snackbar pesan berhasil
        Get.snackbar(
          "Success",
          responseDecode["message"],
          snackPosition: SnackPosition.TOP,
          backgroundColor: baseColor,
          colorText: primaryColor,
        );

        Get.offAll(const Login());
      } else {
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
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        "Error",
        e.toString(),
        margin: const EdgeInsets.all(10),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // register
  Future login() async {
    // url endpoint
    var url = Uri.parse("${Config.urlApi}login");

    try {
      isLoading.value = true;

      final response = await http.post(url, body: {
        'email': emailLogin.text,
        'password': passwordLogin.text,
      });

      print(response.body);
      // biar isi dari response bisa diambil, kita decode terlebih dahulu
      var responseDecode = json.decode(response.body);

      // cek statusCode dari response
      if (response.statusCode == 200) {
        if (responseDecode != null && responseDecode["access_token"] != null) {
          // String token = responseDecode["access_token"];
          // await saveToken(token);

          await SpUtil.getInstance();

          SpUtil.putInt("id_user", responseDecode["data"]["id"] ?? 0);
          SpUtil.putString("name_user", responseDecode["data"]["name"] ?? "");
          SpUtil.putString("email_user", responseDecode["data"]["email"] ?? "");
          SpUtil.putString(
              "profession_user", responseDecode["data"]["profession"] ?? "");
          SpUtil.putString("nohp_user", responseDecode["data"]["no_hp"] ?? "");
          SpUtil.putString(
              "image_user", responseDecode["data"]["gambar"] ?? "");
          SpUtil.putString("token_user", responseDecode["access_token"] ?? "");
          SpUtil.putString(
              "password_user", responseDecode["data"]["password"] ?? "");
          clearInputan();
          isLoading.value = false;
          // redirect to the home page
          Get.offAll(Home(
            initialScreen: LandingPage(),
            onTabChanged: 0,
          ));
        } else {
          isLoading.value = false;
          // show error message if access_token is missing
          Get.snackbar(
            "Input Data Correctly!",
            "Access token missing",
            showProgressIndicator: true,
            margin: EdgeInsets.all(10),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        isLoading.value = false;
        // show error message
        Get.snackbar(
          "Input Data Correctly!",
          responseDecode != null
              ? responseDecode["message"] ?? "Data Invalid"
              : "Unknown error",
          showProgressIndicator: true,
          margin: EdgeInsets.all(10),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }

      // print(response.body);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        "Erroraa",
        e.toString(),
        margin: EdgeInsets.all(10),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // logout
  void logout() {
    try {
      clearInputan();
      // menghapus data/cache dsb yg tersimpan sementara di hp
      SpUtil.clear();

      // tampilkan snackbar pesan berhasil
      Get.snackbar(
        "Success",
        "Berhasil Log Out!",
        margin: EdgeInsets.all(10),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: baseColor,
        colorText: primaryColor,
      );

      // redirect ke home page
      Get.offAll(const Login());
    } catch (e) {
      Get.snackbar(
        "Failed",
        e.toString(),
        margin: EdgeInsets.all(10),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
