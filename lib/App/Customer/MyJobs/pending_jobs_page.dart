import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../Common/common_widgets.dart';
import '../../Constants/colors.dart';
import '../../Constants/constant_heplers.dart';
import '../../Core/apis.dart';
import '../../Models/job_model.dart';
import 'applications_for_jobs_page.dart';

class PendingJobs extends StatefulWidget {
  const PendingJobs({super.key});

  @override
  State<PendingJobs> createState() => _PendingJobsState();
}

class _PendingJobsState extends State<PendingJobs> {
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

  deleteJob({
    required jobId,
  }) async {
    showLoading();
    final response = await Apis.deleteJobApi(
      jobId: jobId,
    );
    hideLoading();
    if (response.statusCode == 200 || response.statusCode == 201) {
      getJobs(isRefresh: true);
      showMessage(
        jsonDecode(response.body)['message'],
      );
    } else {
      showMessage(
        jsonDecode(response.body)['message'],
      );
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
          'No Jobs Found',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      );
    }
    return SmartRefresher(
      enablePullDown: true,
      controller: refreshController,
      onRefresh: () {
        page = 1;
        getJobs(isRefresh: true);
      },
      onLoading: loadMore,
      enablePullUp: true,
      child: ListView.separated(
        separatorBuilder: (context, index) => const Divider(
          color: Colors.grey,
          thickness: 1,
        ),
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          return jobsrequestCard(
            type: jobs[index].packageInfo.itemType,
            quantity: jobs[index].packageInfo.noOfItems.toString(),
            price: jobs[index].packageInfo.pricePerMileParcel.toString(),
            date: DateFormat('dd MMM yyyy').format(jobs[index].deliveryDate),
            time: jobs[index].deliveryTime,
            pickup: jobs[index].pickUp.address,
            dropoff: jobs[index].delivery.address,
            image: jobs[index].image,
            index: index,
            applications: jobs[index].applicants,
          );
        },
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
    required List applications,
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
            height: getVerticalSize(5),
          ),
          tapper(
            onPressed: () async {
              await Get.to(
                () => ApplicantsForJob(
                  applicants: applications
                      .map((e) => e as Map<String, dynamic>)
                      .toList(),
                ),
              );
              getJobs(isRefresh: true);
            },
            child: Row(
              children: [
                myText(
                  "List of Applicants",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                const Spacer(),
                myText(
                  "(${applications.length})",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: AppColors.black,
                ),
              ],
            ),
          ),
          SizedBox(
            height: getVerticalSize(5),
          ),
          tapper(
            onPressed: () {
              showConfirmDialog(index);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                myText(
                  "Delete Job",
                  fontSize: 18,
                  color: AppColors.red,
                ),
                SizedBox(
                  width: getHorizontalSize(5),
                ),
                const ImageIcon(
                  AssetImage('assets/images/delete.png'),
                  size: 20,
                  color: AppColors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  showConfirmDialog(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Container(
          height: getSize(250),
          decoration: const BoxDecoration(
            color: AppColors.grey,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: myText(
                      "Delete Job",
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  tapper(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Icon(
                      Icons.close,
                      size: 30,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: getVerticalSize(10),
              ),
              myText(
                "Are you sure you want to delete this job?",
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: tapper(
                      onPressed: () {
                        Get.back();
                      },
                      child: Container(
                        height: getSize(50),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: myText(
                            "Cancel",
                            fontSize: 18,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: getHorizontalSize(20),
                  ),
                  Expanded(
                    child: tapper(
                      onPressed: () async {
                        Get.back();
                        await deleteJob(jobId: jobs[index].id);
                      },
                      child: Container(
                        height: getSize(50),
                        decoration: BoxDecoration(
                          color: AppColors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: myText(
                            "Delete",
                            fontSize: 18,
                            color: AppColors.white,
                          ),
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
    );
  }
}
