import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:thecourierapp/App/Common/common_widgets.dart';
import 'package:thecourierapp/App/Constants/colors.dart';
import 'package:thecourierapp/App/Constants/constant_heplers.dart';
import 'package:thecourierapp/App/Models/new_job_model.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../Core/apis.dart';

class NewJobRequestPage extends StatefulWidget {
  const NewJobRequestPage({Key? key}) : super(key: key);

  @override
  State<NewJobRequestPage> createState() => _NewJobRequestPageState();
}

class _NewJobRequestPageState extends State<NewJobRequestPage> {
  List<JobsRequest> jobs = [];
  bool isloading = false;

  List<bool> applied = [];

  @override
  void initState() {
    super.initState();
    getNewJobs();
  }

  getNewJobs() async {
    setState(() {
      isloading = true;
    });
    final response = await Apis.getNewjobsApi();
    setState(() {
      isloading = false;
    });
    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsondata = jsonDecode(response.body);
      if (jsondata['success']) {
        setState(() {
          jobs = newJobsModelFromJson(response.body).jobsRequests.toList();
          applied = jobs.map((e) => e.isApplied).toList();
        });
      } else {
        log(jsondata['message']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: myText(
          "New Job Requests",
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        shadowColor: AppColors.white.withOpacity(0.25),
        backgroundColor: AppColors.primary,
        elevation: 10,
      ),
      backgroundColor: AppColors.grey,
      body: isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : jobs.isEmpty
              ? Center(
                  child: myText(
                    "No New Jobs",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.only(top: 10),
                  itemCount: jobs.length,
                  separatorBuilder: (context, index) {
                    return const Divider(
                      height: 20,
                    );
                  },
                  itemBuilder: (context, index) {
                    final job = jobs[index].data.job;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: jobsrequestCard(
                        type: job.jobType,
                        date: DateFormat("dd-MM-yyyy").format(job.deliveryDate),
                        time: DateFormat("hh:mm a").format(job.deliveryDate),
                        quantity: job.packageInfo.noOfItems.toString(),
                        price: job.packageInfo.pricePerMileParcel.toString(),
                        pickup: job.pickUp.address,
                        dropoff: job.delivery.address,
                        image: job.attachment.imageUrl,
                        index: index,
                      ),
                    );
                  },
                ),
    );
  }

  applyJob(int index) async {
    showLoading();
    final response = await Apis.applyJobApi(jobs[index].data.requestId);
    hideLoading();
    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsondata = jsonDecode(response.body);
      if (jsondata['success']) {
        setState(() {
          applied[index] = true;
        });
      } else {
        log(jsondata['message']);
      }
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
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      child: Column(
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
                        type,
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
                        price,
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
                    tapper(
                      onPressed: () {
                        if (Platform.isIOS) {
                          launchUrlString(
                            'https://maps.apple.com/?daddr=${pickup.replaceAll(' ', '%20')}&dirflg=d',
                          );
                        } else {
                          launchUrlString(
                            'https://www.google.com/maps/dir/?api=1&destination=${pickup.replaceAll(' ', '%20')}',
                          );
                        }
                      },
                      child: Row(
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
                    ),
                    GestureDetector(
                      onTap: () {
                        if (Platform.isIOS) {
                          launchUrlString(
                            'https://maps.apple.com/?daddr=${dropoff.replaceAll(' ', '%20')}&dirflg=d',
                          );
                        } else {
                          launchUrlString(
                            'https://www.google.com/maps/dir/?api=1&destination=${dropoff.replaceAll(' ', '%20')}',
                          );
                        }
                      },
                      child: Row(
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
          SwipeButton.expand(
            activeTrackColor: applied[index]
                ? AppColors.primary
                : AppColors.primary.withOpacity(0.5),
            enabled: !applied[index],
            borderRadius: BorderRadius.circular(10),
            onSwipe: () {
              if (applied[index]) {
                return;
              }
              applyJob(index);
              // setState(() {
              //   applied[index] = true;
              // });
            },
            activeThumbColor: AppColors.primary,
            inactiveTrackColor: AppColors.primary,
            inactiveThumbColor: AppColors.transparent,
            thumb: applied[index]
                ? const SizedBox()
                : const Icon(
                    Icons.double_arrow,
                    color: AppColors.black,
                    size: 20,
                  ),
            child: SizedBox(
              height: getVerticalSize(50),
              width: double.infinity,
              child: Center(
                child: myText(
                  applied[index] ? "Applied" : "Apply",
                  fontSize: 16,
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
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
                        'Request Sent Successfully'.toUpperCase(),
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
                        'Please wait while user\naccept your request.',
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
}
