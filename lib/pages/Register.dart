// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskmanagementapp/themes/theme.dart';
import 'package:taskmanagementapp/controllers/auth_controller.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    final authC = Get.put(AuthController());

    return Scaffold(
      backgroundColor: lightColor,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: primaryColor,
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_sharp,
                      size: 20,
                      color: whiteColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "YATASK",
                style: yataskStyle.copyWith(
                  fontSize: 30,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                "Management App",
                style: sub2TextStyle.copyWith(
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              Text(
                "Login to your account",
                style: brownTextStyle.copyWith(
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                // height: 60,
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 1,
                    color: baseColor,
                  ),
                ),
                child: TextField(
                  style: blackTextStyle.copyWith(
                    fontSize: 12,
                  ),
                  controller: authC.name,
                  decoration: InputDecoration(
                    hintStyle: const TextStyle(fontSize: 13),
                    hintText: 'Full Name',
                    iconColor: const Color(0xff8D92A3),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 40,
                    ),
                    prefixIcon: Container(
                      margin: const EdgeInsets.only(
                        right: 12,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      child: Icon(
                        Icons.lock,
                        color: whiteColor,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                // height: 60,
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 1,
                    color: baseColor,
                  ),
                ),
                child: TextField(
                  style: blackTextStyle.copyWith(
                    fontSize: 12,
                  ),
                  controller: authC.email,
                  decoration: InputDecoration(
                    hintStyle: const TextStyle(fontSize: 13),
                    hintText: 'Email',
                    iconColor: const Color(0xff8D92A3),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 40,
                    ),
                    prefixIcon: Container(
                      margin: const EdgeInsets.only(
                        right: 12,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      child: Icon(
                        Icons.lock,
                        color: whiteColor,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                // height: 60,
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 1,
                    color: baseColor,
                  ),
                ),
                child: TextField(
                  style: blackTextStyle.copyWith(
                    fontSize: 12,
                  ),
                  controller: authC.profession,
                  decoration: InputDecoration(
                    hintStyle: const TextStyle(fontSize: 13),
                    hintText: 'Profession',
                    iconColor: const Color(0xff8D92A3),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 40,
                    ),
                    prefixIcon: Container(
                      margin: const EdgeInsets.only(
                        right: 12,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      child: Icon(
                        Icons.lock,
                        color: whiteColor,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                // height: 60,
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 1,
                    color: baseColor,
                  ),
                ),
                child: TextField(
                  style: blackTextStyle.copyWith(
                    fontSize: 12,
                  ),
                  controller: authC.noHp,
                  decoration: InputDecoration(
                    hintStyle: const TextStyle(fontSize: 13),
                    hintText: 'No Handphone',
                    iconColor: const Color(0xff8D92A3),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 40,
                    ),
                    prefixIcon: Container(
                      margin: const EdgeInsets.only(
                        right: 12,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      child: Icon(
                        Icons.lock,
                        color: whiteColor,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                // height: 60,
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 1,
                    color: baseColor,
                  ),
                ),
                child: TextField(
                  style: blackTextStyle.copyWith(
                    fontSize: 12,
                  ),
                  controller: authC.password,
                  obscureText: authC.isObescure.value,
                  decoration: InputDecoration(
                    hintStyle: const TextStyle(fontSize: 13),
                    hintText: 'Password',
                    iconColor: const Color(0xff8D92A3),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 40,
                    ),
                    prefixIcon: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      child: Icon(
                        Icons.lock,
                        color: whiteColor,
                      ),
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          authC.isObescure.value = !authC.isObescure.value;
                        });
                      },
                      child: Icon(
                        authC.isObescure.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: const Color(0xff8D92A3),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                // height: 60,
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 1,
                    color: baseColor,
                  ),
                ),
                child: TextField(
                  style: blackTextStyle.copyWith(
                    fontSize: 12,
                  ),
                  controller: authC.confirmPassword,
                  obscureText: authC.isObescure2.value,
                  decoration: InputDecoration(
                    hintStyle: const TextStyle(fontSize: 13),
                    hintText: 'Confirm Password',
                    iconColor: const Color(0xff8D92A3),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 40,
                    ),
                    prefixIcon: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      child: Icon(
                        Icons.lock,
                        color: whiteColor,
                      ),
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        authC.isObescure2.value = !authC.isObescure2.value;
                      },
                      child: Icon(
                        authC.isObescure2.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: const Color(0xff8D92A3),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Obx(
                () => InkWell(
                  onTap: (() {
                    authC.register();
                  }),
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: authC.isLoading == true
                          ? CircularProgressIndicator(
                              color: whiteColor,
                            )
                          : Text(
                              'Sign Up',
                              style: whiteTextStyle.copyWith(
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
