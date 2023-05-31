import 'dart:convert';
import 'dart:io';

import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:thecourierapp/App/Controllers/Customer/JobPost/delivery_controller.dart';
import 'package:thecourierapp/App/Controllers/Customer/JobPost/package_controller.dart';
import 'package:thecourierapp/App/Controllers/Customer/JobPost/pickup_controller.dart';
import 'package:thecourierapp/App/Controllers/Customer/job_pos_controller.dart';
import 'package:thecourierapp/App/Core/apis.dart';
import 'package:thecourierapp/App/Models/create_job_modal.dart';
import 'package:thecourierapp/App/Utils/app_page_routes.dart';

import '../../Common/common_widgets.dart';
import '../../Constants/colors.dart';
import '../../Constants/constant_heplers.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({Key? key}) : super(key: key);

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  late PickupController pickup;
  late JobPostController controller;
  late DeliveryController delivery;
  late PackageController package;

  List<String> packagesType = [
    "Small",
    "Medium",
    "Large",
    "Letter",
  ];

  @override
  void initState() {
    super.initState();
    pickup = Provider.of<PickupController>(context, listen: false);
    controller = Provider.of<JobPostController>(context, listen: false);
    delivery = Provider.of<DeliveryController>(context, listen: false);
    package = Provider.of<PackageController>(context, listen: false);
  }

  createjob() async {
    showLoading();
    final model = CreateJobModal(
      pickupLatitude: pickup.lat,
      pickupLongitude: pickup.long,
      pickupAddress: pickup.addressController.text,
      pickupAddressDetails: pickup.addressDetailsController.text,
      pickupName: pickup.nameController.text,
      pickupMobile: pickup.phoneNumberController.text,
      pickupInstructions: pickup.instructionController.text,
      deliveryLatitude: delivery.lat,
      deliveryLongitude: delivery.long,
      deliveryAddress: delivery.addressController.text,
      deliveryAddressDetails: delivery.addressDetailsController.text,
      deliveryName: delivery.nameController.text,
      deliveryMobile: delivery.phoneNumberController.text,
      deliveryInstructions: delivery.instructionController.text,
      jobType: package.jobTypeController!,
      deliveryDate: package.dateController.text,
      deliveryTime:
          "${package.hourController.text}:${package.minuteController.text} ${package.periodController}",
      prefferedVehicleChoice: package.vehicleTypeController!,
      itemType: package.packageTypeController!,
      noofItems: package.packagequantityController.text,
      pricepermile: package.pricepermileorparcel == "mile" ? 1 : 0,
      priceperdeliveryparcel: package.pricepermileorparcel == "parcel" ? 1 : 0,
      pricepermileparcel: double.parse(package.priceController.text),
      notes: package.noteController.text,
    );
    final token = await GetStorage().read("token");
    final response = await Apis.createJobApi(
      model: model,
      token: token,
      image: package.packageImage,
    );
    hideLoading();
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (jsonDecode(response.body)["success"] == true) {
        showSuccessSheet();
      } else {
        showMessage(
          jsonDecode(response.body)["message"],
          color: AppColors.red,
        );
      }
    } else {
      showMessage(
        jsonDecode(response.body)["message"],
        color: AppColors.red,
      );
    }
  }

  showSuccessSheet() {
    FocusManager.instance.primaryFocus?.unfocus();
    showModalBottomSheet(
      isDismissible: false,
      isScrollControlled: true,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (_) {
        return Container(
          height: Get.height * 0.4,
          width: Get.width,
          decoration: const BoxDecoration(
            color: AppColors.grey,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    tapper(
                      onPressed: () {
                        Get.back();
                        controller.setCurrentPage(0);
                        pickup.clearAll();
                        delivery.clearAll();
                        package.clearAll();
                        Get.offAllNamed(AppRoute.customerhome);
                      },
                      child: const Icon(
                        Icons.close,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Container(
                        width: getHorizontalSize(95),
                        height: getVerticalSize(95),
                        decoration: DottedDecoration(
                          shape: Shape.circle,
                          color: AppColors.black,
                          strokeWidth: 1,
                          dash: const [5, 5],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.white,
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(25.0),
                                child: Image.asset(
                                  'assets/images/confettiicon.png',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: getVerticalSize(20),
                      ),
                      Text(
                        'job posted successfully'.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: getFontSize(18),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: getVerticalSize(10),
                      ),
                      Text(
                        'Your job is posted successfully.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: getFontSize(18),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  showSureSheet() {
    FocusManager.instance.primaryFocus?.unfocus();
    showModalBottomSheet(
      isDismissible: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (_) {
        return Container(
          height: getVerticalSize(250),
          width: Get.width,
          decoration: const BoxDecoration(
            color: AppColors.grey,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    tapper(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Icon(
                        Icons.close,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      myText(
                        "Post Job",
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(
                        height: getVerticalSize(20),
                      ),
                      myText(
                        "Are you sure you want to post\nthis job?",
                        textAlign: TextAlign.center,
                        fontSize: 18,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: getVerticalSize(10),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: tapper(
                        onPressed: () {
                          Get.back();
                        },
                        child: Container(
                          height: getVerticalSize(50),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.black,
                            ),
                          ),
                          child: Center(
                            child: myText(
                              "Cancel",
                              fontSize: 18,
                              color: AppColors.black,
                              textAlign: TextAlign.center,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: getHorizontalSize(10),
                    ),
                    Expanded(
                      child: tapper(
                        onPressed: () {
                          Get.back();
                          createjob();
                        },
                        child: Container(
                          height: getVerticalSize(50),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: myText(
                              "Post",
                              fontSize: 18,
                              color: AppColors.black,
                              textAlign: TextAlign.center,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: getVerticalSize(10),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<PickupController, DeliveryController, PackageController>(
        builder: (context, first, second, third, child) {
      return Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: getHorizontalSize(20),
          ),
          child: Column(
            children: [
              const Divider(
                color: AppColors.darkGrey,
              ),
              SizedBox(height: getVerticalSize(20)),
              titleBuilder("Pickup & Delivery Location"),
              SizedBox(height: getVerticalSize(20)),
              Row(
                children: [
                  CircleAvatar(
                    radius: getSize(12),
                    backgroundColor: AppColors.primary,
                    child: Text(
                      "P",
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: getSize(12),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: getHorizontalSize(10)),
                  Expanded(
                    child: myText(
                      pickup.addressController.text,
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: getVerticalSize(10)),
              Row(
                children: [
                  CircleAvatar(
                    radius: getSize(12),
                    backgroundColor: AppColors.primary,
                    child: Text(
                      "D",
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: getSize(12),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: getHorizontalSize(10)),
                  Expanded(
                    child: myText(
                      delivery.addressController.text,
                      maxLines: 2,
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: getVerticalSize(20)),
              const Divider(
                color: AppColors.darkGrey,
              ),
              SizedBox(height: getVerticalSize(20)),
              titleBuilder("Delivery Time & Date"),
              SizedBox(height: getVerticalSize(20)),
              Row(
                children: [
                  const Icon(Icons.calendar_month_outlined),
                  const SizedBox(width: 10),
                  Expanded(
                    child: myText(
                      package.dateController.text,
                      fontSize: 16,
                    ),
                  ),
                  tapper(
                    onPressed: () {
                      controller.setCurrentPage(2);
                    },
                    child: myText(
                      "Change",
                      color: AppColors.black,
                      fontSize: 14,
                      underLine: true,
                    ),
                  ),
                ],
              ),
              SizedBox(height: getVerticalSize(10)),
              Row(
                children: [
                  const Icon(Icons.access_time_outlined),
                  const SizedBox(width: 10),
                  Expanded(
                    child: myText(
                      "${package.hourController.text}:${package.minuteController.text} ${package.periodController}",
                      fontSize: 16,
                    ),
                  ),
                  tapper(
                    onPressed: () {
                      controller.setCurrentPage(2);
                    },
                    child: myText(
                      "Change",
                      color: AppColors.black,
                      fontSize: 14,
                      underLine: true,
                    ),
                  ),
                ],
              ),
              SizedBox(height: getVerticalSize(20)),
              const Divider(
                color: AppColors.darkGrey,
              ),
              SizedBox(height: getVerticalSize(20)),
              titleBuilder("Package Info"),
              SizedBox(height: getVerticalSize(20)),
              Container(
                height: getVerticalSize(127),
                width: double.infinity,
                decoration: DottedDecoration(
                  shape: Shape.box,
                  color: AppColors.darkGrey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: package.packageImage.isEmpty
                    ? const Center(
                        child: Text("No Image"),
                      )
                    : Image.file(
                        File(package.packageImage),
                        fit: BoxFit.contain,
                      ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  tapper(
                    onPressed: () {
                      controller.setCurrentPage(2);
                    },
                    child: myText(
                      "Change",
                      color: AppColors.black,
                      fontSize: 14,
                      underLine: true,
                    ),
                  ),
                ],
              ),
              SizedBox(height: getVerticalSize(20)),
              Row(
                children: [
                  Row(
                    children: [
                      myText(
                        "Type: ",
                        fontSize: 14,
                      ),
                      myText(
                        packagesType[
                            int.parse(package.packageTypeController ?? "1") -
                                1],
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  SizedBox(width: getHorizontalSize(10)),
                  Row(
                    children: [
                      myText(
                        "Quantity: ",
                        fontSize: 14,
                      ),
                      myText(
                        "x${package.packagequantityController.text}",
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  SizedBox(width: getHorizontalSize(10)),
                  Row(
                    children: [
                      myText(
                        "Price/${package.pricepermileorparcel == "mile" ? "Mile" : "Parcel"}: ",
                        fontSize: 14,
                      ),
                      myText(
                        "\$${package.priceController.text}",
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: getVerticalSize(20)),
              const Divider(
                color: AppColors.darkGrey,
              ),
              SizedBox(height: getVerticalSize(20)),
              titleBuilder("Contact"),
              SizedBox(height: getVerticalSize(20)),
              Row(
                children: [
                  myText(
                    "Pickup Contact",
                    fontSize: 13,
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: myText(
                      pickup.nameController.text,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  myText(
                    pickup.phoneNumberController.text,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
              SizedBox(height: getVerticalSize(10)),
              Row(
                children: [
                  myText(
                    "Delivery Contact",
                    fontSize: 13,
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: myText(
                      delivery.nameController.text,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  myText(
                    delivery.phoneNumberController.text,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ],
              ),
              SizedBox(height: getVerticalSize(20)),
              tapper(
                onPressed: () {
                  showSureSheet();
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: myText(
                      "Post Job",
                      color: AppColors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: getVerticalSize(20)),
            ],
          ),
        ),
      );
    });
  }

  Widget titleBuilder(String title) {
    return Row(
      children: [
        ImageIcon(
          const AssetImage("assets/images/list.png"),
          color: AppColors.black,
          size: getSize(20),
        ),
        SizedBox(width: getHorizontalSize(10)),
        myText(
          title,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ],
    );
  }
}
