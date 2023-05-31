import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:thecourierapp/App/Common/common_widgets.dart';
import 'package:thecourierapp/App/Constants/colors.dart';
import 'package:thecourierapp/App/Constants/constant_heplers.dart';
import 'package:thecourierapp/App/Controllers/Customer/customer_login_controller.dart';
import 'package:thecourierapp/App/Driver/ForgotPassword/forgot_password_page.dart';

class CustomeLogin extends StatefulWidget {
  const CustomeLogin({Key? key}) : super(key: key);

  @override
  State<CustomeLogin> createState() => _CustomeLoginState();
}

class _CustomeLoginState extends State<CustomeLogin> {
  bool isSecured = true;
  final controller = Get.put(CustomerLoginController());
  final emailkey = GlobalKey<AutofillGroupState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CUSTOMER LOGIN',
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
          key: emailkey,
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
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[a-z0-9@.]'),
                          ),
                        ],
                        controller: controller.emailController,
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
                  controller.loginUser();
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
                  Get.to(() => const ForgotPasswordPage());
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
