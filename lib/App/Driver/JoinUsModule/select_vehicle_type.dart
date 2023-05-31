import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thecourierapp/App/Constants/colors.dart';
import 'package:thecourierapp/App/Constants/constant_heplers.dart';
import 'package:thecourierapp/App/Controllers/join_us_controller.dart';

class SelectVehicleType extends StatefulWidget {
  const SelectVehicleType({Key? key}) : super(key: key);

  @override
  State<SelectVehicleType> createState() => _SelectVehicleTypeState();
}

class _SelectVehicleTypeState extends State<SelectVehicleType> {
  late JoinUsController controller;

  @override
  void initState() {
    super.initState();
    controller = Provider.of<JoinUsController>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: getVerticalSize(20),
            ),
            Text(
              'Select Vehicle Type',
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
              'Please select the image that best matches your vehicle type so we can ensure that the right jobs are assigned to you.',
              style: TextStyle(
                color: AppColors.black,
                fontSize: getFontSize(18),
              ),
            ),
            SizedBox(
              height: getVerticalSize(20),
            ),
            Consumer<JoinUsController>(builder: (context, value, child) {
              return ListView.builder(
                itemCount: vehiclesType.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final vehicle = vehiclesType[index];
                  return GestureDetector(
                    onTap: () {
                      controller.selectVehicle(
                        vehicle['id'],
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(10),
                      height: getVerticalSize(100),
                      child: Row(
                        children: [
                          Checkbox(
                            value: vehicle['id'] == value.selectedVehicleType,
                            onChanged: (value) {
                              controller.selectVehicle(
                                vehicle['id'],
                              );
                            },
                          ),
                          SizedBox(
                            width: getHorizontalSize(10),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  vehicle['title'],
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: getFontSize(16),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: getVerticalSize(5),
                                ),
                                Text(
                                  vehicle['description'],
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: getFontSize(14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Image.asset(
                            vehicle['image'],
                            height: getVerticalSize(50),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
