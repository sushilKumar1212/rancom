import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:thecourierapp/App/Common/common_widgets.dart';
import 'package:thecourierapp/App/Constants/colors.dart';
import 'package:thecourierapp/App/Constants/constant_heplers.dart';
import 'package:thecourierapp/App/Controllers/Customer/JobPost/pickup_controller.dart';
import 'package:thecourierapp/App/Controllers/Customer/job_pos_controller.dart';
import 'package:thecourierapp/App/Customer/PostJob/package_page.dart';
import 'package:thecourierapp/App/Customer/PostJob/pickup_page.dart';

import '../../Controllers/Customer/JobPost/delivery_controller.dart';
import '../../Controllers/Customer/JobPost/package_controller.dart';
import 'delivery_page.dart';
import 'review_page.dart';

class PostJobModule extends StatefulWidget {
  const PostJobModule({Key? key}) : super(key: key);

  @override
  State<PostJobModule> createState() => _PostJobModuleState();
}

class _PostJobModuleState extends State<PostJobModule> {
  List<Widget> pages = [
    const PickupPage(),
    const DeliveryPage(),
    const PackagePage(),
    const ReviewPage(),
  ];

  List<String> titles = [
    "Pickup",
    "Delivery",
    "Package",
    "Review",
  ];

  late JobPostController jobPostController;

  @override
  void initState() {
    super.initState();
    jobPostController = Provider.of<JobPostController>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: myText(
          "Post a Job",
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
        elevation: 10,
        backgroundColor: AppColors.primary,
        shadowColor: AppColors.white.withOpacity(0.25),
        centerTitle: true,
      ),
      body: Consumer<JobPostController>(builder: (context, controller, child) {
        return WillPopScope(
          onWillPop: () async {
            FocusManager.instance.primaryFocus?.unfocus();
            if (controller.currentPage == 0) {
              final controller =
                  Provider.of<PickupController>(context, listen: false);
              controller.back();
              return false;
            }
            if (controller.currentPage == 1) {
              final controller =
                  Provider.of<DeliveryController>(context, listen: false);
              controller.back(context);
              return false;
            }
            if (controller.currentPage == 2) {
              final controller =
                  Provider.of<PackageController>(context, listen: false);
              controller.back(context);
              return false;
            }
            if (controller.currentPage == 3) {
              controller.setCurrentPage(2);
              return false;
            }
            return false;
          },
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.white.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                height: getVerticalSize(93),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StepProgressView(
                      curStep: controller.currentPage + 1,
                      titles: titles,
                      width: Get.width,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: IndexedStack(
                  index: controller.currentPage,
                  children: pages,
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
