import 'package:flutter/material.dart';
import 'package:thecourierapp/App/Constants/colors.dart';
import 'package:thecourierapp/App/Constants/constant_heplers.dart';

class WelcomePage1 extends StatefulWidget {
  const WelcomePage1({Key? key}) : super(key: key);

  @override
  State<WelcomePage1> createState() => _WelcomePage1State();
}

class _WelcomePage1State extends State<WelcomePage1> {
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
                'Nice to meet you, thanks for taking the time to apply. Here’s what being a Car Courier involves.'
                    .toUpperCase(),
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
                "As a car courier, you'll be in charge of picking up and delivering small to medium-sized packages and parcels to homes and businesses in your designated area. You'll use your phone and our easy to use app to plan the most efficient route, and your friendly, professional demeanor will make every delivery a breeze. You'll be the hero that keeps everything running smoothly.",
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
