import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:thecourierapp/App/Common/common_widgets.dart';
import 'package:thecourierapp/App/Constants/colors.dart';
import 'package:thecourierapp/App/Constants/constant_heplers.dart';
import 'package:thecourierapp/App/Controllers/login_controller.dart';
import 'package:thecourierapp/App/Utils/app_page_routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isSecured = true;
  late LoginController controller;

  @override
  void initState() {
    super.initState();
    controller = Provider.of<LoginController>(context, listen: false);
  }

  final autofillkey = GlobalKey<AutofillGroupState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'DRIVER LOGIN',
          style: TextStyle(
            fontSize: getFontSize(16),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: AutofillGroup(
          key: autofillkey,
          child: Column(
            children: [
              SizedBox(
                height: getVerticalSize(20),
                width: Get.width,
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
                      Icons.email_outlined,
                    ),
                    SizedBox(
                      width: getHorizontalSize(10),
                    ),
                    Expanded(
                      child: TextField(
                        controller: controller.emailController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-z0-9@.]')),
                        ],
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
                width: Get.width,
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
                      Icons.lock_outline_rounded,
                    ),
                    SizedBox(
                      width: getHorizontalSize(10),
                    ),
                    Expanded(
                      child: TextField(
                        controller: controller.passwordController,
                        obscureText: isSecured,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "PASSWORD",
                          hintStyle: TextStyle(
                            color: AppColors.darkGrey,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: getHorizontalSize(10),
                    ),
                    tapper(
                      child: Icon(
                        !isSecured
                            ? Ionicons.eye_outline
                            : Ionicons.eye_off_outline,
                        color: AppColors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          isSecured = !isSecured;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: getVerticalSize(20),
              ),
              tapper(
                onPressed: () {
                  controller.login();
                },
                child: Container(
                  width: Get.width,
                  height: getVerticalSize(50),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "LOGIN",
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: getFontSize(16),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              tapper(
                onPressed: () {
                  Get.toNamed(AppRoute.forgotpassword);
                },
                child: Text(
                  "Forgot your password?".toUpperCase(),
                  style: TextStyle(
                    fontSize: getFontSize(16),
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
