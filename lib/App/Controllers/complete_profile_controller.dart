import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:thecourierapp/App/Common/common_widgets.dart';
import 'package:thecourierapp/App/Constants/constant_heplers.dart';
import 'package:thecourierapp/App/Core/apis.dart';
import 'package:thecourierapp/App/Models/document_info_model.dart';
import 'package:thecourierapp/App/Models/personal_info_model.dart';
import 'package:thecourierapp/App/Models/vehicle_info_model.dart';
import 'package:thecourierapp/App/Utils/app_page_routes.dart';

class CompleteProfileController extends ChangeNotifier {
  // TextEditingControllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final address2Controller = TextEditingController();
  final cityController = TextEditingController();
  final postcodeController = TextEditingController();
  final countryController = TextEditingController();
  final phoneController = TextEditingController();
  final dobController = TextEditingController();
  final ninController = TextEditingController();

  //Vehicles
  final vehicleMakeController = TextEditingController();
  final vehicleModelController = TextEditingController();
  final vehicleYearController = TextEditingController();
  final vehicleRegisterController = TextEditingController();

  //Banking
  final bankNameController = TextEditingController();
  final accountNameController = TextEditingController();
  final accountNumberController = TextEditingController();
  final sortCodeController = TextEditingController();

  // FocusNodes
  final nameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final addressFocusNode = FocusNode();
  final address2FocusNode = FocusNode();
  final cityFocusNode = FocusNode();
  final postcodeFocusNode = FocusNode();
  final countryFocusNode = FocusNode();
  final phoneFocusNode = FocusNode();
  final dobFocusNode = FocusNode();
  final ninFocusNode = FocusNode();
  final vehicleMakeFocusNode = FocusNode();
  final vehicleModelFocusNode = FocusNode();
  final vehicleYearFocusNode = FocusNode();
  final vehicleRegisterFocusNode = FocusNode();
  final bankNameFocusNode = FocusNode();
  final accountNameFocusNode = FocusNode();
  final accountNumberFocusNode = FocusNode();
  final sortCodeFocusNode = FocusNode();

  clear() async {
    nameController.clear();
    emailController.clear();
    addressController.clear();
    phoneController.clear();
    dobController.clear();
    ninController.clear();
    vehicleMakeController.clear();
    vehicleModelController.clear();
    vehicleYearController.clear();
    vehicleRegisterController.clear();
    bankNameController.clear();
    accountNameController.clear();
    accountNumberController.clear();
    sortCodeController.clear();
    personalInfoModel = null;
    driverVehicleInfo = null;
    documentsInfoModel = null;
    personalInfoLoading = true;
    vehicleInfoLoading = true;
    documentInfoLoading = true;
    bankinginfoloading = true;
    frontDrivingLicense = null;
    backDrivingLicense = null;
    frontImage = null;
    rearImage = null;
    rightImage = null;
    leftImage = null;
    proofOfAddress = null;

    notifyListeners();
  }

  update() {
    notifyListeners();
  }

  PersonalInfoModel? personalInfoModel;
  DriverVehicleInfo? driverVehicleInfo;
  DocumentsInfoModel? documentsInfoModel;
  bool personalInfoLoading = true;
  bool vehicleInfoLoading = true;
  bool documentInfoLoading = true;
  bool bankinginfoloading = true;

