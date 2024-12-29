import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskmanagementapp/controllers/user_controller.dart';
import 'package:taskmanagementapp/themes/theme.dart';

class Security extends StatefulWidget {
  const Security({super.key});

  @override
  State<Security> createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
  @override
  Widget build(BuildContext context) {
    final userC = Get.put(UserController());
    return Scaffold(
      backgroundColor: lightColor,
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: primaryColor,
            ),
            child: SafeArea(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                // decoration: BoxDecoration(
                //   color: blueColor,
                // ),
                margin: const EdgeInsets.only(
                  bottom: 760,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: 0,
                      child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: whiteColor,
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back_sharp,
                              size: 20,
                              color: primaryColor,
                            ),
                          )),
                    ),
                    Text(
                      "Security",
                      style: whiteTextStyle.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.only(
              top: 60,
              bottom: 60,
              right: 20,
              left: 20,
            ),
            decoration: BoxDecoration(
              color: lightColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(60),
                topRight: Radius.circular(60),
              ),
            ),
            margin: const EdgeInsets.only(
              top: 160,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Password",
                  style: primaryTextStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
                  height: 12,
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
                    controller: userC.newPasswordUser,
                    style: blackTextStyle.copyWith(
                      fontSize: 12,
                    ),
                    decoration: InputDecoration(
                      hintStyle: const TextStyle(fontSize: 13),
                      hintText: 'New Password',
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
                    controller: userC.confirmPasswordUser,
                    style: blackTextStyle.copyWith(
                      fontSize: 12,
                    ),
                    decoration: InputDecoration(
                      hintStyle: const TextStyle(fontSize: 13),
                      hintText: 'Confirm New Password',
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
                  height: 24,
                ),
                InkWell(
                  onTap: () {
                    userC.editPassword();
                  },
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: userC.isLoading == true
                          ? CircularProgressIndicator(
                              color: whiteColor,
                            )
                          : Text(
                              'Submit',
                              style: whiteTextStyle.copyWith(
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
