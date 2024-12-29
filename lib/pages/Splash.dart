import 'dart:async';

import 'package:flutter/material.dart';
import 'package:taskmanagementapp/pages/GetStarted.dart';
import 'package:taskmanagementapp/themes/theme.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(
        seconds: 5,
      ),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const GetStarted(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo.png',
                width: 112,
                color: lightColor,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Make Your Day Easier.',
                style: lightTextStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
