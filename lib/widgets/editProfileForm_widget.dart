import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskmanagementapp/controllers/user_controller.dart';
import 'package:taskmanagementapp/themes/theme.dart';

class EditProfileFormWidget extends StatefulWidget {
  const EditProfileFormWidget({super.key});

  @override
  State<EditProfileFormWidget> createState() => _EditProfileFormWidgetState();
}

class _EditProfileFormWidgetState extends State<EditProfileFormWidget> {
  @override
  Widget build(BuildContext context) {
    final userC = Get.put(UserController());

    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Name",
              style: primaryTextStyle.copyWith(
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 1,
                  color: baseColor,
                ),
              ),
              child: TextFormField(
                controller: userC.nameUser,
                style: blackTextStyle.copyWith(
                  fontSize: 12,
                ),
                decoration: const InputDecoration(
                  hintStyle: TextStyle(fontSize: 13),
                  iconColor: Color(0xff8D92A3),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(15),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 28,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Email",
              style: primaryTextStyle.copyWith(
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 1,
                  color: baseColor,
                ),
              ),
              child: TextFormField(
                controller: userC.emailUser,
                style: blackTextStyle.copyWith(
                  fontSize: 12,
                ),
                decoration: const InputDecoration(
                  hintStyle: TextStyle(fontSize: 13),
                  iconColor: Color(0xff8D92A3),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(15),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 28,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Profession",
              style: primaryTextStyle.copyWith(
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 1,
                  color: baseColor,
                ),
              ),
              child: TextFormField(
                controller: userC.professionUser,
                style: blackTextStyle.copyWith(
                  fontSize: 12,
                ),
                decoration: const InputDecoration(
                  hintStyle: TextStyle(fontSize: 13),
                  iconColor: Color(0xff8D92A3),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(15),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 28,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "No. Handphone",
              style: primaryTextStyle.copyWith(
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 1,
                  color: baseColor,
                ),
              ),
              child: TextFormField(
                controller: userC.nohpUser,
                style: blackTextStyle.copyWith(
                  fontSize: 12,
                ),
                decoration: const InputDecoration(
                  hintStyle: TextStyle(fontSize: 13),
                  iconColor: Color(0xff8D92A3),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(15),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 28,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Image",
              style: primaryTextStyle.copyWith(
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(
                vertical: 4,
              ),
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
                decoration: const InputDecoration(
                  hintStyle: TextStyle(fontSize: 13),

                  // hintText: 'Nama Lengkap',
                  iconColor: Color(0xff8D92A3),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(15),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 24,
        ),
        InkWell(
          onTap: () {
            userC.editUser();
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
                      'Save',
                      style:
                          whiteTextStyle.copyWith(fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
