import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thecourierapp/App/Constants/colors.dart';
import 'package:thecourierapp/App/Controllers/join_us_controller.dart';

import '../../Constants/constant_heplers.dart';

class SelectHustlerType extends StatefulWidget {
  const SelectHustlerType({Key? key}) : super(key: key);

  @override
  State<SelectHustlerType> createState() => _SelectHustlerTypeState();
}

class _SelectHustlerTypeState extends State<SelectHustlerType> {
  late JoinUsController joinUsController;

  @override
  void initState() {
    super.initState();
    joinUsController = Provider.of<JoinUsController>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            SizedBox(
              height: getVerticalSize(20),
            ),
            Text(
              "Are you a full-time hustler or a part-time pro?".toUpperCase(),
              style: TextStyle(
                color: AppColors.black,
                fontSize: getFontSize(35),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: getVerticalSize(5),
            ),
            Text(
              "We understand that every driver has different needs and expectations as a self-employed courier. Please indicate your preference by ticking the options that interests you more.",
              style: TextStyle(
                color: AppColors.black,
                fontSize: getFontSize(18),
              ),
            ),
            SizedBox(
              height: getVerticalSize(20),
            ),
            Consumer<JoinUsController>(
              builder: (BuildContext context, value, Widget? child) =>
                  ListView.builder(
                itemCount: hustlersType.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      joinUsController.selectHustle(
                        hustlersType[index]['title'],
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Checkbox(
                            value: hustlersType[index]['title'] ==
                                value.selectedHustlerType,
                            onChanged: (value) {
                              joinUsController.selectHustle(
                                hustlersType[index]['title'],
                              );
                            },
                          ),
                          Expanded(
                            child: Text(
                              hustlersType[index]['description'],
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: getFontSize(16),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
