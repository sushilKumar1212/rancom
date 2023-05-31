import 'package:flutter/material.dart';
import 'package:thecourierapp/App/Common/common_widgets.dart';
import 'package:thecourierapp/App/Constants/colors.dart';
import 'package:thecourierapp/App/Customer/MyJobs/c_ongoing_jobs.dart';
import 'package:thecourierapp/App/Customer/MyJobs/c_past_jobs_page.dart';
import 'package:thecourierapp/App/Customer/MyJobs/pending_jobs_page.dart';

import '../../Constants/constant_heplers.dart';

class MyJobsPage extends StatefulWidget {
  const MyJobsPage({Key? key}) : super(key: key);

  @override
  State<MyJobsPage> createState() => _MyJobsPageState();
}

class _MyJobsPageState extends State<MyJobsPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: myText(
            'My Jobs',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          centerTitle: true,
          elevation: 10,
          shadowColor: AppColors.white.withOpacity(0.2),
          backgroundColor: AppColors.primary,
        ),
        backgroundColor: AppColors.grey,
        body: Column(
          children: [
            const TabBar(
              indicatorColor: AppColors.primary,
              labelColor: AppColors.black,
              unselectedLabelColor: AppColors.darkGrey,
              indicatorWeight: 3,
              unselectedLabelStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              labelStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              tabs: [
                Tab(
                  text: 'Pending',
                ),
                Tab(
                  text: 'On Going',
                ),
                Tab(
                  text: 'Past',
                ),
              ],
            ),
            Divider(
              height: 1,
              thickness: 4,
              color: AppColors.darkGrey.withOpacity(0.5),
            ),
            SizedBox(
              height: getVerticalSize(10),
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  PendingJobs(),
                  COngoingJobs(),
                  CPastJobsPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
