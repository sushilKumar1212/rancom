import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:thecourierapp/App/Common/common_widgets.dart';
import 'package:thecourierapp/App/Constants/colors.dart';
import 'package:thecourierapp/App/Constants/constant_heplers.dart';
import 'package:thecourierapp/App/Controllers/join_us_controller.dart';

class PhoneNumberFill extends StatefulWidget {
  const PhoneNumberFill({Key? key}) : super(key: key);

  @override
  State<PhoneNumberFill> createState() => _PhoneNumberFillState();
}

class _PhoneNumberFillState extends State<PhoneNumberFill> {
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
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Phone Number",
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
              "Please provide a valid phone number where we can reach you regarding your application. We may need to contact you to discuss your availability, job requirements, or to schedule an interview. Your privacy is important to us.",
              style: TextStyle(
                color: AppColors.black,
                fontSize: getFontSize(18),
              ),
            ),
            SizedBox(
              height: getVerticalSize(20),
            ),
            CommonWidgets.textbox(
              controller: controller.phoneNumberController,
              prefixIcon: Ionicons.phone_portrait_outline,
              hintText: 'Phone number',
              keyboardType: TextInputType.phone,
              maxLength: 11,
              showCountryCode: true,
            ),
          ],
        ),
      ),
    );
  }
}
