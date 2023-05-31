import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:thecourierapp/App/Common/common_widgets.dart';
import 'package:thecourierapp/App/Constants/constant_heplers.dart';
import 'package:thecourierapp/App/Controllers/complete_profile_controller.dart';

import '../../Constants/colors.dart';

class CpersonalPage extends StatefulWidget {
  const CpersonalPage({Key? key}) : super(key: key);

  @override
  State<CpersonalPage> createState() => _CpersonalPageState();
}

class _CpersonalPageState extends State<CpersonalPage> {
  late CompleteProfileController controller;

  @override
  void initState() {
    super.initState();
    controller = Provider.of<CompleteProfileController>(context, listen: false);
    controller.getPersonalDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CompleteProfileController>(
        builder: (context, data, child) {
          if (data.personalInfoLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: getHorizontalSize(20),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: getVerticalSize(20),
                      ),
                      myText(
                        "Please enter your address so we can match you with the best delivery jobs in your area.",
                        fontSize: 16,
                      ),
                      SizedBox(
                        height: getVerticalSize(20),
                      ),
                      normalTextBox(
                        focusNode: controller.nameFocusNode,
                        controller: controller.nameController,
                        hintText: "Name",
                        capitalization: TextCapitalization.words,
                        keyboardType: TextInputType.name,
                        enabled:
                            data.personalInfoModel!.driver.firstName.isEmpty,
                      ),
                      SizedBox(
                        height: getVerticalSize(10),
                      ),
                      normalTextBox(
                        controller: controller.emailController,
                        hintText: "Email",
                        keyboardType: TextInputType.emailAddress,
                        endText: data.personalInfoModel!.driver.isEmailVerified
                            ? "Verified"
                            : "Verify",
                        enabled:
                            !data.personalInfoModel!.driver.isEmailVerified,
                      ),
                      SizedBox(
                        height: getVerticalSize(10),
                      ),
                      normalTextBox(
                        maxLength: 11,
                        focusNode: controller.phoneFocusNode,
                        controller: controller.phoneController,
                        hintText: "Phone Number",
                        keyboardType: TextInputType.phone,
                        enabled: false,
                        onTap: () {
                          if (data.personalInfoModel!.driver
                              .isPhoneNumberVerified) {
                            return;
                          }
                          controller.updatePhoneNumber();
                        },
                      ),
                      SizedBox(
                        height: getVerticalSize(10),
                      ),
                      normalTextBox(
                        focusNode: controller.addressFocusNode,
                        controller: controller.addressController,
                        hintText: "House No. /Street",
                        keyboardType: TextInputType.streetAddress,
                      ),
                      SizedBox(
                        height: getVerticalSize(10),
                      ),
                      normalTextBox(
                        focusNode: controller.postcodeFocusNode,
                        controller: controller.postcodeController,
                        hintText: "PostCode",
                        capitalization: TextCapitalization.characters,
                        endWidget: tapper(
                          onPressed: () async {
                            log(controller.postcodeController.text);
                            showLoading();
                            final response = await get(Uri.parse(
                                'https://api.postcodes.io/postcodes/${controller.postcodeController.text.removeAllWhitespace}'));
                            hideLoading();
                            log(response.body);
                            if (response.statusCode == 200 ||
                                response.statusCode == 201) {
                              final jsondata = jsonDecode(response.body);
                              if (jsondata['result'] != null) {
                                controller.cityController.text =
                                    jsondata['result']
                                        ['parliamentary_constituency'];
                                controller.address2Controller.text =
                                    jsondata['result']['admin_district'];
                              }
                            }
                          },
                          child: const Text("Detect"),
                        ),
                      ),
                      SizedBox(
                        height: getVerticalSize(10),
                      ),
                      normalTextBox(
                        focusNode: controller.cityFocusNode,
                        controller: controller.cityController,
                        hintText: "City",
                        keyboardType: TextInputType.streetAddress,
                        capitalization: TextCapitalization.sentences,
                      ),
                      SizedBox(
                        height: getVerticalSize(10),
                      ),
                      normalTextBox(
                        focusNode: controller.address2FocusNode,
                        controller: controller.address2Controller,
                        hintText: "Area/Locality",
                        keyboardType: TextInputType.streetAddress,
                        capitalization: TextCapitalization.words,
                      ),
                      SizedBox(
                        height: getVerticalSize(10),
                      ),
                      normalTextBox(
                        focusNode: controller.dobFocusNode,
                        controller: controller.dobController,
                        hintText: "Date of Birth",
                        keyboardType: TextInputType.datetime,
                        fullTap: () {
                          controller.selectDate(context);
                        },
                        readOnly: true,
                      ),
                      SizedBox(
                        height: getVerticalSize(10),
                      ),
                      normalTextBox(
                        focusNode: controller.ninFocusNode,
                        controller: controller.ninController,
                        hintText: "National Insurance Number",
                      ),
                    ],
                  ),
                ),
              ),
              if (!data.personalInfoModel!.driver.isAllProfileCompleted ||
                  data.personalInfoModel!.driver.verifyByAdmin)
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
          );
        },
      ),
    );
  }
}
