import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:thecourierapp/App/Common/common_widgets.dart';
import 'package:thecourierapp/App/Constants/constant_heplers.dart';
import 'package:thecourierapp/App/Core/apis.dart';

class HomeController extends ChangeNotifier {
  bool isonDuty = false;

  HomeController() {
    getDutyStatus();
    getjobsCount();
  }

  int count = 0;
  int totalCount = 0;
  int onGoingCount = 0;

  getjobsCount() async {
    final response = await Apis.getSummary();
    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsondata = jsonDecode(response.body);
      if (jsondata['success']) {
        count = jsondata['jobsRequestsCount'];
        totalCount = jsondata['pastJobsCount'];
        onGoingCount = jsondata['onGoingJobsCount'];
        notifyListeners();
      } else {
        log(jsondata['message']);
      }
    }
    notifyListeners();
  }

  getDutyStatus() async {
    bool respone = GetStorage().read('isonduty') ?? false;
    isonDuty = respone;
    notifyListeners();
  }

  switchDutyOnOff({
    required bool status,
  }) {
    isonDuty = status;
    notifyListeners();
  }

  switchDuty() async {
    showLoading();
    final response = await Apis.driveronoffDuty(
      token: GetStorage().read('token'),
      status: !isonDuty,
    );
    hideLoading();
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      log(data.toString());
      if (data['success'] == true) {
        isonDuty = !isonDuty;
        GetStorage().write('isonduty', isonDuty);
        notifyListeners();
      } else {
        showMessage(data['message']);
      }
    } else {
      showMessage('Something went wrong');
    }
  }
}
