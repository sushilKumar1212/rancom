import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:thecourierapp/App/Common/common_widgets.dart';
import 'package:thecourierapp/App/Constants/constant_heplers.dart';
import 'package:thecourierapp/App/Controllers/home_controller.dart';
import 'package:thecourierapp/App/Utils/app_page_routes.dart';

import '../../../Constants/colors.dart';

class NewJobsWidget extends StatefulWidget {
  const NewJobsWidget({super.key});

  @override
  State<NewJobsWidget> createState() => _NewJobsWidgetState();
}

class _NewJobsWidgetState extends State<NewJobsWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (BuildContext context, controller, Widget? child) => tapper(
        onPressed: () {
          if (controller.isonDuty) {
            Get.toNamed(AppRoute.newjobrequest);
          } else {
            showMessage('You are not on duty. Please go online to accept jobs');
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: getVerticalSize(120),
          width: Get.width,
          decoration: BoxDecoration(
            color: controller.isonDuty
                ? AppColors.primary.withOpacity(0.8)
                : AppColors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              SizedBox(
                width: getHorizontalSize(10),
              ),
              SvgPicture.asset(
                'assets/images/icons/box.svg',
                width: getSize(59),
                height: getSize(59),
              ),
              const Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  myText(
                    controller.count.toString(),
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  myText(
                    'New Job Requests',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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
