import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thecourierapp/App/Common/common_widgets.dart';
import 'package:thecourierapp/App/Constants/colors.dart';
import 'package:thecourierapp/App/Constants/constant_heplers.dart';
import 'package:thecourierapp/App/Driver/JoinUsModule/join_us_module.dart';
import 'package:thecourierapp/App/Utils/app_page_routes.dart';

class LoginSelectionPage extends StatefulWidget {
  const LoginSelectionPage({Key? key}) : super(key: key);

  @override
  State<LoginSelectionPage> createState() => _LoginSelectionPageState();
}

class _LoginSelectionPageState extends State<LoginSelectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
      ),
      backgroundColor: AppColors.primary,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(),
            Hero(
              tag: "logo",
              child: Image.asset(
                'assets/images/logo.png',
                width: getSize(190 + 44),
                height: getSize(234 + 44),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: getVerticalSize(50),
            ),
            tapper(
              onPressed: () {
                Get.toNamed(AppRoute.login);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                width: Get.width,
                height: getVerticalSize(50),
                alignment: Alignment.center,
                child: Text(
                  'DRIVER LOGIN',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: getFontSize(16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: getVerticalSize(20),
            ),
            tapper(
              onPressed: () {
                Get.to(() => const JoinUsModule());
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.black,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                width: Get.width,
                height: getVerticalSize(50),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'JOIN US TODAY',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: getFontSize(16),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: getSize(10),
                    ),
                    const Icon(
                      Icons.arrow_forward,
                      color: AppColors.black,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: getVerticalSize(10),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                tapper(
                  onPressed: () {
                    Get.toNamed(AppPage.customerlogin);
                  },
                  child: Text(
                    "CUSTOMER LOGIN",
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: getFontSize(12),
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: getVerticalSize(20),
            ),
          ],
        ),
      ),
    );
  }
}
