import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:thecourierapp/App/Constants/colors.dart';
import 'package:thecourierapp/App/Constants/constant_heplers.dart';
import 'package:thecourierapp/App/Controllers/join_us_controller.dart';

import '../../Common/common_widgets.dart';

class EmailPassWordPage extends StatefulWidget {
  const EmailPassWordPage({Key? key}) : super(key: key);

  @override
  State<EmailPassWordPage> createState() => _EmailPassWordPageState();
}

class _EmailPassWordPageState extends State<EmailPassWordPage> {
  late JoinUsController controller;

  @override
  void initState() {
    super.initState();
    controller = Provider.of<JoinUsController>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: getVerticalSize(20),
              ),
              Text(
                "And Your Email *".toUpperCase(),
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: getFontSize(33),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: getVerticalSize(5),
              ),
              Text(
                "Please provide your email address so we can stay in touch regarding your application and notify you of any updates or opportunities.",
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: getFontSize(18),
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(
                height: getVerticalSize(20),
              ),
              CommonWidgets.textbox(
                controller: controller.emailController,
                focusNode: controller.emailFocusNode,
                hintText: "EMAIL",
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Fontisto.email,
                formatter: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-z0-9@.]')),
                ],
              ),
              SizedBox(
                height: getVerticalSize(10),
              ),
              CommonWidgets.textbox(
                controller: controller.passwordController,
                focusNode: controller.passwordFocusNode,
                hintText: "PASSWORD",
                keyboardType: TextInputType.visiblePassword,
                prefixIcon: MaterialCommunityIcons.lock_outline,
                obscureText: true,
              ),
              SizedBox(
                height: getVerticalSize(10),
              ),
              CommonWidgets.textbox(
                controller: controller.confirmPasswordController,
                focusNode: controller.confirmPasswordFocusNode,
                hintText: "CONFIRM PASSWORD",
                keyboardType: TextInputType.visiblePassword,
                prefixIcon: MaterialCommunityIcons.lock_outline,
                obscureText: true,
              ),
              SizedBox(
                height: getVerticalSize(10),
              ),
              myText(
                "Note:\nPassword must be at least 8 characters long and contain one uppercase letter, one lowercase letter, one number and one special character.",
                color: AppColors.black,
                fontSize: getFontSize(12),
                fontWeight: FontWeight.normal,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
