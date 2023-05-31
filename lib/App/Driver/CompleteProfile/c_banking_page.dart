import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Common/common_widgets.dart';
import '../../Constants/colors.dart';
import '../../Constants/constant_heplers.dart';
import '../../Controllers/complete_profile_controller.dart';

class CBankingPage extends StatefulWidget {
  const CBankingPage({Key? key}) : super(key: key);

  @override
  State<CBankingPage> createState() => _CBankingPageState();
}

class _CBankingPageState extends State<CBankingPage> {
  late CompleteProfileController controller;

  @override
  void initState() {
    super.initState();
    controller = Provider.of<CompleteProfileController>(context, listen: false);
    controller.getBankingDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CompleteProfileController>(builder: (context, data, child) {
      if (data.bankinginfoloading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Consumer<CompleteProfileController>(
                  builder: (context, data, child) {
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: getHorizontalSize(20),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: getVerticalSize(20),
                      ),
                      myText(
                        "Please provide your bank details so we can ensure timely and secure payment of your earnings as a car courier.",
                        fontSize: 16,
                      ),
                      SizedBox(
                        height: getVerticalSize(20),
                      ),
                      normalTextBox(
                        focusNode: controller.sortCodeFocusNode,
                        controller: controller.sortCodeController,
                        hintText: "Sort Code",
                        capitalization: TextCapitalization.characters,
                      ),
                      SizedBox(
                        height: getVerticalSize(10),
                      ),
                      normalTextBox(
                        focusNode: controller.accountNumberFocusNode,
                        controller: controller.accountNumberController,
                        hintText: "Account Number",
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(
                        height: getVerticalSize(10),
                      ),
                      normalTextBox(
                        focusNode: controller.bankNameFocusNode,
                        controller: controller.bankNameController,
                        hintText: "Bank Name",
                        capitalization: TextCapitalization.words,
                        keyboardType: TextInputType.name,
                      ),
                      SizedBox(
                        height: getVerticalSize(10),
                      ),
                      normalTextBox(
                        focusNode: controller.accountNameFocusNode,
                        controller: controller.accountNameController,
                        hintText: "Name as Appears",
                        capitalization: TextCapitalization.words,
                        keyboardType: TextInputType.name,
                      ),
                      SizedBox(
                        height: getVerticalSize(10),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            value: controller.workInUK,
                            onChanged: (value) {
                              controller.workInUK = value!;
                              controller.update();
                            },
                          ),
                          Expanded(
                            child: myText(
                              "I confirm i have the right to work in the UK",
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: getVerticalSize(10),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            value: controller.happyToCheck,
                            onChanged: (value) {
                              controller.happyToCheck = value!;
                              controller.update();
                            },
                          ),
                          Expanded(
                            child: myText(
                              "I am happy for the car courier to perform background checks.",
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: getVerticalSize(10),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            value: controller.detailsCorrect,
                            onChanged: (value) {
                              controller.detailsCorrect = value!;
                              controller.update();
                            },
                          ),
                          Expanded(
                            child: myText(
                              "I hereby confirm that all the details i have entered are correct.",
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: getVerticalSize(10),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            value: controller.termsAndConditions,
                            onChanged: (value) {
                              controller.termsAndConditions = value!;
                              controller.update();
                            },
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: "I am agree to the ",
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: getFontSize(18),
                                  fontWeight: FontWeight.w300,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Terms & Conditions",
                                    style: TextStyle(
                                      color: AppColors.black,
                                      fontSize: getFontSize(18),
                                      fontWeight: FontWeight.w300,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        log("Terms & Conditions");
                                      },
                                  ),
                                  TextSpan(
                                    text: " & ",
                                    style: TextStyle(
                                      color: AppColors.black,
                                      fontSize: getFontSize(18),
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Privacy Policy",
                                    style: TextStyle(
                                      fontSize: getFontSize(18),
                                      fontWeight: FontWeight.w300,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        log("Terms & Conditions");
                                      },
                                  ),
                                  TextSpan(
                                    text: " of thecourier app. ",
                                    style: TextStyle(
                                      color: AppColors.black,
                                      fontSize: getFontSize(18),
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
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
                      "SUBMIT FOR REVIEW",
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
