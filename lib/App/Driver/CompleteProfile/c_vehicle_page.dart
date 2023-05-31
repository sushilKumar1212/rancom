import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:images_picker/images_picker.dart';
import 'package:provider/provider.dart';

import '../../Common/common_widgets.dart';
import '../../Constants/colors.dart';
import '../../Constants/constant_heplers.dart';
import '../../Controllers/complete_profile_controller.dart';

enum ImageType {
  front,
  rear,
  left,
  right,
}

class CVehiclePage extends StatefulWidget {
  const CVehiclePage({Key? key}) : super(key: key);

  @override
  State<CVehiclePage> createState() => _CVehiclePageState();
}

class _CVehiclePageState extends State<CVehiclePage> {
  late CompleteProfileController controller;

  @override
  void initState() {
    super.initState();
    controller = Provider.of<CompleteProfileController>(context, listen: false);
    controller.getvehicleDetails();
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
        case ImageType.front:
          controller.frontImage = image.path;
          break;
        case ImageType.rear:
          controller.rearImage = image.path;
          break;
        case ImageType.left:
          controller.leftImage = image.path;
          break;
        case ImageType.right:
          controller.rightImage = image.path;
          break;
      }
      setState(() {});
    }
  }

  pickImage(ImageType type) async {
    final images = await ImagesPicker.pick(
      count: 1,
      pickType: PickType.image,
      quality: 0.2,
    );
    if (images != null) {
      final image = images.first;
      switch (type) {
        case ImageType.front:
          controller.frontImage = image.path;
          break;
        case ImageType.rear:
          controller.rearImage = image.path;
          break;
        case ImageType.left:
          controller.leftImage = image.path;
          break;
        case ImageType.right:
          controller.rightImage = image.path;
          break;
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CompleteProfileController>(builder: (context, data, child) {
      if (data.vehicleInfoLoading) {
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
                  children: [
                    SizedBox(
                      height: getVerticalSize(10),
                    ),
                    myText(
                      "Please provide the following details about your vehicle:",
                      fontSize: 16,
                    ),
                    SizedBox(
                      height: getVerticalSize(20),
                    ),
                    normalTextBox(
                      focusNode: controller.vehicleRegisterFocusNode,
                      controller: controller.vehicleRegisterController,
                      hintText: "Registration No.",
                    ),
                    SizedBox(
                      height: getVerticalSize(10),
                    ),
                    normalTextBox(
                      focusNode: controller.vehicleMakeFocusNode,
                      controller: controller.vehicleMakeController,
                      hintText: "Make",
                    ),
                    SizedBox(
                      height: getVerticalSize(10),
                    ),
                    normalTextBox(
                      focusNode: controller.vehicleModelFocusNode,
                      controller: controller.vehicleModelController,
                      hintText: "Model",
                    ),
                    SizedBox(
                      height: getVerticalSize(10),
                    ),
                    normalTextBox(
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      focusNode: controller.vehicleYearFocusNode,
                      controller: controller.vehicleYearController,
                      hintText: "Year",
                    ),
                    SizedBox(
                      height: getVerticalSize(10),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: boxMaker(
                            image: controller.frontImage,
                            title: "Front Picture",
                            onTap: () {
                              showsourcepicker(ImageType.front);
                            },
                          ),
                        ),
                        SizedBox(
                          width: getHorizontalSize(10),
                        ),
                        Expanded(
                          child: boxMaker(
                            image: controller.rearImage,
                            title: "Rear Picture",
                            onTap: () {
                              showsourcepicker(ImageType.rear);
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: getVerticalSize(10),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: boxMaker(
                            image: controller.leftImage,
                            title: "Left Picture",
                            onTap: () {
                              showsourcepicker(ImageType.left);
                            },
                          ),
                        ),
                        SizedBox(
                          width: getHorizontalSize(10),
                        ),
                        Expanded(
                          child: boxMaker(
                            image: controller.rightImage,
                            title: "Right Picture",
                            onTap: () {
                              showsourcepicker(ImageType.right);
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

Widget boxMaker({
  required String title,
  String? image,
  required Function() onTap,
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (title.isNotEmpty)
        myText(
          title,
          fontSize: 14,
          color: AppColors.darkGrey,
        ),
      SizedBox(
        height: getVerticalSize(5),
      ),
      tapper(
        onPressed: onTap,
        child: Container(
          height: getVerticalSize(100),
          decoration: DottedDecoration(
            shape: Shape.box,
            color: AppColors.darkGrey,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(2),
          child: ClipRRect(
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(12),
            child: image == null
                ? Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.add_circle_outline,
                        color: AppColors.darkGrey,
                      ),
                      SizedBox(
                        height: getVerticalSize(5),
                      ),
                      myText(
                        "Add Image",
                        color: AppColors.darkGrey,
                        fontSize: 14,
                      ),
                    ],
                  ))
                : Center(
                    child: image.startsWith('http')
                        ? CachedNetworkImage(
                            imageUrl: image,
                            placeholder: (context, url) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          )
                        : Image.file(
                            File(image),
                            fit: BoxFit.cover,
                          ),
                  ),
          ),
        ),
      ),
    ],
  );
}
