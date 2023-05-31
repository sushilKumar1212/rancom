
import 'dart:async';

import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:thecourierapp/App/Common/common_widgets.dart';
import 'package:thecourierapp/App/Constants/colors.dart';
import 'package:thecourierapp/App/Controllers/forgot_password_controller.dart';

import '../../Constants/constant_heplers.dart';

class ForgotOtpVerificationPage extends StatefulWidget {
  const ForgotOtpVerificationPage({Key? key}) : super(key: key);

  @override
  State<ForgotOtpVerificationPage> createState() =>
      _ForgotOtpVerificationPageState();
}

class _ForgotOtpVerificationPageState extends State<ForgotOtpVerificationPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 15), () {
      bottomsheet();
    });
    startTimer();
  }

  Timer? timer;
  int start = 60;

  startTimer() async {
    if (timer != null) {
      timer!.cancel();
    }
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (start == 0) {
          timer.cancel();
        } else {
          if (mounted) {
            setState(() {
              start--;
            });
          } else {
            timer.cancel();
          }
        }
      },
    );
  }

  bottomsheet() {
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
                        'PASSWORD RESET Request sent successfully'
                            .toUpperCase(),
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
                        'We have sent a 6 Digit\ncode on your email.',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reset Password'.toUpperCase(),
          style: TextStyle(
            fontSize: getFontSize(16),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<ForgotPasswordController>(
          builder: (context, controller, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: getVerticalSize(20),
              ),
              myText(
                "Please enter the code sent to your",
                fontSize: 16,
              ),
              myText(
                controller.emailContorller.text,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(
                height: getVerticalSize(20),
              ),
              Pinput(
                length: 6,
                controller: controller.otpController,
                onChanged: (value) {
                  if (value.length == 6) {
                    // controller.verifyOtp();
                  }
                },
              ),
              SizedBox(
                height: getVerticalSize(20),
              ),
              tapper(
                onPressed: () {
                  if (controller.otpController.text.length == 6) {
                    controller.verifyOtp();
                  } else {
                    Fluttertoast.cancel();
                    Fluttertoast.showToast(msg: "Please enter valid otp");
                  }
                },
                child: Container(
                  width: Get.width,
                  height: getVerticalSize(50),
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: myText(
                      "Verify oTP".toUpperCase(),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  tapper(
                    onPressed: () async {
                      if (start == 0) {
                        final data = await controller.resendOtp();
                        if (data) {
                          setState(() {
                            start = 60;
                          });
                          startTimer();
                        }
                      } else {
                        Fluttertoast.showToast(
                          msg: "Please wait for $start seconds",
                        );
                      }
                    },
                    child: myText(
                      "Resend Code",
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  const Spacer(),
                  tapper(
                    onPressed: () {
                      Get.back();
                    },
                    child: myText(
                      start < 10 ? "00:0$start" : "00:$start",
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
