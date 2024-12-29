import 'dart:convert';

import 'package:sp_util/sp_util.dart';
import 'package:taskmanagementapp/config/config.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:taskmanagementapp/models/user_model.dart';

class UserController extends GetxController {
  var isEditing = false.obs;
  RxBool isLoading = false.obs;

  TextEditingController nameUser = TextEditingController(
    text: SpUtil.getString("name_user").toString() == ""
        ? ''
        : SpUtil.getString("name_user").toString(),
  );
  TextEditingController emailUser = TextEditingController(
    text: SpUtil.getString("email_user").toString() == ""
        ? ''
        : SpUtil.getString("email_user").toString(),
  );
  TextEditingController professionUser = TextEditingController(
    text: SpUtil.getString("profession_user").toString() == ""
        ? ''
        : SpUtil.getString("profession_user").toString(),
  );
  TextEditingController nohpUser = TextEditingController(
    text: SpUtil.getString("nohp_user").toString() == ""
        ? ''
        : SpUtil.getString("nohp_user").toString(),
  );
  TextEditingController currentPasswordUser = TextEditingController();
  TextEditingController newPasswordUser = TextEditingController();
  TextEditingController confirmPasswordUser = TextEditingController();

  Future<UserModel> editUser() async {
    var userId = SpUtil.getInt("id_user") ?? 0;
    var url = Uri.parse('${Config.urlApi}user/edit/$userId');

    try {
      isLoading.value = true;
      await SpUtil.getInstance();
      String token = SpUtil.getString("token_user") ?? "";
      if (token.isNotEmpty) {
        // Token memiliki isi, lakukan sesuatu di sini
        final response = await http.post(url, headers: {
          'Authorization': 'Bearer $token',
        }, body: {
          'name': nameUser.text,
          'email': emailUser.text,
          'profession': professionUser.text,
          'no_hp': nohpUser.text,
        });
        print(response.body);

        var responseDecode = json.decode(response.body);

        Map<String, dynamic> dataError = responseDecode["data"];
        print(dataError);

        if (response.statusCode == 200) {
          SpUtil.putInt("id_userUpdated", responseDecode["data"]["id"] ?? 0);
          SpUtil.putString(
              "name_userUpdated", responseDecode["data"]["name"] ?? "");
          SpUtil.putString(
              "email_userUpdated", responseDecode["data"]["email"] ?? "");
          SpUtil.putString("profession_userUpdated",
              responseDecode["data"]["profession"] ?? "");
          SpUtil.putString(
              "nohp_userUpdated", responseDecode["data"]["no_hp"] ?? "");

          Get.snackbar(
            "Success",
            responseDecode["message"],
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          isLoading.value = false;

          return UserModel.fromJson(responseDecode);
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
          throw Exception('Failed to edit user: ${response.statusCode}');
        }
      } else {
        throw Exception('Empty Token!');
      }
    } catch (e) {
      print(e);
      throw Exception('Error fetching user data: $e');
    }
  }

  Future<UserModel> editPassword() async {
    var userId = SpUtil.getInt("id_user") ?? 0;
    var url = Uri.parse('${Config.urlApi}password/edit/$userId');

    try {
      isLoading.value = true;
      await SpUtil.getInstance();
      String token = SpUtil.getString("token_user") ?? "";
      if (token.isNotEmpty) {
        final response = await http.post(url, headers: {
          'Authorization': 'Bearer $token',
        }, body: {
          'password': newPasswordUser.text,
          'password_confirmation': confirmPasswordUser.text,
        });
        print(response.body);

        var responseDecode = json.decode(response.body);

        Map<String, dynamic> dataError = responseDecode["data"];
        print(dataError);

        if (response.statusCode == 200) {
          newPasswordUser.clear();
          confirmPasswordUser.clear();
          Get.snackbar(
            "Success",
            responseDecode["message"],
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          isLoading.value = false;
          return UserModel.fromJson(responseDecode);
        } else {
          isLoading.value = false;
          // Handle the case where the current password doesn't match
          if (response.statusCode == 403) {
            Get.snackbar(
              "Error",
              "Current password doesn't match",
              margin: const EdgeInsets.all(10),
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
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
          throw Exception('Failed to edit password: ${response.statusCode}');
        }
      } else {
        throw Exception('Empty Token!');
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        "Error : ",
        e.toString(),
        margin: EdgeInsets.all(10),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      throw Exception("Error");
    }
  }
}
