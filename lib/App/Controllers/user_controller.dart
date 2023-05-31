import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:thecourierapp/App/Core/apis.dart';

class UserController extends ChangeNotifier {
  String token = '';

  UserController() {
    token = GetStorage().read('token') ?? '';
  }

  Future<void> setToken(String token) async {
    this.token = token;
    await GetStorage().write('token', token);
    notifyListeners();
  }

  void clearToken() {
    token = '';
    GetStorage().remove('token');
    notifyListeners();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Geolocator.openAppSettings();
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.getCurrentPosition();
    }
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    final position = await Geolocator.getCurrentPosition(
      forceAndroidLocationManager: true,
    );
    return position;
  }

  updateLocation({
    bool isCustomer = false,
  }) async {
    final position = await _determinePosition();
    log(position.toJson().toString());
    final respose = await Apis.updateLocationApi(
      lat: position.latitude,
      long: position.longitude,
      isCustomer: isCustomer,
      token: await GetStorage().read('token'),
    );
    if (respose.statusCode == 200 || respose.statusCode == 201) {
      log(respose.body);
    } else {
      log(respose.body);
    }
  }

  bool get isLogged => token.isNotEmpty;
}
