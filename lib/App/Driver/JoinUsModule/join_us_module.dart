import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:thecourierapp/App/Common/common_widgets.dart';
import 'package:thecourierapp/App/Constants/constant_heplers.dart';
import 'package:thecourierapp/App/Controllers/join_us_controller.dart';
import 'package:thecourierapp/App/Driver/JoinUsModule/email_password_page.dart';
import 'package:thecourierapp/App/Driver/JoinUsModule/email_verification_page.dart';
import 'package:thecourierapp/App/Driver/JoinUsModule/first_last_name_page.dart';
import 'package:thecourierapp/App/Driver/JoinUsModule/last_page.dart';
import 'package:thecourierapp/App/Driver/JoinUsModule/phone_number_fill.dart';
import 'package:thecourierapp/App/Driver/JoinUsModule/select_hustler_type.dart';
import 'package:thecourierapp/App/Driver/JoinUsModule/select_vehicle_type.dart';
import 'package:thecourierapp/App/Driver/JoinUsModule/welcome_page1.dart';

import '../../Constants/colors.dart';
import 'welcome_page2.dart';

class JoinUsModule extends StatefulWidget {
  final int? currentPage;
  final String? email;
  const JoinUsModule({Key? key, this.currentPage, this.email})
      : super(key: key);

  @override
  State<JoinUsModule> createState() => _JoinUsModuleState();
}

class _JoinUsModuleState extends State<JoinUsModule> {
  late JoinUsController controller;

  @override
  void initState() {
    super.initState();
    controller = Provider.of<JoinUsController>(context, listen: false);
    Future.delayed(const Duration(milliseconds: 100), () {
      if (widget.currentPage != null) {
        controller.currenPage = widget.currentPage!;

        controller.initialPage = widget.currentPage!;
        controller.pageController.jumpToPage(widget.currentPage!);
        if (widget.email != null) {
          controller.emailController.text = widget.email!;
          controller.resendOtp();
        }
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<JoinUsController>(
      builder: (BuildContext context, value, Widget? child) => WillPopScope(
        onWillPop: () async {
          if (widget.currentPage != null) {
            controller.currenPage = 0;
            controller.clearControllers();
            return true;
          } else {
            if (controller.currenPage == 3) {
              controller.currenPage = 0;
              controller.clearControllers();
              Get.back();
            } else if (controller.currenPage > 0) {
              controller.previousPage();
            } else {
              controller.clearControllers();
              Get.back();
            }
            return false;
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            leading: IconButton(
              onPressed: () {
                if (widget.currentPage != null) {
                  controller.currenPage = 0;
                  controller.clearControllers();
                  Get.back();
                  return;
                }
                controller.currenPage = 0;
                controller.clearControllers();
                Get.back();
              },
              icon: const Icon(
                Icons.clear,
              ),
            ),
            centerTitle: true,
            title: Text(
              'Join our squad'.toUpperCase(),
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          backgroundColor: AppColors.primary,
          body: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: controller.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    FirstLastNamePage(),
                    EmailPassWordPage(),
                    EmailVerificationPage(),
                    PhoneNumberFill(),
                    WelcomePage1(),
                    WelcomePage2(),
                    SelectHustlerType(),
                    SelectVehicleType(),
                    LastPage(),
                  ],
                ),
              ),
              value.currenPage == 2
                  ? const SizedBox()
                  : Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: getHorizontalSize(20),
                        vertical: getVerticalSize(30),
                      ),
                      child: Row(
                        children: [
                          tapper(
                            onPressed: () {
                              if (controller.currenPage == 3) {
                                controller.currenPage = 0;
                                controller.clearControllers();
                                Get.back();
                              } else if (controller.currenPage > 0) {
                                controller.previousPage();
                              } else {
                                controller.clearControllers();
                                Get.back();
                              }
                            },
                            child: Text(
                              "Prev".toUpperCase(),
                              style: const TextStyle(
                                color: AppColors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Spacer(),
                          tapper(
                            onPressed: () {
                              controller.validate();
                            },
                            child: const CircleAvatar(
                              backgroundColor: AppColors.black,
                              radius: 25,
                              child: Icon(
                                Icons.arrow_forward,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
