import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:thecourierapp/App/Common/common_widgets.dart';
import 'package:thecourierapp/App/Constants/colors.dart';
import 'package:thecourierapp/App/Utils/app_page_routes.dart';

import '../../Constants/constant_heplers.dart';
import '../../Core/apis.dart';
import '../../Models/job_model.dart';

class JobsForInvite extends StatefulWidget {
  final String jobid;
  const JobsForInvite({Key? key, required this.jobid}) : super(key: key);

  @override
  State<JobsForInvite> createState() => _JobsForInviteState();
}

class _JobsForInviteState extends State<JobsForInvite> {
  List<Job> jobs = [];
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
    jobs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getJobs(isRefresh: true);
  }

  inviteForJob(String jobId) async {
    showLoading();
    try {
      final response = await Apis.sendJobRequest(
        jobId: jobId,
        driverId: widget.jobid,
      );
      hideLoading();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          showMessage(data['message'], color: Colors.green);
          Get.offAllNamed(AppRoute.customerhome);
        } else {
          showMessage(data['message']);
        }
      } else {
        showMessage("Something went wrong");
      }
    } on Exception {
      hideLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: myText(
          "Select a Job",
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: AppColors.primary,
        centerTitle: true,
      ),
      backgroundColor: AppColors.grey,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : jobs.isEmpty
              ? Center(
                  child: myText(
                    "No Jobs Found",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : SmartRefresher(
                  enablePullDown: true,
                  controller: refreshController,
                  onRefresh: () {
                    page = 1;
                    getJobs(isRefresh: true);
                  },
                  onLoading: loadMore,
                  enablePullUp: true,
                  child: ListView.separated(
                    padding: EdgeInsets.only(top: getVerticalSize(15)),
                    separatorBuilder: (context, index) => const Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    itemCount: jobs.length,
                    itemBuilder: (context, index) {
                      return jobsrequestCard(
                        type: jobs[index].packageInfo.itemType,
                        quantity: jobs[index].packageInfo.noOfItems.toString(),
                        price: jobs[index]
                            .packageInfo
                            .pricePerMileParcel
                            .toString(),
                        date: DateFormat('dd MMM yyyy')
                            .format(jobs[index].deliveryDate),
                        time: jobs[index].deliveryTime,
                        pickup: jobs[index].pickUp.address,
                        dropoff: jobs[index].delivery.address,
                        image: jobs[index].image,
                        jobId: jobs[index].id,
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
    required String jobId,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 15,
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
              ),
            ],
          ),
          SizedBox(
            height: getVerticalSize(10),
          ),
          tapper(
            onPressed: () {
              inviteForJob(jobId);
            },
            child: Container(
              height: getVerticalSize(45),
              width: Get.width,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: myText(
                  "INVITE",
                  fontSize: 18,
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
}
