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

class CPastJobsPage extends StatefulWidget {
  const CPastJobsPage({super.key});

  @override
  State<CPastJobsPage> createState() => _CPastJobsPageState();
}

class _CPastJobsPageState extends State<CPastJobsPage> {
  List<Job> jobs = [];
  int page = 1;
  int lastPage = 1;
  bool isLoading = true;
  final refreshController = RefreshController(initialRefresh: false);

  getJobs({
    required bool isRefresh,
  }) async {
    if (isRefresh && mounted && jobs.isEmpty) {
      setState(() {
        isLoading = true;
      });
    }
    try {
      final model = await Apis.getJobsApi(
        page: page,
        status: "past",
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
      enablePullUp: true,
      controller: refreshController,
      onRefresh: () {
        page = 1;
        getJobs(isRefresh: true);
      },
      onLoading: loadMore,
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
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
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
            onPressed: () {},
            child: Row(
              children: [
                myText(
                  "Assigned Driver",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                const Spacer(),
                myText(
                  "Monty",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
