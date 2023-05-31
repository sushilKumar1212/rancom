
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thecourierapp/App/Common/common_widgets.dart';
import 'package:thecourierapp/App/Constants/constant_heplers.dart';
import 'package:thecourierapp/App/Controllers/forgot_password_controller.dart';

import '../../Constants/colors.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late ForgotPasswordController controller;

  @override
  void initState() {
    super.initState();
    controller = Provider.of<ForgotPasswordController>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reset Password'.toUpperCase(),
          style: TextStyle(
            fontSize: getFontSize(16),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            SizedBox(
              height: getVerticalSize(20),
            ),
            Text(
              "Please provide a valid email address where we can reach you regarding your password.",
              style: TextStyle(
                fontSize: getFontSize(18),
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
                    Icons.email,
                  ),
                  SizedBox(
                    width: getHorizontalSize(10),
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller.emailContorller,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "EMAIL",
                        hintStyle: TextStyle(
                          color: AppColors.darkGrey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: getVerticalSize(20),
            ),
            SizedBox(
              width: double.infinity,
              height: getVerticalSize(50),
              child: tapper(
                onPressed: () {
                  controller.sendOtp();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      "RESET PASSWORD",
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: getFontSize(16),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
