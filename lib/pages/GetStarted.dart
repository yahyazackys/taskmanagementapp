import 'package:flutter/material.dart';
import 'package:taskmanagementapp/pages/Login.dart';
import 'package:taskmanagementapp/themes/theme.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildIndicator(),
                  // InkWell(
                  //   onTap: (() {
                  //     Navigator.pushReplacement(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: ((context) => const Login()),
                  //       ),
                  //     );
                  //   }),
                  //   child: Text(
                  //     "skip",
                  //     style: primaryTextStyle.copyWith(
                  //       fontSize: 12,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  _buildPage(
                    image: "assets/getStarted1.png",
                    title: "Easy Time Management",
                    content:
                        "With management based on priority and daily tasks, it will give you convenience in managing and determining the tasks that must be done first",
                  ),
                  _buildPage(
                    image: "assets/getStarted2.png",
                    title: "Increase Work Effectiveness",
                    content:
                        "Time management and the determination of more important tasks will give your job statistics better and always improve",
                  ),
                  _buildPage(
                    image: "assets/getStarted3.png",
                    title: "Reminder Notification",
                    content:
                        "The advantage of this application is that it also provides reminders for you so you don't forget to keep doing your assignments well and according to the time you have set",
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 40,
                horizontal: 20,
              ),
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => const Login()),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      8,
                    ), // Ubah sesuai keinginan Anda
                  ),
                ),
                child: Text(
                  'Get Started',
                  style: whiteTextStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(
      {required String image, required String title, required String content}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          image,
          width: MediaQuery.of(context).size.width * 0.85,
          height: 300,
        ),
        const SizedBox(height: 30),
        Text(
          title,
          textAlign: TextAlign.center,
          style: blackTextStyle.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
          ),
          child: Text(
            content,
            textAlign: TextAlign.center,
            style: brownTextStyle.copyWith(
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < 3; i++)
          if (i == _currentPage)
            _buildIndicatorItem(isActive: true)
          else
            _buildIndicatorItem(isActive: false),
      ],
    );
  }

  Widget _buildIndicatorItem({required bool isActive}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? primaryColor : baseColor,
      ),
    );
  }
}
