import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thecourierapp/App/Common/common_widgets.dart';
import 'package:thecourierapp/App/Constants/colors.dart';
import 'package:thecourierapp/App/Constants/constant_heplers.dart';

class CompleteJobPopUp extends StatefulWidget {
  const CompleteJobPopUp({super.key});

  @override
  State<CompleteJobPopUp> createState() => _CompleteJobPopUpState();
}

class _CompleteJobPopUpState extends State<CompleteJobPopUp> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: getVerticalSize(250),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 30,
      ),
      child: Column(
        children: [
          SizedBox(
            height: getVerticalSize(10),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              tapper(
                onPressed: () {
                  Get.back();
                },
                child: const Icon(
                  Icons.close,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField(
                  isExpanded: true,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: getVerticalSize(15),
                    ),
                  ),
                  hint: const Text(
                    'Select Delivery Status',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'delivered',
                      child: Text(
                        'Delivered',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'not-delivered',
                      child: Text(
                        'Not Delivered',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                  onChanged: (value) {},
                ),
              ),
              SizedBox(
                width: getHorizontalSize(10),
              ),
              Container(
                height: getVerticalSize(45),
                width: getHorizontalSize(45),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          tapper(
            onPressed: () {
              Get.back();
            },
            child: Container(
              height: getVerticalSize(45),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  'Mark as complete'.toUpperCase(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: getFontSize(16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
