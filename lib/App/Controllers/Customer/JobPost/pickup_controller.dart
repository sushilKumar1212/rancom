import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:thecourierapp/App/Common/common_widgets.dart';
import 'package:thecourierapp/App/Core/apis.dart';

import '../../../Constants/constant_heplers.dart';
import '../job_pos_controller.dart';

class PickupController extends ChangeNotifier {
  double lat = 0;
  double long = 0;
  bool showMap = false;
  List<Map<String, dynamic>> places = [];
  bool isloading = false;
  bool ispickupChanged = false;

  changeDeliveryLocation({
    required double lat,
    required double long,
  }) {
    this.lat = lat;
    this.long = long;
    notifyListeners();
  }

  // TextController
  final searchAddressController = TextEditingController();
  final addressController = TextEditingController();
  final addressDetailsController = TextEditingController();
  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final instructionController = TextEditingController();

  changeMap(bool data) {
    showMap = data;
    notifyListeners();
  }

  getCurrentLocation({
    bool delivery = false,
  }) async {
    showLoading();
    Position position = await _determinePosition(
      delivery: delivery,
    );
    final place = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    hideLoading();
    addressDetailsController.text =
        '${place.first.street ?? ""}, ${place.first.subLocality ?? ""}';
    addressController.text =
        '${place.first.locality ?? ""}, ${place.first.administrativeArea ?? ""}, ${place.first.country ?? ""}, ${place.first.postalCode ?? ""}';
    notifyListeners();
  }

  Future<Position> _determinePosition({
    bool delivery = false,
  }) async {
    bool serviceEnabled;
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        hideLoading();
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      hideLoading();
      Geolocator.openAppSettings();
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
    }
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      hideLoading();
      return Future.error('Location services are disabled.');
    }
    final position = await Geolocator.getCurrentPosition(
      forceAndroidLocationManager: true,
    );

    lat = position.latitude;
    long = position.longitude;
    notifyListeners();
    return position;
  }

  getPlaces() async {
    isloading = true;
    notifyListeners();
    final places = await Apis.searchPlaces(
      searchAddressController.text,
    );
    if (searchAddressController.text.isNotEmpty) {
      this.places = places;
    }

    isloading = false;
    notifyListeners();
  }

  clearPlaces() {
    places = [];
    isloading = false;
    notifyListeners();
  }

  back() async {
    if (showMap) {
      showMap = false;
      ispickupChanged = false;
      log('ispickupChanged: $ispickupChanged');
      notifyListeners();
    } else {
      nameController.clear();
      phoneNumberController.clear();
      instructionController.clear();
      addressController.clear();
      addressDetailsController.clear();
      searchAddressController.clear();
      places = [];
      isloading = false;
      ispickupChanged = false;
      log('ispickupChanged: $ispickupChanged');
      Get.back();
    }
  }

  nextPage(BuildContext context) {
    if (addressDetailsController.text.isEmpty) {
      showMessage('Please Enter address details');
      return;
    }
    if (nameController.text.isEmpty) {
      showMessage('Please Enter Name');
      return;
    }
    if (phoneNumberController.text.isEmpty) {
      showMessage('Please Enter Phone Number');
      return;
    }
    if (phoneNumberController.text.length < 10) {
      showMessage('Please Enter Valid Phone Number');
      return;
    }
    if (instructionController.text.isEmpty) {
      showMessage('Please Enter Instruction');
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();

    final postController =
        Provider.of<JobPostController>(context, listen: false);
    postController.setCurrentPage(1);
  }

  clearAll() {
    nameController.clear();
    phoneNumberController.clear();
    instructionController.clear();
    addressController.clear();
    addressDetailsController.clear();
    searchAddressController.clear();
    places = [];
    showMap = false;
    isloading = false;
    ispickupChanged = false;
    log('ispickupChanged: $ispickupChanged');
    notifyListeners();
  }
}
