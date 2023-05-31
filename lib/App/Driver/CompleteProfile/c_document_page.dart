import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:images_picker/images_picker.dart';
import 'package:provider/provider.dart';

import '../../Common/common_widgets.dart';
import '../../Constants/colors.dart';
import '../../Constants/constant_heplers.dart';
import '../../Controllers/complete_profile_controller.dart';
import 'c_vehicle_page.dart';

class CDocumentPage extends StatefulWidget {
  const CDocumentPage({Key? key}) : super(key: key);

  @override
  State<CDocumentPage> createState() => _CDocumentPageState();
}

enum ImageType {
  proofOfAddress,
  frontDrivingLicense,
  backDrivingLicense,
  insuranceDocument,
}

class _CDocumentPageState extends State<CDocumentPage> {
  late CompleteProfileController controller;

  @override
  void initState() {
    super.initState();
    controller = Provider.of<CompleteProfileController>(context, listen: false);
    controller.getDocumentDetails();
  }

  showsourcepicker(ImageType type) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: AppColors.transparent,
      builder: (BuildContext bc) {
        return Container(
          height: getVerticalSize(220),
          width: Get.width,
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: getHorizontalSize(20),
            vertical: getVerticalSize(20),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Pick Image",
                    style: TextStyle(
                      fontSize: getFontSize(16),
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  tapper(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Icon(
                      Icons.clear,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
              ListTile(
                onTap: () {
                  pickFromCamera(type);
                  Get.back();
                },
                leading: const Icon(
                  Icons.camera_alt_outlined,
                  color: AppColors.black,
                ),
                title: Text(
                  "Open Camera",
                  style: TextStyle(
                    fontSize: getFontSize(14),
                    color: AppColors.black,
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  pickImage(type);
                  Get.back();
                },
                leading: const Icon(
                  Icons.image_outlined,
                  color: AppColors.black,
                ),
                title: Text(
                  "Pick From Gallery",
                  style: TextStyle(
                    fontSize: getFontSize(14),
                    color: AppColors.black,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  pickFromCamera(ImageType type) async {
    final images = await ImagePicker.platform.pickImage(
      source: ImageSource.camera,
      imageQuality: 20,
    );
    if (images != null) {
      final image = images;
      switch (type) {
        case ImageType.proofOfAddress:
          controller.proofOfAddress = image.path;
          break;
        case ImageType.frontDrivingLicense:
          controller.frontDrivingLicense = image.path;
          break;
        case ImageType.backDrivingLicense:
          controller.backDrivingLicense = image.path;
          break;
        case ImageType.insuranceDocument:
          controller.insuranceDocument = image.path;
          break;
      }
      setState(() {});
    }
  }

  pickImage(ImageType imageType) async {
    final images = await ImagesPicker.pick(
      count: 1,
      pickType: PickType.image,
      quality: 0.2,
    );
    if (images != null) {
      final image = images.first;
      switch (imageType) {
        case ImageType.proofOfAddress:
          controller.proofOfAddress = image.path;
          break;
        case ImageType.frontDrivingLicense:
          controller.frontDrivingLicense = image.path;
          break;
        case ImageType.backDrivingLicense:
          controller.backDrivingLicense = image.path;
          break;
        case ImageType.insuranceDocument:
          controller.insuranceDocument = image.path;
          break;
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CompleteProfileController>(builder: (context, data, child) {
      if (data.documentInfoLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: getHorizontalSize(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: getVerticalSize(10),
                    ),
                    myText(
                      "Please submit a document that verifies your current address, such as a utility bill, bank statement, or government-issued ID.:",
                      fontSize: 16,
                    ),
                    SizedBox(
                      height: getVerticalSize(20),
                    ),
                    myText(
                      "Proof of Address",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(
                      height: getVerticalSize(10),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: boxMaker(
                            image: controller.proofOfAddress,
                            title: "",
                            onTap: () {
                              showsourcepicker(ImageType.proofOfAddress);
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: getVerticalSize(10),
                    ),
                    myText(
                      "Driving License",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(
                      height: getVerticalSize(10),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: boxMaker(
                            image: controller.frontDrivingLicense,
                            title: "Front Picture",
                            onTap: () {
                              showsourcepicker(ImageType.frontDrivingLicense);
                            },
                          ),
                        ),
                        SizedBox(
                          width: getHorizontalSize(10),
                        ),
                        Expanded(
                          child: boxMaker(
                            image: controller.backDrivingLicense,
                            title: "Rear Picture",
                            onTap: () {
                              showsourcepicker(ImageType.backDrivingLicense);
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: getVerticalSize(10),
                    ),
                    myText(
                      "Insurance Document",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(
                      height: getVerticalSize(10),
                    ),
                    myText(
                      "Before you can start driving and accepting jobs, we require you to provide proof of insurance policy.",
                      fontSize: 16,
                    ),
                    SizedBox(
                      height: getVerticalSize(10),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: boxMaker(
                            image: controller.insuranceDocument,
                            title: "",
                            onTap: () {
                              showsourcepicker(ImageType.insuranceDocument);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
                right: 20,
                left: 20,
                bottom: 25,
              ),
              child: tapper(
                onPressed: () {
                  controller.nextPage();
                },
                child: Container(
                  height: getVerticalSize(50),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: myText(
                      "NEXT",
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
