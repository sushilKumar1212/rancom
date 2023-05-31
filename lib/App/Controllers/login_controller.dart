import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:thecourierapp/App/Constants/constant_heplers.dart';
import 'package:thecourierapp/App/Core/apis.dart';
import 'package:thecourierapp/App/Driver/JoinUsModule/join_us_module.dart';
import 'package:thecourierapp/App/Utils/app_page_routes.dart';
import 'package:thecourierapp/main.dart';

import 'user_controller.dart';

class LoginController extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  login() async {
    if (!emailController.text.isEmail) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: "Invalid Email ",
      );
      return;
    }
    if (passwordController.text.isEmpty) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: "Enter Valid Password",
      );
      return;
    }
    if (passwordController.text.length < 8) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: "Password Must be atleast 8 character long",
      );
      return;
    }
    showLoading();
    deviceToken ??= await FirebaseMessaging.instance.getToken();
    final response = await Apis.driverLoginApi(
      email: emailController.text,
      password: passwordController.text,
      devicetoken: deviceToken!,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        log(data.toString());
        final token = data['token'];
        final userController =
            Provider.of<UserController>(Get.context!, listen: false);
        await userController.setToken(token);
        userController.updateLocation();
        hideLoading();
        if (data['screen'] == 'verify_email') {
          Get.to(
            () => JoinUsModule(
              currentPage: 2,
              email: data['driver']['email'],
            ),
          );
        } else if (data['driver']['is_phone_number_updated'] == false) {
          Get.to(
            () => const JoinUsModule(
              currentPage: 3,
            ),
          );
        } else if (data['driver']['no_of_questions_answered'] == 0) {
          Get.to(
            () => const JoinUsModule(
              currentPage: 6,
            ),
          );
        } else if (data['driver']['no_of_questions_answered'] == 1) {
          Get.to(
            () => const JoinUsModule(
              currentPage: 7,
            ),
          );
        } else {
          Get.offAllNamed(AppRoute.home);
        }
      } else {
        hideLoading();
        Fluttertoast.showToast(
          msg: data['message'],
          backgroundColor: Colors.red,
        );
      }
    } else {
      hideLoading();
      Fluttertoast.showToast(
        msg: jsonDecode(response.body)['message'],
        backgroundColor: Colors.red,
      );
    }
  }
}
