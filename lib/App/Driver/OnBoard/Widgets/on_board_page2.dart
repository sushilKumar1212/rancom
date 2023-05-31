import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Constants/colors.dart';
import '../../../Constants/constant_heplers.dart';
import '../../../Controllers/on_board_controller.dart';

class OnBoardPage2 extends StatefulWidget {
  const OnBoardPage2({super.key});

  @override
  State<OnBoardPage2> createState() => _OnBoardPage2State();
}

class _OnBoardPage2State extends State<OnBoardPage2> {
  @override
  Widget build(BuildContext context) {
    return Consumer<OnBoardController>(
      builder: (context, controller, child) {
        return Scaffold(
          appBar: AppBar(),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.primary,
            onPressed: () {
              controller.nextPage();
            },
            child: const Icon(Icons.arrow_forward),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/icons/ob2.png',
                  height: getVerticalSize(300),
                ),
                SizedBox(
                  height: getVerticalSize(15),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(),
                    Text(
                      '2/3',
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
                            width: getHorizontalSize(
                              80,
                            ),
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
                      controller.onboardModel!.introductionScreenData[1].title,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: getFontSize(27),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: getVerticalSize(10),
                    ),
                    Text(
                      controller
                          .onboardModel!.introductionScreenData[1].description!,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: getFontSize(16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
