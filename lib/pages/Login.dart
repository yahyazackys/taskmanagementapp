import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskmanagementapp/controllers/auth_controller.dart';
import 'package:taskmanagementapp/pages/Register.dart';
import 'package:taskmanagementapp/themes/theme.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    final authC = Get.put(AuthController());

    return Scaffold(
      backgroundColor: lightColor,
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 160,
            ),
            Text(
              "YATASK",
              style: yataskStyle.copyWith(
                fontSize: 30,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "Management App",
              style: sub2TextStyle.copyWith(
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 80,
            ),
            Text(
              "Login to your account",
              style: brownTextStyle.copyWith(
                fontSize: 14,
              ),
            ),
            SizedBox(
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
                controller: authC.emailLogin,
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
            SizedBox(
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
                controller: authC.passwordLogin,
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
                    margin: EdgeInsets.only(right: 12),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.only(
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
                      color: Color(0xff8D92A3),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Forgot Password?",
                style: blueTextStyle.copyWith(
                  fontSize: 10,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Obx(
              () => InkWell(
                onTap: (() {
                  authC.login();
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
                            'Sign In',
                            style: whiteTextStyle.copyWith(
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: (() {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => const Register()),
                  ),
                );
              }),
              child: Text(
                "Don’t have an account? Sign Up ",
                style: brownTextStyle.copyWith(
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
