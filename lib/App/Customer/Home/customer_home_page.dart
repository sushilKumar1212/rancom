import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:thecourierapp/App/Controllers/Customer/customer_profile_controller.dart';
import 'package:thecourierapp/App/Core/apis.dart';
import 'package:thecourierapp/App/Customer/MyJobs/my_job_page.dart';
import 'package:thecourierapp/App/Customer/PickDriver/pick_a_driver_page.dart';
import 'package:thecourierapp/App/Models/job_model.dart';
import 'package:thecourierapp/App/Utils/app_page_routes.dart';

import '../../Common/common_widgets.dart';
import '../../Constants/colors.dart';
import '../../Constants/constant_heplers.dart';

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({Key? key}) : super(key: key);

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String appversion = '1.0.0';
  String _selectedFilter = 'date';
  bool isLoading = false;
  int page = 1;
  int lastPage = 1;

  List<Job> jobs = [];

  getJobs({
    required bool isRefresh,
  }) async {
    if (isRefresh) {
      setState(() {
        isLoading = true;
      });
    }
    try {
      log("page: $page");
      final model = await Apis.getJobsApi(
        page: page,
        status: "pending",
      );
      if (isRefresh) {
        jobs.clear();
      }
      if (model.success) {
        jobs.addAll(model.jobs);
        lastPage = model.pages;
      }
      filterJobs();
      if (isRefresh) {
        refreshController.refreshCompleted();
        refreshController.loadComplete();
      } else {
        if (page < lastPage) {
          refreshController.loadComplete();
        } else {
          refreshController.loadNoData();
        }
      }
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } on Exception {
      refreshController.refreshCompleted();
    }
  }

  loadMore() async {
    if (page < lastPage) {
      setState(() {
        page++;
      });
      getJobs(isRefresh: false);
    } else {
      refreshController.loadNoData();
    }
  }

  filterJobs() {
    if (_selectedFilter == 'price') {
      jobs.sort((a, b) => a.packageInfo.pricePerMileParcel
          .compareTo(b.packageInfo.pricePerMileParcel));
    } else if (_selectedFilter == 'date') {
      jobs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getJobs(isRefresh: true);
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        appversion = packageInfo.version;
      });
    });
  }

  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomerDrawer(
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
        title: Text(
          'For Customer',
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
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: () async {
          page = 1;
          getJobs(isRefresh: true);
        },
        onLoading: () {
          loadMore();
        },
        controller: refreshController,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: getVerticalSize(20),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: tapper(
                            onPressed: () {
                              Get.to(() => const PickADriverPage());
                            },
                            child: Container(
                              height: getVerticalSize(50),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/icons/driver.svg',
                                    width: getSize(30),
                                    height: getSize(24),
                                  ),
                                  SizedBox(
                                    width: getVerticalSize(10),
                                  ),
                                  myText(
                                    'Pick a Driver',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: getVerticalSize(15),
                        ),
                        Expanded(
                          child: tapper(
                            onPressed: () {
                              Get.toNamed(AppRoute.customerPostJob);
                            },
                            child: Container(
                              height: getVerticalSize(50),
                              decoration: BoxDecoration(
                                color: AppColors.black,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ImageIcon(
                                    const AssetImage(
                                        'assets/images/vehicle.png'),
                                    color: AppColors.white,
                                    size: getSize(33),
                                  ),
                                  SizedBox(
                                    width: getVerticalSize(10),
                                  ),
                                  myText(
                                    'Post a Job',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: getVerticalSize(10),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        myText(
                          'Recent Jobs',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        DropdownButton<String>(
                          value: _selectedFilter,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedFilter = newValue!;
                            });
                            filterJobs();
                          },
                          underline: Container(),
                          style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 14,
                          ),
                          items: [
                            DropdownMenuItem<String>(
                              value: 'price',
                              child: myText(
                                'Filter by Price',
                                fontSize: 14,
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: 'date',
                              child: myText(
                                'Filter by Date',
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: getVerticalSize(10),
                    ),
                  ],
                ),
              ),
              if (isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                )
              else if (jobs.isEmpty)
                const Center(
                  child: Text('No Jobs Found'),
                )
              else
                ListView.separated(
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: getVerticalSize(10),
                    );
                  },
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: jobs.length,
                  itemBuilder: (context, index) {
                    return jobsrequestCard(
                      type: jobs[index].packageInfo.itemType,
                      quantity: jobs[index].packageInfo.noOfItems.toString(),
                      price:
                          jobs[index].packageInfo.pricePerMileParcel.toString(),
                      date: DateFormat('dd MMM yyyy')
                          .format(jobs[index].deliveryDate),
                      time: jobs[index].deliveryTime,
                      pickup: jobs[index].pickUp.address,
                      dropoff: jobs[index].delivery.address,
                      image: jobs[index].image,
                      index: index,
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  String getItemName(String type) {
    switch (type) {
      case '1':
        return 'Small';
      case '2':
        return 'Medium';
      case '3':
        return 'Large';
      case '4':
        return 'Letter';
      default:
        return 'Other';
    }
  }

  Widget jobsrequestCard({
    required String type,
    required String quantity,
    required String price,
    required String date,
    required String time,
    required String pickup,
    required String dropoff,
    required String image,
    required int index,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  myText(
                    "Type: ",
                    fontSize: 14,
                  ),
                  myText(
                    getItemName(type),
                    fontSize: 14,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
              SizedBox(
                width: getVerticalSize(15),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  myText(
                    "Quantity: ",
                    fontSize: 14,
                  ),
                  myText(
                    quantity,
                    fontSize: 14,
                    maxLines: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
              SizedBox(
                width: getVerticalSize(15),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  myText(
                    "Price/Parcel: ",
                    fontSize: 14,
                  ),
                  myText(
                    "£$price",
                    fontSize: 14,
                    maxLines: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: getVerticalSize(15),
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.date_range,
                              size: 20,
                              color: AppColors.black,
                            ),
                            SizedBox(
                              width: getHorizontalSize(10),
                            ),
                            myText(
                              date,
                              fontSize: 14,
                              maxLines: 1,
                            ),
                          ],
                        ),
                        SizedBox(
                          width: getHorizontalSize(10),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 20,
                              color: AppColors.black,
                            ),
                            SizedBox(
                              width: getHorizontalSize(10),
                            ),
                            myText(
                              time,
                              fontSize: 14,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: getVerticalSize(10),
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: AppColors.primary,
                          child: Center(
                            child: Text(
                              "P",
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: getFontSize(10),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: getHorizontalSize(10),
                        ),
                        Expanded(
                          child: myText(
                            pickup,
                            fontSize: 14,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: getVerticalSize(10),
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: AppColors.primary,
                          child: Center(
                            child: Text(
                              "D",
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: getFontSize(10),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: getHorizontalSize(10),
                        ),
                        Expanded(
                          child: myText(
                            dropoff,
                            fontSize: 14,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: getHorizontalSize(10),
              ),
              CachedNetworkImage(
                imageUrl: image,
                height: getSize(91),
                width: getSize(91),
                fit: BoxFit.contain,
              ),
            ],
          ),
          SizedBox(
            height: getVerticalSize(10),
          ),
        ],
      ),
    );
  }
}

class CustomerDrawer extends StatelessWidget {
  final String appversion;
  CustomerDrawer({super.key, required this.appversion});

  final profileController = Get.put(CustomerProfileController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: Get.width * 0.65,
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
            SizedBox(
              height: getVerticalSize(10),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: myText(
                "Customer's Name",
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              title: Text(
                'My Jobs',
                style: TextStyle(
                  fontSize: getFontSize(16),
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: Image.asset(
                'assets/images/vehicle.png',
                width: getSize(25),
                height: getSize(19),
              ),
              onTap: () {
                Get.back();
                Get.to(() => const MyJobsPage());
              },
            ),
            ListTile(
              title: Text(
                'Logout',
                style: TextStyle(
                  fontSize: getFontSize(16),
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: Icon(
                Icons.logout,
                size: getSize(25),
                color: AppColors.black,
              ),
              onTap: () {
                Get.back();
                profileController.logout();
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 20),
              child: Text(
                'Version $appversion',
                style: TextStyle(
                  fontSize: getFontSize(12),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
