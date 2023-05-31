import 'package:flutter/material.dart';
import 'package:thecourierapp/App/Driver/Jobs/driver_ongoing_job.dart';
import 'package:thecourierapp/App/Driver/Jobs/driver_past_job.dart';

import '../../Constants/colors.dart';
import '../../Constants/constant_heplers.dart';

class JobsPage extends StatefulWidget {
  final int? index;
  const JobsPage({Key? key, this.index}) : super(key: key);

  @override
  State<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.index ?? 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Jobs',
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
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.black,
            unselectedLabelColor: AppColors.darkGrey,
            indicatorWeight: 3,
            tabs: const [
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
            color: AppColors.grey.withOpacity(0.5),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                DriverOnGoinJobPage(),
                DriverPastJobPage(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
