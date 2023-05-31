import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:thecourierapp/App/Common/common_widgets.dart';
import 'package:thecourierapp/App/Constants/colors.dart';
import 'package:thecourierapp/App/Constants/constant_heplers.dart';
import 'package:thecourierapp/App/Controllers/join_us_controller.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({Key? key}) : super(key: key);

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  late JoinUsController controller;

  @override
  void initState() {
    super.initState();
    controller = Provider.of<JoinUsController>(context, listen: false);
    startTimer();
  }

  Timer? timer;
  int start = 60;

  startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (mounted) {
          setState(
            () {
              if (start < 1) {
                timer.cancel();
              } else {
                start = start - 1;
              }
            },
          );
        } else {
          timer.cancel();
        }
      },
    );
  }

  resendOtp() async {
    final data = await controller.resendOtp();
    if (data) {
      if (mounted) {
        setState(() {
          start = 60;
        });
      }
      if (timer != null) {
        timer?.cancel();
      }
      startTimer();
    }
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: getVerticalSize(20),
              ),
              Text(
                "VERIFY Your Email *".toUpperCase(),
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: getFontSize(30),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: getVerticalSize(5),
              ),
              Text(
                "Please Enter the code we sent to your ",
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: getFontSize(18),
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                controller.emailController.text,
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: getFontSize(18),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: getVerticalSize(20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Pinput(
                    length: 6,
                    controller: controller.otpController,
                    onChanged: (value) {},
                    defaultPinTheme: PinTheme(
                      height: getVerticalSize(50),
                      width: (Get.width * 0.7) / 6,
                      textStyle: const TextStyle(
                        fontSize: 20,
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.white,
                        ),
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: getVerticalSize(20),
              ),
              tapper(
                onPressed: () {
                  if (controller.otpController.text.length < 6) {
                    Fluttertoast.cancel();
                    Fluttertoast.showToast(
                      msg: "Please enter valid OTP",
                      backgroundColor: AppColors.red,
                    );
                    return;
                  }
                  controller.verifyOtp();
                },
                child: Container(
                  width: Get.width,
                  height: getVerticalSize(50),
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Verify Email".toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: getFontSize(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: getVerticalSize(10),
              ),
              Row(
                mainAxisAlignment: start == 0
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.spaceBetween,
                children: [
                  tapper(
                    onPressed: start != 0
                        ? null
                        : () {
                            resendOtp();
                          },
                    child: Text(
                      "Resend OTP".toUpperCase(),
                      style: TextStyle(
                        color: start == 0
                            ? AppColors.black
                            : AppColors.black.withOpacity(0.2),
                        fontSize: getFontSize(16),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (start != 0)
                    Text(
                      "00:${start.toString().padLeft(2, "0")}",
                      style: const TextStyle(
                        color: AppColors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
