import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:thecourierapp/App/Common/common_widgets.dart';
import 'package:thecourierapp/App/Constants/colors.dart';
import 'package:thecourierapp/App/Constants/constant_heplers.dart';
import 'package:thecourierapp/App/Controllers/complete_profile_controller.dart';
import 'package:thecourierapp/App/Driver/CompleteProfile/profile_complete_module.dart';

import '../../../Models/personal_info_model.dart';

class CompleteProfileWidget extends StatelessWidget {
  const CompleteProfileWidget({super.key});

  getSalutation() {
    String salutation = "Hello";
    final time = DateTime.now().hour;
    if (time < 12) {
      salutation = "Good Morning";
    } else if (time < 16) {
      salutation = "Good Afternoon";
    } else {
      salutation = "Good Evening";
    }
    return salutation;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CompleteProfileController>(
      builder: (context, controller, child) {
        if (controller.personalInfoModel == null) {
          return Container();
        }
        if (controller.personalInfoModel!.driver.verifyByAdmin) {
          return Container(
            margin: EdgeInsets.only(top: getVerticalSize(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    myText(
                      getSalutation(),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    Expanded(
                      child: myText(
                        ", ${controller.personalInfoModel!.driver.firstName} ${controller.personalInfoModel!.driver.lastName}",
                        fontSize: 20,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                myText(
                  DateFormat("EEEE, dd MMMM yyyy").format(DateTime.now()),
                  fontSize: 13,
                ),
                SizedBox(
                  height: getVerticalSize(10),
                ),
              ],
            ),
          );
        }
        if (controller.personalInfoModel!.driver.isAllProfileCompleted) {
          return Container(
            margin: EdgeInsets.only(top: getFontSize(20)),
            width: Get.width,
            height: getVerticalSize(52),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.4),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    controller.personalInfoModel!.status,
                    style: TextStyle(
                      fontSize: getFontSize(15),
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      "Profile",
                      style: TextStyle(
                        fontSize: getFontSize(12),
                        color: AppColors.black,
                      ),
                    ),
                    Text(
                      "100% Complete",
                      style: TextStyle(
                        fontSize: getFontSize(12),
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        return tapper(
          onPressed: () {
            Get.to(
              () => CompleteProfileModule(
                page: int.parse(
                            getpercent(controller.personalInfoModel!.driver)) ==
                        50
                    ? 0
                    : int.parse(getpercent(
                                controller.personalInfoModel!.driver)) ==
                            70
                        ? 1
                        : int.parse(getpercent(
                                    controller.personalInfoModel!.driver)) ==
                                80
                            ? 2
                            : 3,
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.only(top: getFontSize(20)),
            width: Get.width,
            height: getVerticalSize(52),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.4),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Please Complete your profile.",
                    style: TextStyle(
                      fontSize: getFontSize(15),
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      "Profile",
                      style: TextStyle(
                        fontSize: getFontSize(12),
                        color: AppColors.black,
                      ),
                    ),
                    Text(
                      getpercent(controller.personalInfoModel!.driver) +
                          " Complete",
                      style: TextStyle(
                        fontSize: getFontSize(12),
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  getpercent(Driver driver) {
    int count = 50;
    if (driver.isPersonalInfoCompleted) {
      count = count + 20;
    }
    if (driver.isVehicleInfoCompleted) {
      count = count + 10;
    }
    if (driver.isDocumentsInfoCompleted) {
      count = count + 10;
    }
    if (driver.isBankingDetailsCompleted) {
      count = count + 10;
    }
    return (count).toString();
  }
}
