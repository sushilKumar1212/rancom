import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:thecourierapp/App/Constants/colors.dart';
import 'package:thecourierapp/App/Controllers/complete_profile_controller.dart';
import 'package:thecourierapp/App/Controllers/on_board_controller.dart';
import 'package:thecourierapp/App/Controllers/user_controller.dart';
import 'package:thecourierapp/App/Utils/app_page_routes.dart';

import '../../Constants/constant_heplers.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final LocalAuthentication auth = LocalAuthentication();

  // authwithFaceId({
  //   required bool isDriver,
  // }) async {
  //   final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
  //   final bool canAuthenticate =
  //       canAuthenticateWithBiometrics || await auth.isDeviceSupported();
  //   if (canAuthenticate) {
  //     final List<BiometricType> availableBiometrics =
  //         await auth.getAvailableBiometrics();
  //     final bool isFaceId = availableBiometrics.contains(BiometricType.face);
  //     final bool isTouchId =
  //         availableBiometrics.contains(BiometricType.fingerprint);
  //     if (isFaceId || isTouchId) {
  //       try {
  //         final bool authenticated = await auth.authenticate(
  //           localizedReason: isFaceId
  //               ? 'Scan your face to authenticate'
  //               : 'Scan your fingerprint to authenticate',
  //           options: const AuthenticationOptions(
  //             sensitiveTransaction: false,
  //             stickyAuth: true,
  //           ),
  //         );
  //         if (authenticated) {
  //           if (isDriver) {
  //             Get.offAllNamed(AppRoute.home);
  //           } else {
  //             Get.offAllNamed(AppRoute.customerhome);
  //           }
  //         } else {
  //           Get.offAllNamed(AppPage.loginSelection);
  //         }
  //       } on Exception {
  //         Get.offAllNamed(AppPage.loginSelection);
  //       }
  //     } else {
  //       if (isDriver) {
  //         Get.offAllNamed(AppRoute.home);
  //       } else {
  //         Get.offAllNamed(AppRoute.customerhome);
  //       }
  //     }
  //   } else {
  //     if (isDriver) {
  //       Get.offAllNamed(AppRoute.home);
  //     } else {
  //       Get.offAllNamed(AppRoute.customerhome);
  //     }
  //   }
  // }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () async {
      if (!(GetStorage().read("onboard") ?? false)) {
        final controller =
            Provider.of<OnBoardController>(context, listen: false);
        controller.callOnboardApi();
        Get.offAllNamed(AppRoute.onboard);
      } else {
        if (GetStorage().hasData("user")) {
          updateLocation(isCustomer: true);
          // if (Platform.isIOS) {
          //   authwithFaceId(isDriver: false);
          // } else {
          Get.offAllNamed(AppRoute.customerhome);

          // }
          return;
        }
        final userController =
            Provider.of<UserController>(context, listen: false);
        if (userController.isLogged) {
          final controller =
              Provider.of<CompleteProfileController>(context, listen: false);
          await controller.getPersonalDetails();
          if (controller.personalInfoModel != null) {
            final data = controller.personalInfoModel!.driver;
            if (data.phoneNumber == null ||
                data.phoneNumber == "" ||
                data.noOfQuestionsAnswered == 0 ||
                data.noOfQuestionsAnswered == 1) {
              Get.offAllNamed(AppRoute.loginSelection);
            } else {
              updateLocation();
              // if (Platform.isIOS) {
              //   authwithFaceId(isDriver: true);
              // } else {
              Get.offAllNamed(AppRoute.home);
              // }
            }
          }
        } else {
          Get.offAllNamed(AppRoute.loginSelection);
        }
      }
    });
  }

  updateLocation({
    bool isCustomer = false,
  }) async {
    final controller = Provider.of<UserController>(context, listen: false);
    controller.updateLocation(
      isCustomer: isCustomer,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
      ),
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Hero(
                    tag: "logo",
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: getSize(250),
                      height: getSize(250),
                    ),
                  ),
                  SizedBox(
                    height: getVerticalSize(25),
                  ),
                  Text(
                    'Loading...',
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: getFontSize(20),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: getVerticalSize(40),
            color: AppColors.black,
            alignment: Alignment.center,
            child: Center(
              child: Text(
                'Driving Jobs For everyday people'.toString().toUpperCase(),
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: getFontSize(18),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            height: getVerticalSize(15),
          ),
        ],
      ),
    );
  }
}
