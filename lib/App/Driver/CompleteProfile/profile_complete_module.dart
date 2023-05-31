import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:thecourierapp/App/Common/common_widgets.dart';
import 'package:thecourierapp/App/Constants/colors.dart';
import 'package:thecourierapp/App/Constants/constant_heplers.dart';
import 'package:thecourierapp/App/Controllers/complete_profile_controller.dart';

import 'c_banking_page.dart';
import 'c_document_page.dart';
import 'c_personal_page.dart';
import 'c_vehicle_page.dart';

class CompleteProfileModule extends StatefulWidget {
  final int? page;
  final bool? showBar;
  const CompleteProfileModule({Key? key, this.page, this.showBar = true})
      : super(key: key);

  @override
  State<CompleteProfileModule> createState() => _CompleteProfileModuleState();
}

class _CompleteProfileModuleState extends State<CompleteProfileModule> {
  List<Widget> pages = [
    const CpersonalPage(),
    const CVehiclePage(),
    const CDocumentPage(),
    const CBankingPage(),
  ];
  List<String> titles = [
    "Personal",
    "Vehicle",
    "Documents",
    "Banking",
  ];

  @override
  void initState() {
    super.initState();
    if (mounted) {
      Provider.of<CompleteProfileController>(context, listen: false)
          .currentPage = widget.page ?? 0;
      Future.delayed(const Duration(milliseconds: 200), () {
        Provider.of<CompleteProfileController>(context, listen: false)
            .pageController
            .jumpToPage(widget.page ?? 0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.page != null) {
          return true;
        }
        if (Provider.of<CompleteProfileController>(context, listen: false)
                .currentPage ==
            0) {
          return true;
        }
        final controller =
            Provider.of<CompleteProfileController>(context, listen: false);
        controller.setCurrentPage(controller.currentPage - 1);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: widget.showBar == false
              ? myText(
                  titles[widget.page!],
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                )
              : myText(
                  "Complete Profile",
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
          elevation: 10,
          backgroundColor: AppColors.primary,
          shadowColor: AppColors.white.withOpacity(0.25),
          centerTitle: true,
        ),
        backgroundColor: AppColors.grey,
        body: Consumer<CompleteProfileController>(
            builder: (context, controller, child) {
          return Column(
            children: [
              widget.showBar == false
                  ? Container()
                  : Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.white.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      height: getVerticalSize(88),
                      child: Padding(
                        padding: EdgeInsets.only(top: getVerticalSize(20)),
                        child: StepProgressView(
                          curStep: controller.currentPage + 1,
                          titles: titles,
                          width: Get.width,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
              Expanded(
                child: PageView(
                  controller: Provider.of<CompleteProfileController>(context,
                          listen: false)
                      .pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: pages,
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
