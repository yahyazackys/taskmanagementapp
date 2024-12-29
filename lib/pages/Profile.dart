import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sp_util/sp_util.dart';
import 'package:taskmanagementapp/controllers/auth_controller.dart';
import 'package:taskmanagementapp/pages/EditProfile.dart';
import 'package:taskmanagementapp/pages/Security.dart';
import 'package:taskmanagementapp/themes/theme.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final authC = Get.put(AuthController());

    return Scaffold(
      backgroundColor: lightColor,
      body: Column(
        children: [
          Container(
            height: 315,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 0, // Mengatur kontainer merah setengah di atas
                  left: 0,
                  right: 0,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(50),
                      ),
                    ),
                    height: 180,
                    child: Text(
                      "My Profile",
                      style: whiteTextStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0, // Mengatur kontainer biru setengah di bawah
                  // left: 0,
                  // right: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 160,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: baseColor,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Transform.translate(
                          offset: const Offset(0, -30),
                          child: ClipRRect(
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor: primaryColor,
                              child: Icon(
                                Icons.account_circle,
                                size: 80,
                                color: baseColor,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          SpUtil.getString("name_userUpdated").toString() == ""
                              ? SpUtil.getString("name_user").toString()
                              : SpUtil.getString("name_userUpdated").toString(),
                          style: primaryTextStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          SpUtil.getString("profession_userUpdated")
                                      .toString() ==
                                  ""
                              ? SpUtil.getString("profession_user").toString()
                              : SpUtil.getString("profession_userUpdated")
                                  .toString(),
                          style: brownTextStyle.copyWith(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfile(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 40,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.person_3_rounded,
                    size: 26,
                    color: primaryColor,
                  ),
                  const SizedBox(
                    width: 32,
                  ),
                  Text(
                    "Edit Profile",
                    style: blackTextStyle.copyWith(
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Security(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 40,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.security,
                    size: 26,
                    color: primaryColor,
                  ),
                  const SizedBox(
                    width: 32,
                  ),
                  Text(
                    "Security",
                    style: blackTextStyle.copyWith(
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              authC.logout();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 40,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.logout,
                    size: 26,
                    color: primaryColor,
                  ),
                  const SizedBox(
                    width: 32,
                  ),
                  Text(
                    "Logout",
                    style: blackTextStyle.copyWith(
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
