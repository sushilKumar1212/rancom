import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:thecourierapp/App/Constants/colors.dart';
import 'package:thecourierapp/App/Constants/constant_heplers.dart';

class LastPage extends StatefulWidget {
  const LastPage({Key? key}) : super(key: key);

  @override
  State<LastPage> createState() => _LastPageState();
}

class _LastPageState extends State<LastPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(),
            SizedBox(
              height: getVerticalSize(20),
            ),
            Container(
              width: getHorizontalSize(150),
              height: getVerticalSize(150),
              decoration: DottedDecoration(
                shape: Shape.circle,
                color: AppColors.black,
                strokeWidth: 1,
                dash: const [5, 5],
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Image.asset(
                        'assets/images/confettiicon.png',
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: getVerticalSize(20),
            ),
            Text(
              "Great news! You're one step closer to becoming a car courier with us."
                  .toUpperCase(),
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
              "To proceed with your application, please take a few moments to complete your in-app personal profile. This will help us get to know you better and ensure we can match you with the right delivery jobs. Thank you for choosing to join our dynamic community of couriers!",
              style: TextStyle(
                color: AppColors.black,
                fontSize: getFontSize(18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
