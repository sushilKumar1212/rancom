import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:thecourierapp/App/Common/common_widgets.dart';
import 'package:thecourierapp/App/Constants/constant_heplers.dart';
import 'package:thecourierapp/App/Core/apis.dart';

class ChangePasswordController extends ChangeNotifier {
  final oldPasswordController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  verifyPassword() {
    if (passwordController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter password");
    } else if (isPasswordValid(passwordController.text) == false) {
      Fluttertoast.showToast(
        msg:
            "Password Must Contain at least 8 characters, 1 uppercase, 1 lowercase, 1 number and 1 special character",
      );
    } else if (confirmPasswordController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter confirm password");
    } else if (passwordController.text != confirmPasswordController.text) {
      Fluttertoast.showToast(msg: "Password and confirm password not matched");
    } else {
      changePassword();
    }
  }

  changePassword() async {
    showLoading();
    final response = await Apis.changePasswordApi(
      token: GetStorage().read('token'),
      oldpassword: oldPasswordController.text,
      newpassword: passwordController.text,
    );
    hideLoading();
    if (response.statusCode == 200 || response.statusCode == 201) {
      showMessage(jsonDecode(response.body)['message'].toString());
      clearAll();
    } else {
      showMessage(jsonDecode(response.body)['message'].toString());
    }
  }

  clearAll() {
    oldPasswordController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }
}
