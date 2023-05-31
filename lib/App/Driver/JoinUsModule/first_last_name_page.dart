import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:thecourierapp/App/Common/common_widgets.dart';
import 'package:thecourierapp/App/Constants/colors.dart';
import 'package:thecourierapp/App/Constants/constant_heplers.dart';
import 'package:thecourierapp/App/Controllers/join_us_controller.dart';

class FirstLastNamePage extends StatefulWidget {
  const FirstLastNamePage({Key? key}) : super(key: key);

  @override
  State<FirstLastNamePage> createState() => _FirstLastNamePageState();
}

class _FirstLastNamePageState extends State<FirstLastNamePage> {
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
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: getVerticalSize(20),
            ),
            Text(
              "LET’S GET STARTED WHAT’S YOUR NAME?*",
              style: TextStyle(
                color: AppColors.black,
                fontSize: getFontSize(33),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: getVerticalSize(20),
            ),
            CommonWidgets.textbox(
              focusNode: controller.firstNameFocusNode,
              formatter: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
              ],
              validator: (value) {
                if (value!.isEmpty) {
                  return 'First Name is required'.toUpperCase();
                }
                return null;
              },
              controller: controller.firstNameController,
              capitalization: TextCapitalization.words,
              prefixIcon: Ionicons.person_circle_outline,
              hintText: 'First Name'.toUpperCase(),
            ),
            SizedBox(
              height: getVerticalSize(20),
            ),
            CommonWidgets.textbox(
              formatter: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
              ],
              controller: controller.lastNameController,
              focusNode: controller.lastNameFocusNode,
              capitalization: TextCapitalization.words,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Last Name is required'.toUpperCase();
                }
                return null;
              },
              prefixIcon: Ionicons.person_circle_outline,
              hintText: 'Last Name'.toUpperCase(),
            ),
          ],
        ),
      ),
    );
  }
}
