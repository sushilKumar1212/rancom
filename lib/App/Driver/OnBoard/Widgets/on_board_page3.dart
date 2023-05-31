import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../Constants/colors.dart';
import '../../../Constants/constant_heplers.dart';
import '../../../Controllers/on_board_controller.dart';

class OnBoardPage3 extends StatefulWidget {
  const OnBoardPage3({Key? key}) : super(key: key);

  @override
  State<OnBoardPage3> createState() => _OnBoardPage3State();
}

class _OnBoardPage3State extends State<OnBoardPage3> {
  @override
  Widget build(BuildContext context) {
    return Consumer<OnBoardController>(
      builder: (context, controller, child) {
        return Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Image.asset(
                          'assets/images/icons/ob3.png',
                          height: getVerticalSize(300),
                        ),
                      ),
                      SizedBox(
                        height: getVerticalSize(10),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(),
                            Text(
                              '3/3',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: getFontSize(36),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: getVerticalSize(5),
                            ),
                            SizedBox(
                              width: getHorizontalSize(120),
                              child: Stack(
                                children: [
                                  Container(
                                    height: getVerticalSize(5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColors.grey,
                                    ),
                                  ),
                                  Container(
                                    height: getVerticalSize(5),
                                    width: getHorizontalSize(120),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: getVerticalSize(10),
                            ),
                            Text(
                              controller.onboardModel!.introductionScreenData[2]
                                  .title,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: getFontSize(27),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: getVerticalSize(10),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: getVerticalSize(180),
                        width: Get.width,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              width: getHorizontalSize(10),
                            );
                          },
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.onboardModel!
                              .introductionScreenData[2].articles.length,
                          itemBuilder: (context, index) {
                            final article = controller.onboardModel!
                                .introductionScreenData[2].articles[index];
                            return Container(
                              width: getHorizontalSize(293),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.grey,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    article.title,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: getFontSize(18),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: getVerticalSize(10),
                                  ),
                                  Text(
                                    article.description,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: getFontSize(14),
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: Get.width * 0.9,
                height: 50,
                margin: const EdgeInsets.only(
                  top: 10,
                  bottom: 20,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: () {
                    controller.onDone();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'START YOUR ENGINES',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: getFontSize(16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: getVerticalSize(10),
              ),
            ],
          ),
        );
      },
    );
  }
}
