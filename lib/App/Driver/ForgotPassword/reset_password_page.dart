import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thecourierapp/App/Common/common_widgets.dart';
import 'package:thecourierapp/App/Controllers/forgot_password_controller.dart';

import '../../Constants/colors.dart';
import '../../Constants/constant_heplers.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  bool issecured1 = true;
  bool issecured2 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: myText(
          "DRIVER LOGIN",
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: Consumer<ForgotPasswordController>(
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
                    const Icon(
                      Icons.lock_outline,
                    ),
                    SizedBox(
                      width: getHorizontalSize(10),
                    ),
                    Expanded(
                      child: TextField(
                        obscureText: issecured1,
                        controller: controller.passwordController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "New Password".toUpperCase(),
                          hintStyle: const TextStyle(
                            color: AppColors.darkGrey,
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
                    const Icon(
                      Icons.lock_outline,
                    ),
                    SizedBox(
                      width: getHorizontalSize(10),
                    ),
                    Expanded(
                      child: TextField(
                        obscureText: issecured2,
                        controller: controller.confirmPasswordController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Confirm Password".toUpperCase(),
                          hintStyle: const TextStyle(
                            color: AppColors.darkGrey,
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
                      "RESET PASSWORD",
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