  getPersonalDetails({bool isFirst = true}) async {
    if (isFirst) {
      personalInfoLoading = true;
    }
    final token = GetStorage().read("token");
    log(token.toString());
    final response = await Apis.getPersonalDetails(
      token: token,
    );
    personalInfoLoading = false;
    notifyListeners();
    hideLoading();
    if (response.statusCode == 200 || response.statusCode == 201) {
      personalInfoModel = personalInfoModelFromJson(response.body);
      if (isFirst) {
        nameController.text =
            "${personalInfoModel!.driver.firstName} ${personalInfoModel!.driver.lastName}";
        emailController.text = personalInfoModel!.driver.email;
        addressController.text = personalInfoModel!.driver.address1 ?? "";
        phoneController.text = personalInfoModel!.driver.phoneNumber ?? '';
        dobController.text = personalInfoModel!.driver.dateOfBirth == null
            ? ""
            : DateFormat('yyyy-MM-dd').format(
                personalInfoModel!.driver.dateOfBirth!,
              );
        ninController.text =
            personalInfoModel!.driver.nationalInsuranceNumber ?? '';
        cityController.text = personalInfoModel!.driver.city ?? '';
        address2Controller.text = personalInfoModel!.driver.address2 ?? '';
        postcodeController.text = personalInfoModel!.driver.pinCode ?? '';
      }
    } else {
      log(response.body);
    }
  }

