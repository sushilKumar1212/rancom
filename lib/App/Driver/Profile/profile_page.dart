import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:images_picker/images_picker.dart';
import 'package:provider/provider.dart';
import 'package:thecourierapp/App/Common/common_widgets.dart';
import 'package:thecourierapp/App/Constants/colors.dart';
import 'package:thecourierapp/App/Controllers/complete_profile_controller.dart';
import 'package:thecourierapp/App/Controllers/profile_controller.dart';
import 'package:thecourierapp/App/Utils/app_page_routes.dart';

import '../../Constants/constant_heplers.dart';

class PersonalProfilePage extends StatefulWidget {
  const PersonalProfilePage({Key? key}) : super(key: key);

  @override
  State<PersonalProfilePage> createState() => _PersonalProfilePageState();
}

class _PersonalProfilePageState extends State<PersonalProfilePage> {
  late ProfileController controller;

  @override
  void initState() {
    super.initState();
    controller = Provider.of<ProfileController>(context, listen: false);
    Future.delayed(const Duration(milliseconds: 100), () {
      controller.getPersonalDetails();
    });
  }

  File? _image;

  pickImage() async {
    final images = await ImagesPicker.pick(
      count: 1,
      pickType: PickType.image,
      quality: 0.2,
    );
    if (images != null) {
      setState(() {
        _image = File(images[0].path);
      });
      controller.updateProfilePic(
        file: _image!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: myText(
          "Personal",
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 10,
        shadowColor: AppColors.white.withOpacity(0.25),
      ),
      backgroundColor: AppColors.grey,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: getVerticalSize(20),
                  ),
                  Row(),
                  Stack(
                    children: [
                      tapper(
                        onPressed: () {
                          pickImage();
                        },
                        child: Consumer<CompleteProfileController>(
                          builder: (context, imageController, child) {
                            if (_image != null) {
                              return CircleAvatar(
                                radius: getSize(50),
                                backgroundImage: FileImage(_image!),
                              );
                            }
                            return CircleAvatar(
                              radius: getSize(50),
                              backgroundImage: imageController
                                          .personalInfoModel!.driver.imageUrl !=
                                      ""
                                  ? CachedNetworkImageProvider(
                                      imageController
                                          .personalInfoModel!.driver.imageUrl!,
                                    )
                                  : const CachedNetworkImageProvider(
                                      "https://cdn-icons-png.flaticon.com/512/3135/3135715.png",
                                    ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: tapper(
                          onPressed: () {
                            pickImage();
                          },
                          child: CircleAvatar(
                            radius: getSize(20),
                            backgroundColor: AppColors.primary,
                            child: Icon(
                              Icons.camera_alt_outlined,
                              color: AppColors.black,
                              size: getSize(20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: getVerticalSize(20),
                  ),
                  normalTextBox(
                    controller: controller.nameController,
                    hintText: "Name",
                    capitalization: TextCapitalization.words,
                    keyboardType: TextInputType.name,
                  ),
                  SizedBox(
                    height: getVerticalSize(10),
                  ),
                  normalTextBox(
                    controller: controller.addressController,
                    hintText: "Address",
                    keyboardType: TextInputType.streetAddress,
                  ),
                  SizedBox(
                    height: getVerticalSize(10),
                  ),
                  normalTextBox(
                    controller: controller.emailController,
                    hintText: "Email",
                    keyboardType: TextInputType.emailAddress,
                    endText: "Verified",
                  ),
                  SizedBox(
                    height: getVerticalSize(10),
                  ),
                  normalTextBox(
                    controller: controller.phoneController,
                    hintText: "Phone Number",
                    keyboardType: TextInputType.phone,
                    endText: "Verified",
                  ),
                  SizedBox(
                    height: getVerticalSize(10),
                  ),
                  normalTextBox(
                    controller: controller.dobController,
                    hintText: "D.O.B",
                    keyboardType: TextInputType.datetime,
                  ),
                  SizedBox(
                    height: getVerticalSize(10),
                  ),
                  normalTextBox(
                    controller: controller.ninController,
                    hintText: "National Insurance Number",
                  ),
                  SizedBox(
                    height: getVerticalSize(20),
                  ),
                  tapper(
                    onPressed: () {},
                    child: Container(
                      height: getVerticalSize(50),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: myText(
                          "UPDATE PROFILE",
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            child: tapper(
              onPressed: () {
                Get.toNamed(AppRoute.changepassword);
              },
              child: myText(
                'Change Password',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
