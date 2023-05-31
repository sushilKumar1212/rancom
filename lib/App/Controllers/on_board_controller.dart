import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:thecourierapp/App/Models/on_board_model.dart';
import 'package:thecourierapp/App/Utils/app_page_routes.dart';

import '../Core/apis.dart';

class OnBoardController extends ChangeNotifier {
  final PageController pageController = PageController(initialPage: 0);
  int currentPage = 0;
  OnboardModel? onboardModel;
  bool isloding = false;

  OnBoardController() {
    pageController.addListener(() {
      currentPage = pageController.page!.toInt();
      notifyListeners();
    });
  }

  callOnboardApi() async {
    isloding = true;
    notifyListeners();
    final response = await Apis.onboardApi();
    if (response.statusCode == 200) {
      onboardModel = OnboardModel.fromJson(jsonDecode(response.body));
      isloding = false;
      notifyListeners();
    } else {
      isloding = false;
      notifyListeners();
    }
  }

  void nextPage() async {
    await pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
    notifyListeners();
  }

  void onDone() {
    GetStorage().write("onboard", true);
    Get.offNamed(AppRoute.loginSelection);
  }

  void previousPage() {
    pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
    currentPage = 0;
    notifyListeners();
  }

  onSkip() {
    pageController.jumpToPage(2);
    currentPage = 2;
    notifyListeners();
  }
}
