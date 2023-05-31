import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:thecourierapp/App/Common/common_widgets.dart';
import 'package:thecourierapp/App/Constants/constant_heplers.dart';
import 'package:thecourierapp/App/Controllers/user_controller.dart';
import 'package:thecourierapp/App/Core/apis.dart';
import 'package:thecourierapp/App/Utils/app_page_routes.dart';

class JoinUsController extends ChangeNotifier {
  //Page View Controller
  final PageController pageController = PageController(initialPage: 0);

  int currenPage = 0;
  int? initialPage;

  //Text Editing Controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  //Focus Nodes
  final FocusNode firstNameFocusNode = FocusNode();
  final FocusNode lastNameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();
  final FocusNode otpFocusNode = FocusNode();
  final FocusNode phoneNumberFocusNode = FocusNode();

  String selectedHustlerType = '';
  String selectedVehicleType = '';

  selectHustle(String type) {
    selectedHustlerType = type;
    notifyListeners();
  }

  selectVehicle(String type) {
    selectedVehicleType = type;
    notifyListeners();
  }

  //Clear Controllers
  void clearControllers() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    phoneNumberController.clear();
    otpController.clear();
  }

  //Jump to Initial

  jumpToPage(int page) {
    pageController.jumpToPage(page);
    currenPage = page;
    notifyListeners();
  }

  //First Page Validator
  void validate() {
    FocusManager.instance.primaryFocus!.unfocus();
    if (currenPage == 0) {
      if (firstNameController.text.isEmpty ||
          firstNameController.text.length < 3) {
        showMessage('First Name must be atleast 3 characters long');
        firstNameFocusNode.requestFocus();
      } else if (lastNameController.text.isEmpty) {
        lastNameFocusNode.requestFocus();
      } else {
        pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
        currenPage = 1;
        notifyListeners();
      }
    } else if (currenPage == 1) {
      if (emailController.text.isEmpty) {
        emailFocusNode.requestFocus();
      } else if (!emailController.text.isEmail) {
        emailFocusNode.requestFocus();
        Fluttertoast.cancel();
        Fluttertoast.showToast(
          msg: 'Invalid Email',
          backgroundColor: Colors.red,
        );
      } else if (passwordController.text.isEmpty) {
        passwordFocusNode.requestFocus();
      } else if (!isPasswordValid(passwordController.text.trim())) {
        return;
      } else if (confirmPasswordController.text.isEmpty) {
        confirmPasswordFocusNode.requestFocus();
      } else if (passwordController.text != confirmPasswordController.text) {
        confirmPasswordFocusNode.requestFocus();
        Fluttertoast.cancel();
        Fluttertoast.showToast(
          msg: 'Password does not match',
          backgroundColor: Colors.red,
        );
      } else {
        signUp();
      }
    } else if (currenPage == 2) {
      if (otpController.text.isEmpty) {
        otpFocusNode.requestFocus();
      } else {
        pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
        currenPage = 3;
        notifyListeners();
      }
    } else if (currenPage == 3) {
      if (phoneNumberController.text.isEmpty) {
        phoneNumberFocusNode.requestFocus();
      } else if (phoneNumberController.text.length < 10) {
        phoneNumberFocusNode.requestFocus();
        Fluttertoast.cancel();
        Fluttertoast.showToast(
          msg: 'Invalid Phone Number',
          backgroundColor: Colors.red,
        );
      } else {
        updatePhoneNumber();
      }
    } else if (currenPage == 4) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
      currenPage = 5;
      notifyListeners();
    } else if (currenPage == 5) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
      currenPage = 6;
      notifyListeners();
    } else if (currenPage == 6) {
      if (selectedHustlerType == "") {
        Fluttertoast.cancel();
        Fluttertoast.showToast(
          msg: 'Please select an option',
          backgroundColor: Colors.red,
        );
        return;
      } else {
        saveSelectedHustlerType(selectedHustlerType, true).then((value) {
          if (value) {
            pageController.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.ease,
            );
            currenPage = 7;
            notifyListeners();
          }
        });
      }
    } else if (currenPage == 7) {
      if (selectedVehicleType == "") {
        Fluttertoast.cancel();
        Fluttertoast.showToast(
          msg: 'Please select a vehicle Type',
          backgroundColor: Colors.red,
        );
        return;
      } else {
        saveSelectedHustlerType(selectedVehicleType, false).then((value) {
          if (value) {
            pageController.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.ease,
            );
            currenPage = 8;
            notifyListeners();
          }
        });
      }
    } else {
      Get.offAllNamed(AppRoute.home);
    }
  }

  //Previous Page
  void previousPage() {
    FocusManager.instance.primaryFocus!.unfocus();
    if (initialPage != null) {
      clearControllers();
      Get.back();
      return;
    }
    if (currenPage == 1) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
      currenPage = 0;
      notifyListeners();
      return;
    }
    if (currenPage == 2) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
      currenPage = 1;
      notifyListeners();
      return;
    }
    if (currenPage == 3) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
      currenPage = 2;
      notifyListeners();
      return;
    }
    if (currenPage == 4) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
      currenPage = 3;
      notifyListeners();
      return;
    }
    if (currenPage == 5) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
      currenPage = 4;
      notifyListeners();
      return;
    }
    if (currenPage == 6) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
      currenPage = 5;
      notifyListeners();
      return;
    }
    if (currenPage == 7) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
      currenPage = 6;
      notifyListeners();
      return;
    }
    if (currenPage == 8) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
      currenPage = 7;
      notifyListeners();
      return;
    }
  }

  // Save Selected Hustler Type or Vehicle Type
  Future<bool> saveSelectedHustlerType(String type, bool isHustlerType) async {
    showLoading();
    log({"type": type, "isHustlerType": isHustlerType}.toString());
    final userController =
        Provider.of<UserController>(Get.context!, listen: false);
    final response = await Apis.selectQuestionData(
      token: userController.token,
      question: isHustlerType ? "hustler" : "wheels_of_choice",
      answer: type,
    );
    final data = jsonDecode(response.body);
    Fluttertoast.cancel();
    hideLoading();
    if (response.statusCode == 200 || response.statusCode == 201) {
      Fluttertoast.showToast(
        msg: data['message'].toString(),
        backgroundColor: data['success'] ? Colors.green : Colors.red,
      );
      return data['success'];
    } else {
      Fluttertoast.showToast(
        msg: data['message'].toString(),
        backgroundColor: Colors.red,
      );
      return false;
    }
  }

  // Update PhoneNumber Api Call
  void updatePhoneNumber() async {
    FocusManager.instance.primaryFocus!.unfocus();
    showLoading();
    final userController =
        Provider.of<UserController>(Get.context!, listen: false);
    log("Token: ${userController.token}");
    final response = await Apis.updatePhoneNumber(
      phoneNumber: phoneNumberController.text,
      token: userController.token,
    );
    hideLoading();
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        Fluttertoast.showToast(
          msg: data['message'],
          backgroundColor: Colors.green,
        );
        pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
        currenPage = 4;
        notifyListeners();
      } else {
        Fluttertoast.showToast(
          msg: data['message'],
          backgroundColor: Colors.red,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: jsonDecode(response.body)['message'].toString(),
        backgroundColor: Colors.red,
      );
    }
  }

  // Sign Up Api Call
  void signUp() async {
    FocusManager.instance.primaryFocus!.unfocus();
    showLoading();
    final response = await Apis.signup(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
    hideLoading();
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        Fluttertoast.showToast(
          msg: data['message'],
          backgroundColor: Colors.green,
        );
        pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
        currenPage = 2;
        notifyListeners();
      } else {
        Fluttertoast.showToast(
          msg: data['message'],
          backgroundColor: Colors.red,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: jsonDecode(response.body)['message'].toString(),
        backgroundColor: Colors.red,
      );
    }
  }

  //Verify OTP
  void verifyOtp() async {
    FocusManager.instance.primaryFocus!.unfocus();
    showLoading();
    final response = await Apis.verifyOtpApi(
      email: emailController.text,
      otp: otpController.text,
    );
    hideLoading();
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        final token = data['token'];
        final userController =
            Provider.of<UserController>(Get.context!, listen: false);
        userController.setToken(token);
        userController.updateLocation();
        Fluttertoast.showToast(
          msg: data['message'],
          backgroundColor: Colors.green,
        );
        pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
        currenPage = 3;
        notifyListeners();
      } else {
        Fluttertoast.showToast(
          msg: data['message'],
          backgroundColor: Colors.red,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: jsonDecode(response.body)['message'][0],
        backgroundColor: Colors.red,
      );
    }
  }

  // Resend OTP
  Future<bool> resendOtp() async {
    FocusManager.instance.primaryFocus!.unfocus();
    showLoading();
    final response = await Apis.resendOtpApi(
      email: emailController.text,
    );
    hideLoading();
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        Fluttertoast.showToast(
          msg: data['message'].toString(),
          backgroundColor: Colors.green,
        );
        return true;
      } else {
        Fluttertoast.showToast(
          msg: data['message'].toString(),
          backgroundColor: Colors.red,
        );
        return false;
      }
    } else {
      Fluttertoast.showToast(
        msg: jsonDecode(response.body)['message'].toString(),
        backgroundColor: Colors.red,
      );
      return false;
    }
  }
}
