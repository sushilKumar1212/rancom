import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:thecourierapp/App/Common/common_widgets.dart';
import 'package:thecourierapp/App/Constants/constant_heplers.dart';
import 'package:thecourierapp/App/Controllers/complete_profile_controller.dart';
import 'package:thecourierapp/App/Controllers/home_controller.dart';
import 'package:thecourierapp/App/Controllers/join_us_controller.dart';
import 'package:thecourierapp/App/Controllers/user_controller.dart';
import 'package:thecourierapp/App/Core/apis.dart';
import 'package:thecourierapp/App/Utils/app_page_routes.dart';

class ProfileController extends ChangeNotifier {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final ninController = TextEditingController();
  final dobController = TextEditingController();

  getPersonalDetails() async {
    showLoading();
    final data =
        Provider.of<CompleteProfileController>(Get.context!, listen: false)
            .personalInfoModel;
    hideLoading();
    if (data != null) {
      final userData = data.driver;
      nameController.text = "${userData.firstName} ${userData.lastName}";
      addressController.text = userData.address ?? "";
      phoneController.text = userData.phoneNumber ?? "";
      emailController.text = userData.email;
      ninController.text = userData.nationalInsuranceNumber ?? "";
      dobController.text = userData.dateOfBirth == null
          ? ""
          : DateFormat("dd/MM/yyyy").format(userData.dateOfBirth!);
    }
  }

  updateProfilePic({
    required File file,
  }) async {
    showLoading();
    final response = await Apis.updateProfilePic(
      token: GetStorage().read("token"),
      profilePic: file,
    );

    hideLoading();
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      log(data.toString());
      if (data['success']) {
        showMessage("Profile picture updated successfully");
        notifyListeners();
        Provider.of<CompleteProfileController>(Get.context!, listen: false)
            .getPersonalDetails();
      } else {
        showMessage(data['message']);
      }
    } else {
      showMessage("Something went wrong");
    }
  }

  logout() async {
    Get.back();
    showLoading();
    final response = await Apis.logoutApi(
      token: await GetStorage().read("token"),
      deviceToken: await FirebaseMessaging.instance.getToken() ?? "",
    );
    hideLoading();
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      log(data.toString());
      if (data['success']) {
        showMessage(data['message']);
      } else {
        showMessage(data['message']);
        return;
      }
    } else {
      log(response.body.toString());
      return;
    }
    GetStorage().erase();
    GetStorage().write("onboard", true);
    nameController.clear();
    addressController.clear();
    phoneController.clear();
    emailController.clear();
    ninController.clear();
    dobController.clear();

    final data =
        Provider.of<CompleteProfileController>(Get.context!, listen: false);
    data.clear();
    final data2 = Provider.of<JoinUsController>(Get.context!, listen: false);
    data2.clearControllers();
    final controller = Provider.of<HomeController>(Get.context!, listen: false);
    controller.switchDutyOnOff(status: false);
    final tokencontroller =
        Provider.of<UserController>(Get.context!, listen: false);
    tokencontroller.clearToken();
    notifyListeners();
    hideLoading();
    Get.offAllNamed(AppRoute.initial);
  }
}
