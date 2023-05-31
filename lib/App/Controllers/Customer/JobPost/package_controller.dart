import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thecourierapp/App/Common/common_widgets.dart';
import 'package:thecourierapp/App/Controllers/Customer/job_pos_controller.dart';

class PackageController extends ChangeNotifier {
  // TextEditingController
  final dateController = TextEditingController();
  final hourController = TextEditingController();
  final minuteController = TextEditingController();
  String periodController = 'AM';
  String? jobTypeController;
  String? vehicleTypeController;
  String? packageTypeController;
  final packagequantityController = TextEditingController();
  String pricepermileorparcel = 'mile';
  final priceController = TextEditingController();
  final noteController = TextEditingController();
  String packageImage = "";

  // FocusNode
  final dateFocusNode = FocusNode();
  final hourFocusNode = FocusNode();
  final minuteFocusNode = FocusNode();
  final periodFocusNode = FocusNode();
  final packageQuantityFocusNode = FocusNode();
  final priceFocusNode = FocusNode();
  final noteFocusNode = FocusNode();

  setImage(String path) async {
    packageImage = path;
    notifyListeners();
  }

  setJobType(String value) {
    jobTypeController = value;
    notifyListeners();
  }

  setVehicleType(String value) {
    vehicleTypeController = value;
    notifyListeners();
  }

  setPackageType(String value) {
    packageTypeController = value;
    notifyListeners();
  }

  setPricePerMileOrParcel(String value) {
    pricepermileorparcel = value;
    notifyListeners();
  }

  setPeriod(String value) {
    periodController = value;
    notifyListeners();
  }

  back(BuildContext context) {
    final postController =
        Provider.of<JobPostController>(context, listen: false);
    postController.setCurrentPage(1);
    clearAll();
  }

  nextPage(BuildContext context) {
    if (jobTypeController == null) {
      showMessage("Please select job type");
      return;
    }
    if (dateController.text.isEmpty) {
      showMessage("Please select date");
      return;
    }
    if (hourController.text.isEmpty) {
      showMessage("Please select hour");
      return;
    }
    if (minuteController.text.isEmpty) {
      showMessage("Please select minute");
      return;
    }
    if (vehicleTypeController == null) {
      showMessage("Please select vehicle type");
      return;
    }
    if (packageTypeController == null) {
      showMessage("Please select package type");
      return;
    }
    if (packagequantityController.text.isEmpty) {
      showMessage("Please enter package quantity");
      return;
    }

    if (priceController.text.isEmpty) {
      showMessage("Please enter price");
      return;
    }
    if (packageImage.isEmpty) {
      showMessage("Please select package image");
      return;
    }
    final postController =
        Provider.of<JobPostController>(context, listen: false);
    postController.setCurrentPage(3);
  }

  clearAll() {
    dateController.clear();
    hourController.clear();
    minuteController.clear();
    periodController = 'AM';
    jobTypeController = null;
    vehicleTypeController = null;
    packageTypeController = null;
    packagequantityController.clear();
    pricepermileorparcel = 'mile';
    priceController.clear();
    noteController.clear();
    packageImage = "";
    notifyListeners();
  }
}
