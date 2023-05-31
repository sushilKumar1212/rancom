import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:thecourierapp/App/Constants/constant_heplers.dart';
import 'package:thecourierapp/App/Core/apis.dart';

import '../../Common/common_widgets.dart';
import '../../Constants/colors.dart';

class ApplicantsForJob extends StatefulWidget {
  final List<Map<String, dynamic>> applicants;
  const ApplicantsForJob({Key? key, required this.applicants})
      : super(key: key);

  @override
  State<ApplicantsForJob> createState() => _ApplicantsForJobState();
}

class _ApplicantsForJobState extends State<ApplicantsForJob> {
  List<Map<String, dynamic>> applicants = [];

  @override
  void initState() {
    super.initState();
    applicants.addAll(widget.applicants);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: myText(
          'List of Applicants',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        elevation: 10,
        shadowColor: AppColors.white.withOpacity(0.2),
        backgroundColor: AppColors.primary,
      ),
      backgroundColor: AppColors.grey,
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        itemCount: applicants.length,
        separatorBuilder: (context, index) {
          return const Divider(
            height: 10,
            color: AppColors.darkGrey,
          );
        },
        itemBuilder: (context, index) {
          final applicant = applicants[index]['driver'];
          return applicantsCard(
            city: "['city']",
            image: "https://picsum.photos/200/500",
            name: applicant['full_name'],
            pincode: "['pincode']",
            since: "['since']",
            vehicle: vehiclesType
                .where((element) => element['id'] == applicant['vehicle_type'])
                .first['title'],
            requestId: applicants[index]['request_id'].toString(),
          );
        },
      ),
    );
  }

  Widget applicantsCard({
    required String name,
    required String vehicle,
    required String pincode,
    required String since,
    required String image,
    required String city,
    required String requestId,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: getSize(30),
                        backgroundColor: AppColors.primary,
                        child: CircleAvatar(
                          radius: getSize(28),
                          backgroundColor: AppColors.white,
                          backgroundImage: CachedNetworkImageProvider(image),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: getSize(12),
                          backgroundColor: AppColors.primary,
                          child: Icon(
                            Icons.check,
                            color: AppColors.black,
                            size: getSize(15),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: getVerticalSize(10),
                  ),
                  myText(
                    "Member\nSince $since",
                    textAlign: TextAlign.center,
                    fontSize: 12,
                  ),
                ],
              ),
              SizedBox(
                width: getHorizontalSize(20),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      myText(
                        name,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(
                        height: getVerticalSize(10),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          myText(
                            "Vehicle Type",
                            fontSize: 14,
                            color: AppColors.darkGrey,
                          ),
                          SizedBox(
                            width: getHorizontalSize(10),
                          ),
                          myText(
                            vehicle,
                            fontSize: 14,
                            color: AppColors.black,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: getVerticalSize(5),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          myText(
                            "City",
                            fontSize: 14,
                            color: AppColors.darkGrey,
                          ),
                          SizedBox(
                            width: getHorizontalSize(10),
                          ),
                          myText(
                            city,
                            fontSize: 14,
                            color: AppColors.black,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: getVerticalSize(5),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          myText(
                            "PinCode",
                            fontSize: 14,
                            color: AppColors.darkGrey,
                          ),
                          SizedBox(
                            width: getHorizontalSize(10),
                          ),
                          myText(
                            pincode,
                            fontSize: 14,
                            color: AppColors.black,
                          ),
                        ],
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
          Row(
            children: [
              Expanded(
                child: tapper(
                  onPressed: () async {
                    replyjobrequest(
                      requestId: requestId,
                      status: false,
                    );
                  },
                  child: Container(
                    height: getVerticalSize(45),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.black,
                      ),
                    ),
                    child: Center(
                      child: myText(
                        "DECLINE",
                        fontSize: 16,
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                      ),
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
                    replyjobrequest(requestId: requestId, status: true);
                  },
                  child: Container(
                    height: getVerticalSize(45),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: myText(
                        "ASSIGN",
                        fontSize: 16,
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  replyjobrequest({
    required String requestId,
    required bool status,
  }) async {
    showLoading();
    final response = await Apis.replyJobApi(
      jobRequestId: requestId,
      isAccept: status,
    );
    hideLoading();
    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsondata = json.decode(response.body);
      if (jsondata['success']) {
        showMessage(jsondata['message']);
        applicants.removeWhere(
            (element) => element['request_id'].toString() == requestId);
        setState(() {});
      }
    } else {
      showMessage("Something went wrong");
      log(response.body.toString());
    }
  }
}
