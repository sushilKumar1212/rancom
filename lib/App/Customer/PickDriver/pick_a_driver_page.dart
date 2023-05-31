import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:thecourierapp/App/Common/common_widgets.dart';
import 'package:thecourierapp/App/Constants/colors.dart';
import 'package:thecourierapp/App/Constants/constant_heplers.dart';
import 'package:thecourierapp/App/Core/apis.dart';
import 'package:thecourierapp/App/Customer/PickDriver/jobs_for_invite.dart';

import '../../Controllers/user_controller.dart';

class PickADriverPage extends StatefulWidget {
  const PickADriverPage({Key? key}) : super(key: key);

  @override
  State<PickADriverPage> createState() => _PickADriverPageState();
}

class _PickADriverPageState extends State<PickADriverPage> {
  String? filterType;
  bool isloading = false;
  bool showUpdateLocation = false;
  List<Map<String, dynamic>> drivers = [];
  List<Map<String, dynamic>> filtered = [];
  final searchController = TextEditingController();
  Timer? timer;

  @override
  void initState() {
    super.initState();
    getDrivers();
    searchController.addListener(() {
      if (timer != null) {
        timer!.cancel();
      }
      timer = Timer(const Duration(milliseconds: 500), () {
        getDrivers();
      });
    });
  }

  updateLocation() async {
    showLoading();
    final controller = Provider.of<UserController>(context, listen: false);
    await controller.updateLocation();
    hideLoading();
    getDrivers();
  }

  getDrivers() async {
    setState(() {
      isloading = true;
    });
    final response = await Apis.getNearbyDriversApis(
      name: searchController.text.isEmpty ? '' : searchController.text,
      vehicleType: filterType ?? '',
    );
    setState(() {
      isloading = false;
    });
    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsondata = jsonDecode(response.body);
      if (jsondata['success'] == false &&
          jsondata['message'] == 'Please update you location first.') {
        setState(() {
          showUpdateLocation = true;
        });
      } else {
        log(jsondata.toString());
        setState(() {
          showUpdateLocation = false;
          drivers = jsondata['drivers'].map<Map<String, dynamic>>((e) {
            return e as Map<String, dynamic>;
          }).toList();
          filtered.clear();
          filtered.addAll(drivers);
          if (filterType != null) {
            filtered.removeWhere(
                (element) => element['vehicle_type'] != filterType);
          }
        });
      }
    }
  }

  filterData(String type) {
    filtered.clear();
    if (type == "all") {
      setState(() {
        filterType = null;
        filtered.addAll(drivers);
      });
      return;
    }

    setState(() {
      filterType = type;
      filtered.addAll(drivers);
      if (filterType != null) {
        filtered
            .removeWhere((element) => element['vehicle_type'] != filterType);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: myText(
          'Pick a Driver',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      backgroundColor: AppColors.grey,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: getHorizontalSize(15)),
        child: Column(
          children: [
            SizedBox(height: getVerticalSize(20)),
            Container(
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.darkGrey,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 10,
                  ),
                  hintText: 'Search',
                  hintStyle: const TextStyle(
                    color: AppColors.darkGrey,
                  ),
                  border: InputBorder.none,
                  suffixIcon: Icon(
                    CupertinoIcons.search,
                    color: AppColors.black,
                    size: getSize(25),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                myText(
                  'Total Results (${filtered.length})',
                  fontSize: 14,
                ),
                const Spacer(),
                DropdownButton(
                  value: filterType,
                  items: [
                    DropdownMenuItem(
                      value: "all",
                      child: myText(
                        'Filter by Vehicle',
                        fontSize: 14,
                      ),
                    ),
                    ...vehiclesType.map((e) {
                      return DropdownMenuItem(
                        value: e['id'],
                        child: myText(
                          e['title'],
                          fontSize: 14,
                        ),
                      );
                    })
                  ],
                  underline: Container(),
                  hint: myText(
                    'Filter by Vehicle',
                    fontSize: 14,
                  ),
                  onChanged: (value) {
                    if (value == "all") {
                      setState(() {
                        filterType = null;
                      });
                      filterData('all');
                      return;
                    }
                    setState(() {
                      filterType = value.toString();
                    });
                    filterData(value.toString());
                  },
                ),
              ],
            ),
            Expanded(
              child: isloading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : showUpdateLocation
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              myText(
                                'Please update your location first',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              SizedBox(height: getVerticalSize(20)),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(
                                    getHorizontalSize(200),
                                    getVerticalSize(45),
                                  ),
                                ),
                                onPressed: updateLocation,
                                child: myText(
                                  'Update Location',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          separatorBuilder: (context, index) {
                            return SizedBox(height: getVerticalSize(20));
                          },
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final driver = filtered[index];
                            return applicantsCard(
                              name: driver['full_name'],
                              vehicle: vehiclesType
                                  .where((element) =>
                                      element['id'] == driver['vehicle_type'])
                                  .first['title'],
                              pincode: driver['pin_code'],
                              since: "N/A",
                              image: driver['profile'] == null
                                  ? "https://picsum.photos/200/300"
                                  : driver['profile']['url'],
                              city: driver['city'],
                              requestId: driver['_id'],
                            );
                          },
                        ),
            )
          ],
        ),
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
                  onPressed: () {
                    Get.to(
                      () => JobsForInvite(
                        jobid: requestId,
                      ),
                    );
                  },
                  child: Container(
                    height: getVerticalSize(45),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: myText(
                        "Send a Job Invite".toUpperCase(),
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
}
