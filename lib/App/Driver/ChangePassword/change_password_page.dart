import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thecourierapp/App/Common/common_widgets.dart';
import 'package:thecourierapp/App/Controllers/chnage_password_controller.dart';

import '../../Constants/colors.dart';
import '../../Constants/constant_heplers.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  bool issecured1 = true;
  bool issecured2 = true;
  bool issecured3 = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Provider.of<ChangePasswordController>(context, listen: false)
            .clearAll();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: myText(
            "Change Password",
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          centerTitle: true,
          backgroundColor: AppColors.primary,
          elevation: 10,
          shadowColor: AppColors.white.withOpacity(0.2),
        ),
        backgroundColor: AppColors.grey,
        body: Consumer<ChangePasswordController>(
            builder: (context, controller, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                SizedBox(
                  height: getVerticalSize(20),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    border: Border.all(
                      color: AppColors.darkGrey.withOpacity(0.5),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lock_outline,
                        size: getSize(20),
                      ),
                      SizedBox(
                        width: getHorizontalSize(10),
                      ),
                      Expanded(
                        child: TextField(
                          obscureText: issecured1,
                          controller: controller.oldPasswordController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Old Password".toUpperCase(),
                            hintStyle: TextStyle(
                              color: AppColors.darkGrey,
                              fontSize: getFontSize(16),
                            ),
                          ),
                        ),
                      ),
                      tapper(
                        onPressed: () {
                          setState(() {
                            issecured1 = !issecured1;
                          });
                        },
                        child: Icon(
                          !issecured1 ? Icons.visibility : Icons.visibility_off,
                          color: AppColors.black,
                          size: getSize(20),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: getVerticalSize(20),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    border: Border.all(
                      color: AppColors.darkGrey.withOpacity(0.5),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lock_outline,
                        size: getSize(20),
                      ),
                      SizedBox(
                        width: getHorizontalSize(10),
                      ),
                      Expanded(
                        child: TextField(
                          obscureText: issecured2,
                          controller: controller.passwordController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "New Password".toUpperCase(),
                            hintStyle: TextStyle(
                              color: AppColors.darkGrey,
                              fontSize: getFontSize(16),
                            ),
                          ),
                        ),
                      ),
                      tapper(
                        onPressed: () {
                          setState(() {
                            issecured2 = !issecured2;
                          });
                        },
                        child: Icon(
                          !issecured2 ? Icons.visibility : Icons.visibility_off,
                          color: AppColors.black,
                          size: getSize(20),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: getVerticalSize(20),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    border: Border.all(
                      color: AppColors.darkGrey.withOpacity(0.5),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lock_outline,
                        size: getSize(20),
                      ),
                      SizedBox(
                        width: getHorizontalSize(10),
                      ),
                      Expanded(
                        child: TextField(
                          obscureText: issecured3,
                          controller: controller.confirmPasswordController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Confirm Password".toUpperCase(),
                            hintStyle: TextStyle(
                              color: AppColors.darkGrey,
                              fontSize: getFontSize(16),
                            ),
                          ),
                        ),
                      ),
                      tapper(
                        onPressed: () {
                          setState(() {
                            issecured3 = !issecured3;
                          });
                        },
                        child: Icon(
                          !issecured3 ? Icons.visibility : Icons.visibility_off,
                          color: AppColors.black,
                          size: getSize(20),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: getVerticalSize(20),
                ),
                tapper(
                  onPressed: () {
                    controller.verifyPassword();
                  },
                  child: Container(
                    height: getVerticalSize(50),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: myText(
                        "CHANGE PASSWORD",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
