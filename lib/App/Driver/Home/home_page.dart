import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:thecourierapp/App/Common/common_widgets.dart';
import 'package:thecourierapp/App/Constants/colors.dart';
import 'package:thecourierapp/App/Constants/constant_heplers.dart';
import 'package:thecourierapp/App/Controllers/complete_profile_controller.dart';
import 'package:thecourierapp/App/Controllers/home_controller.dart';
import 'package:thecourierapp/App/Controllers/profile_controller.dart';
import 'package:thecourierapp/App/Driver/CompleteProfile/profile_complete_module.dart';
import 'package:thecourierapp/App/Driver/Supports/faqs_page.dart';
import 'package:thecourierapp/App/Driver/Supports/how_to_videos.dart';
import 'package:thecourierapp/App/Utils/app_page_routes.dart';

import '../../Models/personal_info_model.dart';
import '../Jobs/jobs_pages.dart';
import 'HomeWidgets/complete_profile_widget.dart';
import 'HomeWidgets/new_jobs_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late CompleteProfileController controller;
  String appversion = '1.0.0';
  @override
  void initState() {
    super.initState();
    controller = Provider.of<CompleteProfileController>(context, listen: false);
    Provider.of<CompleteProfileController>(context, listen: false)
        .getPersonalDetails();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        appversion = packageInfo.version;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerWidget(
        appversion: appversion,
      ),
      appBar: AppBar(
        leading: Center(
          child: tapper(
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            },
            child: SvgPicture.asset(
              'assets/images/icons/menu.svg',
              width: getSize(22),
              height: getSize(16),
            ),
          ),
        ),
        actions: [
          tapper(
            onPressed: () {
              Get.toNamed(AppRoute.notification);
            },
            child: Icon(
              Ionicons.ios_notifications_outline,
              size: getSize(24),
              color: AppColors.black,
            ),
          ),
        ],
        title: Text(
          'For Driver',
          style: TextStyle(
            fontSize: getFontSize(16),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 10,
        shadowColor: AppColors.white.withOpacity(0.25),
      ),
      backgroundColor: AppColors.grey,
      floatingActionButton: Consumer<HomeController>(
        builder: (context, controller, child) => tapper(
          onPressed: () {
            final homeController =
                Provider.of<HomeController>(context, listen: false);
            homeController.switchDuty();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: getHorizontalSize(158),
            height: getVerticalSize(50),
            decoration: BoxDecoration(
              color: controller.isonDuty ? AppColors.black : AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/icons/driver.svg',
                  width: getSize(16),
                  height: getSize(20),
                  color:
                      controller.isonDuty ? AppColors.white : AppColors.black,
                ),
                SizedBox(
                  width: getHorizontalSize(10),
                ),
                Text(
                  controller.isonDuty ? "Stop Duty" : "Start Duty",
                  style: TextStyle(
                    fontSize: getFontSize(16),
                    fontWeight: FontWeight.w700,
                    color:
                        controller.isonDuty ? AppColors.white : AppColors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Consumer<HomeController>(
        builder: (BuildContext context, controller, Widget? child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CompleteProfileWidget(),
                SizedBox(
                  height: getVerticalSize(5),
                ),
                Text(
                  "Dashboard",
                  style: TextStyle(
                    fontSize: getFontSize(20),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // SizedBox(
                //   height: getVerticalSize(10),
                // ),
                Text(
                  "Overview",
                  style: TextStyle(
                    fontSize: getFontSize(16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: getVerticalSize(10),
                ),
                const NewJobsWidget(),
                SizedBox(
                  height: getVerticalSize(10),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: tapper(
                        onPressed: () {
                          Get.to(
                            () => const JobsPage(
                              index: 0,
                            ),
                          );
                        },
                        child: Container(
                          height: getVerticalSize(114),
                          width: Get.width,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              myText(
                                controller.onGoingCount.toString(),
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                              ),
                              SizedBox(
                                height: getVerticalSize(5),
                              ),
                              myText(
                                "On Going Jobs",
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: getHorizontalSize(10),
                    ),
                    Expanded(
                      child: tapper(
                        onPressed: () {
                          Get.to(
                            () => const JobsPage(
                              index: 1,
                            ),
                          );
                        },
                        child: Container(
                          height: getVerticalSize(114),
                          width: Get.width,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              myText(
                                controller.totalCount.toString(),
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                              ),
                              SizedBox(
                                height: getVerticalSize(5),
                              ),
                              myText(
                                "Total Jobs",
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: getVerticalSize(20),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class DrawerWidget extends StatelessWidget {
  final String appversion;
  const DrawerWidget({
    super.key,
    required this.appversion,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<CompleteProfileController>(
          builder: (context, controller, child) {
        if (controller.personalInfoModel == null) {
          Provider.of<CompleteProfileController>(context, listen: false)
              .getPersonalDetails();
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Container(
          width: Get.width * 0.7,
          height: Get.height,
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              tapper(
                onPressed: () {
                  Get.back();
                  Get.toNamed(AppRoute.personalprofile);
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  width: Get.width,
                  height: getVerticalSize(100),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColors.primary,
                        backgroundImage: controller
                                    .personalInfoModel!.driver.imageUrl !=
                                ''
                            ? CachedNetworkImageProvider(
                                controller.personalInfoModel!.driver.imageUrl!)
                            : null,
                        child:
                            controller.personalInfoModel!.driver.imageUrl == ''
                                ? SvgPicture.asset(
                                    'assets/images/icons/driver.svg',
                                    width: getSize(30),
                                    height: getSize(40),
                                    color: AppColors.black,
                                  )
                                : null,
                      ),
                      SizedBox(width: getHorizontalSize(10)),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            myText(
                              '${controller.personalInfoModel!.driver.firstName} ${controller.personalInfoModel!.driver.lastName}',
                              fontSize: 16,
                              maxLines: 1,
                              fontWeight: FontWeight.bold,
                            ),
                            myText(
                              controller
                                      .personalInfoModel!.driver.phoneNumber ??
                                  "",
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: AppColors.darkGrey,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                onTap: () {
                  Get.back();
                  Get.to(() => const JobsPage());
                },
                title: myText(
                  "Your Jobs",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                leading: SvgPicture.asset(
                  'assets/images/icons/box.svg',
                  width: getSize(24),
                  height: getSize(24),
                ),
                minLeadingWidth: 0,
              ),
              ListTile(
                onTap: () {
                  Get.back();
                  Get.to(() => const CompleteProfileModule(
                        page: 0,
                        showBar: false,
                      ));
                },
                title: myText(
                  "Personal",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                leading: SvgPicture.asset(
                  'assets/images/icons/profile.svg',
                  width: getSize(24),
                  height: getSize(24),
                ),
                minLeadingWidth: 0,
              ),
              ListTile(
                onTap: getpercent(controller.personalInfoModel!.driver) >= 70
                    ? () {
                        Get.back();
                        Get.to(() => const CompleteProfileModule(page: 1));
                      }
                    : null,
                title: myText(
                  "Vehicle",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: getpercent(controller.personalInfoModel!.driver) >= 70
                      ? AppColors.black
                      : AppColors.grey,
                ),
                leading: SvgPicture.asset(
                  'assets/images/icons/vehicle.svg',
                  width: getSize(24),
                  height: getSize(24),
                  color: getpercent(controller.personalInfoModel!.driver) >= 70
                      ? AppColors.black
                      : AppColors.grey,
                ),
                minLeadingWidth: 0,
              ),
              ListTile(
                onTap: getpercent(controller.personalInfoModel!.driver) >= 80
                    ? () {
                        Get.back();
                        Get.to(() => const CompleteProfileModule(page: 2));
                      }
                    : null,
                title: myText(
                  "Documents",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: getpercent(controller.personalInfoModel!.driver) >= 80
                      ? AppColors.black
                      : AppColors.grey,
                ),
                leading: SvgPicture.asset(
                  'assets/images/icons/documents.svg',
                  width: getSize(24),
                  height: getSize(24),
                  color: getpercent(controller.personalInfoModel!.driver) >= 80
                      ? AppColors.black
                      : AppColors.grey,
                ),
                minLeadingWidth: 0,
              ),
              ListTile(
                onTap: getpercent(controller.personalInfoModel!.driver) >= 90
                    ? () {
                        Get.back();
                        Get.to(() => const CompleteProfileModule(page: 3));
                      }
                    : null,
                title: myText(
                  "Banking",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: getpercent(controller.personalInfoModel!.driver) >= 90
                      ? AppColors.black
                      : AppColors.grey,
                ),
                leading: SvgPicture.asset(
                  'assets/images/icons/banking.svg',
                  width: getSize(24),
                  height: getSize(24),
                  color: getpercent(controller.personalInfoModel!.driver) >= 90
                      ? AppColors.black
                      : AppColors.grey,
                ),
                minLeadingWidth: 0,
              ),
              ListTile(
                onTap: () {
                  Get.back();
                  Get.to(() => const HowToVideosPage());
                },
                title: myText(
                  "How to Videos",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                leading: const Icon(
                  Icons.video_collection_outlined,
                  color: AppColors.black,
                ),
                minLeadingWidth: 0,
              ),
              ListTile(
                onTap: () {
                  Get.back();
                  Get.to(() => const FaqsPage());
                },
                title: myText(
                  "FAQs",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                leading: const Icon(
                  Icons.question_answer_outlined,
                  color: AppColors.black,
                ),
                minLeadingWidth: 0,
              ),
              const Spacer(),
              ListTile(
                onTap: () {
                  Get.back();
                  logout();
                },
                title: myText(
                  "Logout",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                leading: const Icon(
                  Icons.logout,
                  color: AppColors.black,
                ),
                minLeadingWidth: 0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: myText(
                  "Version $appversion",
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                ),
              ),
              SizedBox(height: getVerticalSize(20)),
            ],
          ),
        );
      }),
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
    return (count);
  }

  logout() async {
    showLoading();
    final controller =
        Provider.of<ProfileController>(Get.context!, listen: false);
    controller.logout();
  }
}
