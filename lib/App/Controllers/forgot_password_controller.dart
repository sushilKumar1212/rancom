import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:thecourierapp/App/Constants/constant_heplers.dart';
import 'package:thecourierapp/App/Core/apis.dart';
import 'package:thecourierapp/App/Driver/ForgotPassword/forgot_otp_verification_page.dart';
import 'package:thecourierapp/App/Driver/ForgotPassword/reset_password_page.dart';
import 'package:thecourierapp/App/Utils/app_page_routes.dart';

class ForgotPasswordController extends ChangeNotifier {
  final emailContorller = TextEditingController();
  final otpController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String? token;

  sendOtp() async {
    if (emailContorller.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter email");
    } else if (!emailContorller.text.isEmail) {
      Fluttertoast.showToast(msg: "Please enter valid email");
    } else {
      showLoading();
      final response = await Apis.resendOtpApi(
        email: emailContorller.text,
        action: "forgot_password",
      );
      hideLoading();
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          Get.to(() => const ForgotOtpVerificationPage());
        } else {
          Fluttertoast.showToast(msg: data['message']);
        }
      }
    }
  }

  verifyOtp() async {
    if (otpController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter otp");
    } else {
      showLoading();
      final response = await Apis.verifyChnagePasswordApi(
        email: emailContorller.text,
        otp: otpController.text,
      );
      hideLoading();
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          token = data['token'];
          Get.off(
            () => const ResetPasswordPage(),
          );
        } else {
          Fluttertoast.showToast(msg: data['message']);
        }
      } else {
        log(response.body.toString());
      }
    }
  }

  Future<bool> resendOtp() async {
    showLoading();
    final response = await Apis.resendOtpApi(
      email: emailContorller.text,
      action: "change_password",
    );
    hideLoading();
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        Fluttertoast.showToast(msg: data['message']);
        return true;
      } else {
        Fluttertoast.showToast(msg: data['message']);
      }
    }
    return false;
  }

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
      resetPassword();
    }
  }

  resetPassword() async {
    showLoading();
    final response = await Apis.resetPasswordApi(
      password: passwordController.text,
      token: token!,
    );
    hideLoading();
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        Fluttertoast.showToast(msg: data['message']);
        confirmPasswordController.clear();
        passwordController.clear();
        otpController.clear();
        emailContorller.clear();
        token = null;
        Get.offAllNamed(AppRoute.loginSelection);
      } else {
        Fluttertoast.showToast(msg: data['message']);
      }
    } else {
      log(response.body.toString());
    }
  }
}
