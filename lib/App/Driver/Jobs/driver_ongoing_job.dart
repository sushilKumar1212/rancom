import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:thecourierapp/App/Driver/Jobs/complete_job_popup.dart';
import 'package:thecourierapp/App/Models/driver_jobs_model.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../Common/common_widgets.dart';
import '../../Constants/colors.dart';
import '../../Constants/constant_heplers.dart';
import '../../Core/apis.dart';

class DriverOnGoinJobPage extends StatefulWidget {
  const DriverOnGoinJobPage({Key? key}) : super(key: key);

  @override
  State<DriverOnGoinJobPage> createState() => _DriverOnGoinJobPageState();
}

class _DriverOnGoinJobPageState extends State<DriverOnGoinJobPage> {
  List<JobElement> jobs = [];
  int page = 1;
  int lastPage = 1;
  bool isLoading = true;
  final refreshController = RefreshController(initialRefresh: false);

  getJobs({
    required bool isRefresh,
  }) async {
    if (isRefresh && mounted) {
      setState(() {
        isLoading = true;
      });
    }
    try {
      final model = await Apis.getDriverJobsApi(
        page: page,
        status: "on_going",
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
        refreshController.resetNoData();
      } else {
        if (page <= lastPage) {
          refreshController.loadComplete();
        } else {
          refreshController.loadNoData();
        }
        refreshController.loadComplete();
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
    if (page == lastPage) {
      refreshController.loadNoData();
      return;
    }
    if (page < lastPage) {
      page++;
      getJobs(isRefresh: false);
    }
  }

  filterJobs() {
    jobs.sort((a, b) => b.job.createdAt.compareTo(a.job.createdAt));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getJobs(isRefresh: true);
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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (jobs.isEmpty) {
      return Center(
        child: myText(
          "No Jobs Found",
          fontSize: 18,
          color: AppColors.black,
        ),
      );
    }
    return Scaffold(
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        controller: refreshController,
        onRefresh: () {
          page = 1;
          getJobs(isRefresh: true);
        },
        onLoading: loadMore,
        child: ListView.separated(
          separatorBuilder: (context, index) => const Divider(
            color: AppColors.darkGrey,
          ),
          itemCount: jobs.length,
          itemBuilder: (context, index) {
            final job = jobs[index].job;
            return InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isDismissible: false,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) {
                    return const CompleteJobPopUp();
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: jobsrequestCard(
                  type: job.jobType,
                  quantity: job.packageInfo.noOfItems.toString(),
                  price: job.packageInfo.pricePerDeliveryParcel.toString(),
                  date: DateFormat('dd-MM-yyyy').format(job.deliveryDate),
                  time: job.deliveryTime,
                  pickup: job.pickUp.address,
                  dropoff: job.delivery.address,
                  image: job.jobImage.url,
                  index: index,
                  pickupname: job.pickUp.name,
                  dropoffname: job.delivery.name,
                  pickupphone: job.pickUp.mobile,
                  dropoffphone: job.delivery.mobile,
                  status: job.jobStatus,
                ),
              ),
            );
          },
        ),
      ),
    );
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
    required String pickupname,
    required String dropoffname,
    required String pickupphone,
    required String dropoffphone,
    required String status,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: Get.width / 3.2,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    myText(
                      "Type: ",
                      fontSize: 14,
                    ),
                    Expanded(
                      child: myText(
                        getItemName(type),
                        fontSize: 14,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: Get.width / 3.5,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    myText(
                      "Quantity: ",
                      fontSize: 14,
                    ),
                    Expanded(
                      child: myText(
                        quantity,
                        fontSize: 14,
                        maxLines: 1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    myText(
                      "Price/Parcel: ",
                      fontSize: 14,
                    ),
                    Expanded(
                      child: myText(
                        "£$price",
                        fontSize: 14,
                        maxLines: 1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
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
                        const CircleAvatar(
                          radius: 10,
                          backgroundColor: AppColors.primary,
                          child: Center(
                            child: Text(
                              "P",
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 10,
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
                        const CircleAvatar(
                          radius: 10,
                          backgroundColor: AppColors.primary,
                          child: Center(
                            child: Text(
                              "D",
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 10,
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
              ),
            ],
          ),
          SizedBox(
            height: getVerticalSize(10),
          ),
          Row(
            children: [
              Text(
                "Job Status: ",
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: getFontSize(14),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: getHorizontalSize(5),
              ),
              myText(
                'On Going',
                fontSize: 14,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const Divider(
            color: AppColors.grey,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              myText(
                'Contact Info',
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              tapper(
                onPressed: () async {
                  if (Platform.isIOS) {
                    launchUrlString(
                      'https://maps.apple.com/?daddr=${dropoff.replaceAll(' ', '%20')}&dirflg=d&saddr=${pickup.replaceAll(' ', '%20')}',
                    );
                  } else {
                    launchUrlString(
                      'https://www.google.com/maps/dir/?api=1&destination=$dropoff',
                    );
                  }
                },
                child: Container(
                  height: getVerticalSize(40),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Get Directions',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: getFontSize(12),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: getHorizontalSize(5),
                      ),
                      const Icon(
                        Entypo.direction,
                        size: 15,
                        color: AppColors.black,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: getVerticalSize(10),
          ),
          myText(
            "Pickup Contact",
            fontSize: 14,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              myText(
                pickupname,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              myText(
                pickupphone,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          SizedBox(
            height: getVerticalSize(10),
          ),
          myText(
            "Dropoff Contact",
            fontSize: 14,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              myText(
                dropoffname,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              myText(
                dropoffphone,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
