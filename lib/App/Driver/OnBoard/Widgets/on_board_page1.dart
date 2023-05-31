import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thecourierapp/App/Common/common_widgets.dart';
import 'package:thecourierapp/App/Constants/colors.dart';
import 'package:thecourierapp/App/Constants/constant_heplers.dart';
import 'package:thecourierapp/App/Controllers/on_board_controller.dart';

class OnBoardPage1 extends StatefulWidget {
  const OnBoardPage1({Key? key}) : super(key: key);

  @override
  State<OnBoardPage1> createState() => _OnBoardPage1State();
}

class _OnBoardPage1State extends State<OnBoardPage1> {
  @override
  Widget build(BuildContext context) {
    return Consumer<OnBoardController>(
      builder: (context, controller, child) {
        return Scaffold(
          appBar: AppBar(
            // backgroundColor: Colors.white,
            elevation: 0,
            actions: [
              TextButton(
                onPressed: () {
                  controller.onSkip();
                },
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
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
                  'assets/images/icons/ob1.png',
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
                      '1/3',
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
                              40,
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
                      controller.onboardModel!.introductionScreenData[0].title,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: getFontSize(27),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: getVerticalSize(10),
                    ),
                    myText(
                      controller
                          .onboardModel!.introductionScreenData[0].description!,
                      color: Colors.black,
                      fontSize: 16,
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
