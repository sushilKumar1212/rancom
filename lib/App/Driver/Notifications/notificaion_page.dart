import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:thecourierapp/App/Common/common_widgets.dart';
import 'package:thecourierapp/App/Constants/colors.dart';
import 'package:thecourierapp/App/Constants/constant_heplers.dart';
import 'package:thecourierapp/App/Core/apis.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Map<String, dynamic>> notifications = [];
  int lastPage = 0;
  int currentPage = 1;
  bool isloading = false;

  @override
  void initState() {
    super.initState();
    getNotification();
  }

  getNotification() async {
    log("Token:${GetStorage().read("token")}");
    setState(() {
      isloading = true;
    });
    final response = await Apis.getNotificationApi();
    setState(() {
      isloading = false;
    });
    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsondata = jsonDecode(response.body);
      if (jsondata['success']) {
        setState(() {
          notifications = jsondata['notifications'].map<Map<String, dynamic>>(
            (e) {
              return e as Map<String, dynamic>;
            },
          ).toList();
          notifications.sort((a, b) {
            return b['timestamp'].compareTo(a['timestamp']);
          });
        });
      } else {
        log(jsondata['message']);
      }
    }
  }

  deleteAllNotification() async {
    showLoading();
    final response = await Apis.deleteDriverNotifications();
    hideLoading();
    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsondata = jsonDecode(response.body);
      if (jsondata['success']) {
        setState(() {
          notifications = [];
        });
      } else {
        log(jsondata['message']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey,
      appBar: AppBar(
        title: myText(
          "Notifications",
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 10,
        shadowColor: AppColors.white.withOpacity(0.25),
      ),
      body: isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : notifications.isEmpty
              ? Center(
                  child: myText(
                    "No New Notifications",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getHorizontalSize(15),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          myText(
                            "",
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          const Spacer(),
                          tapper(
                            onPressed: () {
                              deleteAllNotification();
                            },
                            child: myText(
                              "Mark All as Read",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: getVerticalSize(20),
                      ),
                      Expanded(
                        child: ListView.separated(
                          shrinkWrap: true,
                          separatorBuilder: (context, index) {
                            return const Divider(
                              height: 20,
                            );
                          },
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            return notificationCard(
                              title: notifications[index]['title'],
                              time: notifications[index]['timestamp'],
                              description: notifications[index]['body'],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget notificationCard({
    required String title,
    required String time,
    required String description,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: getFontSize(16),
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              width: getHorizontalSize(10),
            ),
            myText(
              DateFormat('dd MMM, yyyy hh:mm a').format(
                DateTime.parse(time),
              ),
              fontSize: 12,
              color: AppColors.darkGrey,
            ),
          ],
        ),
        Text(
          description,
          style: TextStyle(
            fontSize: getFontSize(14),
            color: AppColors.black,
          ),
        ),
      ],
    );
  }
}
