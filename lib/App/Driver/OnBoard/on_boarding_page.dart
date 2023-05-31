import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thecourierapp/App/Controllers/on_board_controller.dart';

import 'Widgets/on_board_page1.dart';
import 'Widgets/on_board_page2.dart';
import 'Widgets/on_board_page3.dart';

class OnBoardPage extends StatefulWidget {
  const OnBoardPage({Key? key}) : super(key: key);

  @override
  State<OnBoardPage> createState() => _OnBoardPageState();
}

class _OnBoardPageState extends State<OnBoardPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<OnBoardController>(
      builder: (context, controller, child) {
        return Scaffold(
          // floatingActionButton: controller.currentPage != 2
          //     ? Row(
          //         children: [
          //           SizedBox(
          //             width: getHorizontalSize(20),
          //           ),
          //           if (controller.currentPage == 1)
          //             tapper(
          //               onPressed: () {
          //                 controller.previousPage();
          //               },
          //               child: const Text(
          //                 'Prev',
          //                 style: TextStyle(
          //                   color: Colors.black,
          //                   fontSize: 16,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //             ),
          //           const Spacer(),
          //           FloatingActionButton(
          //             backgroundColor: AppColors.primary,
          //             onPressed: () {
          //               controller.nextPage();
          //             },
          //             child: const Icon(Icons.arrow_forward),
          //           ),
          //         ],
          //       )
          //     : null,
          // appBar: AppBar(
          //   actions: const [
          //     // controller.currentPage != 0
          //     //     ? const SizedBox()
          //     //     : TextButton(
          //     //         onPressed: () {
          //     //           controller.onSkip();
          //     //         },
          //     //         child: const Text(
          //     //           'Skip',
          //     //           style: TextStyle(
          //     //             color: Colors.black,
          //     //             fontSize: 16,
          //     //           ),
          //     //         ),
          //     //       ),
          //   ],
          // ),
          body: controller.isloding
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : PageView(
                  controller: controller.pageController,
                  children: const [
                    OnBoardPage1(),
                    OnBoardPage2(),
                    OnBoardPage3(),
                  ],
                ),
        );
      },
    );
  }
}
