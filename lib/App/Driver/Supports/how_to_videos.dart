import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:thecourierapp/App/Common/common_widgets.dart';

import '../../Constants/colors.dart';
import '../../Constants/constant_heplers.dart';

class HowToVideosPage extends StatefulWidget {
  const HowToVideosPage({Key? key}) : super(key: key);

  @override
  State<HowToVideosPage> createState() => _HowToVideosPageState();
}

class _HowToVideosPageState extends State<HowToVideosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: myText(
          "How to Videos",
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: getVerticalSize(10),
            ),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              shrinkWrap: true,
              separatorBuilder: (context, index) => SizedBox(
                height: getVerticalSize(10),
              ),
              itemBuilder: (context, index) {
                return Container(
                  height: getVerticalSize(194),
                  width: getHorizontalSize(390),
                  decoration: BoxDecoration(
                    color: AppColors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Icon(
                      Foundation.play_video,
                      size: getSize(35),
                      color: AppColors.black,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
