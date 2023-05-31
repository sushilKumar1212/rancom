import 'dart:io';

import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:images_picker/images_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:thecourierapp/App/Controllers/Customer/JobPost/package_controller.dart';

import '../../Common/common_widgets.dart';
import '../../Constants/colors.dart';
import '../../Constants/constant_heplers.dart';

class PackagePage extends StatefulWidget {
  const PackagePage({Key? key}) : super(key: key);

  @override
  State<PackagePage> createState() => _PackagePageState();
}

class _PackagePageState extends State<PackagePage> {
  showsourcepicker() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: AppColors.transparent,
      builder: (BuildContext bc) {
        return Container(
          height: getVerticalSize(225),
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
                  Get.back();
                  selectFromCamera();
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
                  Get.back();
                  selectFromGallery();
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

  selectFromGallery() async {
    final images = await ImagesPicker.pick(
      count: 1,
      quality: 0.2,
    );
    if (images != null) {
      final path = images[0].path;
      final controller = Provider.of<PackageController>(context, listen: false);
      controller.setImage(path);
    }
  }

  selectFromCamera() async {
    final images = await ImagesPicker.openCamera(
      quality: 0.2,
    );
    if (images != null) {
      final path = images.first.path;
      final controller = Provider.of<PackageController>(context, listen: false);
      controller.setImage(path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PackageController>(builder: (context, controller, child) {
      return Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: getHorizontalSize(15)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: getVerticalSize(20)),
              myText(
                "Package Info",
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              SizedBox(height: getVerticalSize(10)),
              const Divider(
                color: AppColors.grey,
                thickness: 1,
              ),
              SizedBox(height: getVerticalSize(10)),
              Row(
                children: [
                  ImageIcon(
                    const AssetImage("assets/images/list.png"),
                    color: AppColors.black,
                    size: getSize(20),
                  ),
                  SizedBox(width: getHorizontalSize(10)),
                  myText(
                    "Choose Job Type",
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ],
              ),
              SizedBox(height: getVerticalSize(10)),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.darkGrey,
                  ),
                ),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: getHorizontalSize(10),
                      vertical: getVerticalSize(10),
                    ),
                    hintText: "Choose Job Type",
                  ),
                  value: controller.jobTypeController,
                  isExpanded: true,
                  items: [
                    DropdownMenuItem(
                      value: '1',
                      child: myText(
                        "Single Package",
                      ),
                    ),
                    DropdownMenuItem(
                      value: "2",
                      child: myText(
                        "Multiple Package",
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    controller.setJobType(value!);
                  },
                ),
              ),
              SizedBox(height: getVerticalSize(10)),
              Row(
                children: [
                  ImageIcon(
                    const AssetImage("assets/images/list.png"),
                    color: AppColors.black,
                    size: getSize(20),
                  ),
                  SizedBox(width: getHorizontalSize(10)),
                  myText(
                    "Choose Delivery Time & Date",
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ],
              ),
              SizedBox(height: getVerticalSize(10)),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.darkGrey,
                  ),
                ),
                child: TextField(
                  readOnly: true,
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2025),
                    ).then((value) {
                      if (value != null) {
                        final date = DateFormat("yyyy-MM-dd").format(value);
                        controller.dateController.text = date;
                      }
                    });
                  },
                  controller: controller.dateController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: getHorizontalSize(10),
                      vertical: getVerticalSize(10),
                    ),
                    hintText: "Select Date & Time",
                  ),
                ),
              ),
              SizedBox(height: getVerticalSize(10)),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.grey,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.darkGrey,
                        ),
                      ),
                      child: TextField(
                        controller: controller.hourController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          //Format for hours
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2),
                        ],
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            if (int.parse(value) > 12) {
                              controller.hourController.text = "12";
                              controller.hourController.selection =
                                  TextSelection.fromPosition(
                                TextPosition(
                                  offset: controller.hourController.text.length,
                                ),
                              );
                            }
                          }
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: getHorizontalSize(10),
                            vertical: getVerticalSize(10),
                          ),
                          hintText: "00",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: getHorizontalSize(10)),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.grey,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.darkGrey,
                        ),
                      ),
                      child: TextField(
                        controller: controller.minuteController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          //Format for minutes
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2),
                        ],
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            if (int.parse(value) > 59) {
                              controller.minuteController.text = "59";
                              controller.minuteController.selection =
                                  TextSelection.fromPosition(
                                TextPosition(
                                  offset:
                                      controller.minuteController.text.length,
                                ),
                              );
                            }
                          }
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: getHorizontalSize(10),
                            vertical: getVerticalSize(10),
                          ),
                          hintText: "00",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: getHorizontalSize(10)),
                  Container(
                    width: getHorizontalSize(80),
                    decoration: BoxDecoration(
                      color: AppColors.grey,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.darkGrey,
                      ),
                    ),
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: getHorizontalSize(10),
                          vertical: getVerticalSize(10),
                        ),
                        hintText: "AM",
                      ),
                      value: controller.periodController,
                      isExpanded: true,
                      items: [
                        DropdownMenuItem(
                          value: "AM",
                          child: myText(
                            "AM",
                          ),
                        ),
                        DropdownMenuItem(
                          value: "PM",
                          child: myText(
                            "PM",
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        controller.periodController = value!.toString();
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: getVerticalSize(10)),
              const Divider(
                color: AppColors.darkGrey,
              ),
              SizedBox(height: getVerticalSize(10)),
              Row(
                children: [
                  ImageIcon(
                    const AssetImage("assets/images/list.png"),
                    color: AppColors.black,
                    size: getSize(20),
                  ),
                  SizedBox(width: getHorizontalSize(10)),
                  myText(
                    "Preferred Vehicle Choice",
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ],
              ),
              SizedBox(height: getVerticalSize(10)),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.darkGrey,
                  ),
                ),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: getHorizontalSize(10),
                      vertical: getVerticalSize(10),
                    ),
                    hintText: "Select a Vehicle",
                  ),
                  value: controller.vehicleTypeController,
                  isExpanded: true,
                  items: vehiclesType.map((e) {
                    return DropdownMenuItem(
                      value: e['id'],
                      child: myText(
                        e['title'],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    controller.setVehicleType(value.toString());
                  },
                ),
              ),
              SizedBox(height: getVerticalSize(10)),
              const Divider(
                color: AppColors.darkGrey,
              ),
              SizedBox(height: getVerticalSize(10)),
              Row(
                children: [
                  ImageIcon(
                    const AssetImage("assets/images/list.png"),
                    color: AppColors.black,
                    size: getSize(20),
                  ),
                  SizedBox(width: getHorizontalSize(10)),
                  myText(
                    "Add Package Info",
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ],
              ),
              SizedBox(height: getVerticalSize(10)),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.darkGrey,
                  ),
                ),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: getHorizontalSize(10),
                      vertical: getVerticalSize(10),
                    ),
                    hintText: "Select item Type",
                  ),
                  isExpanded: true,
                  value: controller.packageTypeController,
                  items: [
                    DropdownMenuItem(
                      value: "1",
                      child: myText(
                        "Small",
                      ),
                    ),
                    DropdownMenuItem(
                      value: "2",
                      child: myText(
                        "Medium",
                      ),
                    ),
                    DropdownMenuItem(
                      value: "3",
                      child: myText(
                        "Large",
                      ),
                    ),
                    DropdownMenuItem(
                      value: "4",
                      child: myText(
                        "Letter",
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    controller.setPackageType(value!);
                  },
                ),
              ),
              SizedBox(height: getVerticalSize(10)),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.darkGrey,
                  ),
                ),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: controller.packagequantityController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: getHorizontalSize(10),
                      vertical: getVerticalSize(10),
                    ),
                    hintText: "How Many Items?",
                  ),
                ),
              ),
              SizedBox(height: getVerticalSize(10)),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.darkGrey,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: getHorizontalSize(10),
                            vertical: getVerticalSize(10),
                          ),
                          hintText: "Price Per Mile",
                        ),
                      ),
                    ),
                    SizedBox(width: getHorizontalSize(10)),
                    Checkbox(
                      value: controller.pricepermileorparcel == "mile",
                      onChanged: (value) {
                        controller.setPricePerMileOrParcel('mile');
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: getVerticalSize(10)),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.darkGrey,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: getHorizontalSize(10),
                            vertical: getVerticalSize(10),
                          ),
                          hintText: "Price Per Delivered Parcel",
                        ),
                      ),
                    ),
                    SizedBox(width: getHorizontalSize(10)),
                    Checkbox(
                      value: controller.pricepermileorparcel == "parcel",
                      onChanged: (value) {
                        controller.setPricePerMileOrParcel('parcel');
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: getVerticalSize(10)),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.darkGrey,
                  ),
                ),
                child: TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: controller.priceController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}'),
                    ),
                  ],
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.currency_pound_sharp,
                      size: getSize(15),
                      color: AppColors.black,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: getHorizontalSize(10),
                      vertical: getVerticalSize(11),
                    ),
                    hintText: "Enter Price Per mile/parcel (0.00)",
                  ),
                ),
              ),
              SizedBox(height: getVerticalSize(10)),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.darkGrey,
                  ),
                ),
                child: TextField(
                  controller: controller.noteController,
                  maxLines: 4,
                  maxLength: 200,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: getHorizontalSize(10),
                      vertical: getVerticalSize(10),
                    ),
                    hintText: "Notes",
                  ),
                ),
              ),
              SizedBox(height: getVerticalSize(10)),
              Container(
                decoration: DottedDecoration(
                  shape: Shape.box,
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.darkGrey,
                ),
                height: getVerticalSize(126),
                width: double.infinity,
                child: tapper(
                  onPressed: () {
                    showsourcepicker();
                  },
                  child: controller.packageImage.isNotEmpty
                      ? Image.file(
                          File(controller.packageImage),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.add_circle_outline,
                              color: AppColors.darkGrey,
                              size: 30,
                            ),
                            SizedBox(height: getVerticalSize(5)),
                            myText(
                              "Add Image",
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.darkGrey,
                            ),
                          ],
                        ),
                ),
              ),
              SizedBox(height: getVerticalSize(10)),
              tapper(
                onPressed: () {
                  controller.nextPage(context);
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
                      "Next",
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.black,
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
}