  getvehicleDetails({bool isFirst = true}) async {
    if (isFirst) {
      vehicleInfoLoading = true;
    }
    final token = GetStorage().read("token");
    final response = await Apis.getVehicleDetails(
      token: token,
    );
    vehicleInfoLoading = false;
    notifyListeners();
    hideLoading();
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      if (data['success'] == false) {
        return;
      }
      driverVehicleInfo = driverVehicleInfoFromJson(response.body);
      vehicleMakeController.text = driverVehicleInfo!.vehicle.make;
      vehicleModelController.text = driverVehicleInfo!.vehicle.model;
      vehicleYearController.text = driverVehicleInfo!.vehicle.year;
      vehicleRegisterController.text = driverVehicleInfo!.vehicle.registration;
      frontImage =
          "${Apis.baseUrl}/${driverVehicleInfo!.vehicle.attachments.first.path}";
      rearImage =
          "${Apis.baseUrl}/${driverVehicleInfo!.vehicle.attachments[1].path}";
      leftImage =
          "${Apis.baseUrl}/${driverVehicleInfo!.vehicle.attachments[2].path}";
      rightImage =
          "${Apis.baseUrl}/${driverVehicleInfo!.vehicle.attachments[3].path}";
    } else {
      log(response.body);
    }
  }

  getDocumentDetails({bool isFirst = true}) async {
    if (isFirst) {
      documentInfoLoading = true;
    }
    final token = GetStorage().read("token");
    final response = await Apis.getDocumentsDetails(
      token: token,
    );
    documentInfoLoading = false;
    notifyListeners();
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      if (data['success'] == false) {
        return;
      }
      documentsInfoModel = documentsInfoModelFromJson(response.body);
      List<String?> images = [];

      for (var i = 0; i < documentsInfoModel!.documents.length; i++) {
        images.add(documentsInfoModel!.documents[i].imageUrl);
      }
      proofOfAddress = images[0];
      frontDrivingLicense = images[1];
      backDrivingLicense = images[2];
      insuranceDocument = images[3];
    } else {
      log(response.body);
    }
  }

  getBankingDetails() async {
    bankinginfoloading = true;
    final token = GetStorage().read("token");
    final response = await Apis.getBankingDetails(
      token: token,
    );
    bankinginfoloading = false;
    notifyListeners();
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      if (data['success'] == false) {
        return;
      }
      bankNameController.text = data['bankingDetails']['bank_name'];
      accountNameController.text = data['bankingDetails']['name_as_appears'];
      accountNumberController.text = data['bankingDetails']['account_number'];
      sortCodeController.text = data['bankingDetails']['sort_code'];
    } else {
      log(response.body);
    }
  }

  selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900, 1),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      notifyListeners();
    }
  }

  // Vehicle Images
  String? frontImage;
  String? rearImage;
  String? rightImage;
  String? leftImage;

  // Document Images
  String? proofOfAddress;
  String? frontDrivingLicense;
  String? backDrivingLicense;
  String? insuranceDocument;

  // Confirmations
  bool workInUK = false;
  bool happyToCheck = false;
  bool detailsCorrect = false;
  bool termsAndConditions = false;

  final pageController = PageController();
  int currentPage = 0;

  setCurrentPage(int page) {
    currentPage = page;
    notifyListeners();
    pageController.animateToPage(
      currentPage,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  nextPage() {
    if (currentPage == 0) {
      if (nameController.text.isEmpty) {
        nameFocusNode.requestFocus();
        return;
      }
      if (emailController.text.isEmpty) {
        emailFocusNode.requestFocus();
        return;
      }
      if (addressController.text.isEmpty) {
        addressFocusNode.requestFocus();
        return;
      }
      if (address2Controller.text.isEmpty) {
        address2FocusNode.requestFocus();
        return;
      }
      if (cityController.text.isEmpty) {
        cityFocusNode.requestFocus();
        return;
      }
      if (postcodeController.text.isEmpty) {
        postcodeFocusNode.requestFocus();
        return;
      }
      if (phoneController.text.isEmpty) {
        phoneFocusNode.requestFocus();
        return;
      }
      if (dobController.text.isEmpty) {
        dobFocusNode.requestFocus();
        return;
      }
      if (ninController.text.isEmpty) {
        ninFocusNode.requestFocus();
        return;
      }
      if (personalInfoModel!.driver.phoneNumber == null) {
        showMessage(
          "Please verify your phone number",
        );
        return;
      }
      updatePersonalDetails();
    } else if (currentPage == 1) {
      if (vehicleRegisterController.text.isEmpty) {
        vehicleRegisterFocusNode.requestFocus();
        return;
      }
      if (vehicleMakeController.text.isEmpty) {
        vehicleMakeFocusNode.requestFocus();
        return;
      }
      if (vehicleModelController.text.isEmpty) {
        vehicleModelFocusNode.requestFocus();
        return;
      }
      if (vehicleYearController.text.isEmpty) {
        vehicleYearFocusNode.requestFocus();
        return;
      }

      if (frontImage == null) {
        showMessage(
          "Please upload front image",
        );
        return;
      }
      if (rearImage == null) {
        showMessage(
          "Please upload back image",
        );
        return;
      }
      if (rightImage == null) {
        showMessage(
          "Please upload right image",
        );
        return;
      } else if (leftImage == null) {
        showMessage(
          "Please upload left image",
        );
        return;
      }
      updateVehicleDetails();
    } else if (currentPage == 2) {
      if (proofOfAddress == null) {
        showMessage(
          "Please upload proof of address",
        );
        return;
      }
      if (frontDrivingLicense == null) {
        showMessage(
          "Please upload front driving license",
        );
        return;
      }
      if (backDrivingLicense == null) {
        showMessage(
          "Please upload back driving license",
        );
        return;
      }
      if (insuranceDocument == null) {
        showMessage(
          "Please upload insurance document",
        );
        return;
      }
      updateDocumentDetails();
    } else if (currentPage == 3) {
      log("Page 3");
      if (bankNameController.text.isEmpty) {
        bankNameFocusNode.requestFocus();
        return;
      }
      if (accountNameController.text.isEmpty) {
        accountNameFocusNode.requestFocus();
        return;
      }
      if (accountNumberController.text.isEmpty) {
        accountNumberFocusNode.requestFocus();
        return;
      }
      if (sortCodeController.text.isEmpty) {
        sortCodeFocusNode.requestFocus();
        return;
      }

      if (workInUK == false) {
        showMessage(
          "Please confirm that you work in UK",
        );
        return;
      }
      if (happyToCheck == false) {
        showMessage(
          "Please confirm that you are happy to be checked",
        );
        return;
      }
      if (detailsCorrect == false) {
        showMessage(
          "Please confirm that your details are correct",
        );
        return;
      }
      if (termsAndConditions == false) {
        showMessage(
          "Please confirm that you have read and agree to our terms and conditions",
        );
        return;
      }
      updateBankDetails();
    } else if (currentPage < 3) {
      currentPage++;
      notifyListeners();
      pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
    Get.offAll(currentPage);
    log("Current Page: $currentPage");
  }

  updatePersonalDetails() async {
    showLoading();
    final token = GetStorage().read("token");
    final response = await Apis.updatePersonalDetails(
      token: token,
      address: addressController.text,
      dateOfBirth: DateTime.parse((dobController.text)).toIso8601String(),
      nationalInsuranceNumber: ninController.text,
      arealocality: address2Controller.text,
      city: cityController.text,
      country: countryController.text,
      postalCode: postcodeController.text,
    );
    hideLoading();
    if (response.statusCode == 200 || response.statusCode == 201) {
      showMessage(
        "Personal details updated successfully",
        color: Colors.green,
      );
      getPersonalDetails(isFirst: false);
      currentPage++;
      notifyListeners();
      pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      showMessage(
        jsonDecode(response.body)["message"].toString(),
        color: Colors.red,
      );
    }
  }

  updateVehicleDetails() async {
    showLoading();
    final token = GetStorage().read("token");
    final response = await Apis.updateVehicleDetaisl(
      token: token,
      vehicleMake: vehicleMakeController.text,
      vehicleModel: vehicleModelController.text,
      vehicleRegistration: vehicleRegisterController.text,
      vehicleYear: vehicleYearController.text,
      frontPic: frontImage!,
      backPic: rearImage!,
      rightPic: rightImage!,
      leftPic: leftImage!,
    );
    hideLoading();
    if (response.statusCode == 200 || response.statusCode == 201) {
      showMessage(
        "Vehicle details updated successfully",
        color: Colors.green,
      );
      getvehicleDetails(isFirst: false);
      currentPage++;
      notifyListeners();
      pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      showMessage(
        jsonDecode(response.body)["message"].toString(),
        color: Colors.red,
      );
    }
  }

  updateDocumentDetails() async {
    showLoading();
    final token = GetStorage().read("token");
    final response = await Apis.updateDocumentInfo(
      token: token,
      proofofAddress: proofOfAddress!,
      frontdrivingLicence: frontDrivingLicense!,
      backdrivingLicence: backDrivingLicense!,
      insurance: insuranceDocument!,
    );
    hideLoading();
    if (response.statusCode == 200 || response.statusCode == 201) {
      showMessage(
        "Document details updated successfully",
        color: Colors.green,
      );
      getDocumentDetails(isFirst: false);
      currentPage++;
      notifyListeners();
      pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      showMessage(
        jsonDecode(response.body)["message"].toString(),
        color: Colors.red,
      );
    }
  }

  updatePhoneNumber() async {
    showLoading();
    final token = GetStorage().read("token");
    log(token.toString());
    final response = await Apis.updatePhoneNumber(
      token: token,
      phoneNumber: phoneController.text,
    );
    hideLoading();
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      if (data['success'] = true) {
        showMessage(
          "Phone number updated successfully",
          color: Colors.green,
        );
        getPersonalDetails(isFirst: false);
      } else {
        showMessage(
          data['message'].toString(),
          color: Colors.red,
        );
      }
    } else {
      showMessage(
        jsonDecode(response.body)["message"][0].toString(),
        color: Colors.red,
      );
    }
  }

  updateBankDetails() async {
    showLoading();
    final token = GetStorage().read("token");
    final response = await Apis.updateBankingDetails(
      token: token,
      bankName: bankNameController.text,
      nameAsAppears: accountNameController.text,
      accountNumber: accountNumberController.text,
      sortCode: sortCodeController.text,
    );
    hideLoading();
    if (response.statusCode == 200 || response.statusCode == 201) {
      showMessage(
        "Your Account has been submitted for review",
        color: Colors.green,
      );
      Get.offAllNamed(AppRoute.home);
    } else {
      showMessage(
        jsonDecode(response.body)["message"].toString(),
        color: Colors.red,
      );
    }
  }
}
