import 'package:flutter/material.dart';

import '../../Constants/colors.dart';
import '../../Constants/constant_heplers.dart';

class WelcomePage2 extends StatefulWidget {
  const WelcomePage2({Key? key}) : super(key: key);

  @override
  State<WelcomePage2> createState() => _WelcomePage2State();
}

class _WelcomePage2State extends State<WelcomePage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              SizedBox(
                height: getVerticalSize(20),
              ),
              Text(
                'Here’s what being a Car Courier involves.'.toUpperCase(),
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: getFontSize(35),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: getVerticalSize(20),
              ),
              Text(
                "As a car courier, we are seeking reliable, hardworking, and customer-focused individuals who are committed to delivering excellent service. The ideal candidate will possess a valid UK driver's license, their own vehicle, and the ability to work within the UK. Previous experience in delivery or transportation is preferred but not required. This is a self-employment opportunity that provides you with the flexibility to take control of your earning potential.",
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: getFontSize(18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
