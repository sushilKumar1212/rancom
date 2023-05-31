import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:thecourierapp/App/Common/common_widgets.dart';
import 'package:thecourierapp/App/Constants/colors.dart';
import 'package:thecourierapp/App/Constants/constant_heplers.dart';
import 'package:thecourierapp/App/Controllers/Customer/customer_profile_controller.dart';
import 'package:thecourierapp/App/Controllers/user_controller.dart';
import 'package:thecourierapp/App/Utils/app_page_routes.dart';

import '../../../main.dart';
import '../../Core/apis.dart';

class CustomerLoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailNode = FocusNode();
  final passwordNode = FocusNode();

  loginUser() async {
    if (emailController.text.isEmpty || !emailController.text.isEmail) {
      emailNode.requestFocus();
      showMessage('Please enter email', color: AppColors.red);
    } else if (passwordController.text.isEmpty) {
      showMessage('Please enter password', color: AppColors.red);
      passwordNode.requestFocus();
    } else if (passwordController.text.length < 8) {
      showMessage('Password must be 8 characters long', color: AppColors.red);
      passwordNode.requestFocus();
    } else {
      showLoading();
      deviceToken ??= await FirebaseMessaging.instance.getToken();
      final response = await Apis.customerLoginApi(
        email: emailController.text,
        password: passwordController.text,
        devicetoken: deviceToken!,
      );
      hideLoading();
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['success']) {

          await GetStorage().write('token', data['token']);
          await GetStorage().write('user', true);
          final customerController = Get.put(CustomerProfileController());
          customerController.token = data['token'];
          Provider.of<UserController>(Get.context!, listen: false)
              .updateLocation(isCustomer: true);
          Get.offAllNamed(AppRoute.customerhome);
        } else {
          showMessage(data['message'].toString(), color: AppColors.red);
        }
      } else {
        showMessage(jsonDecode(response.body)['message'].toString(),
            color: AppColors.red);
      }
    }
  }
}
