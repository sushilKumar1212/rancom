import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

Size size = WidgetsBinding.instance.window.physicalSize /
    WidgetsBinding.instance.window.devicePixelRatio;

double getVerticalSize(double px) {
  final num statusBar =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).viewPadding.top;
  final num screenHeight = size.height - statusBar;
  return px * (screenHeight / 760);
}

double getHorizontalSize(double px) {
  return px * (size.width / 360);
}

double getFontSize(double px) {
  final height = getVerticalSize(px);
  final width = getHorizontalSize(px);
  if (height < width) {
    return height.toInt().toDouble();
  } else {
    return width.toInt().toDouble();
  }
}

double getSize(double px) {
  final height = getVerticalSize(px);
  final width = getHorizontalSize(px);
  if (height < width) {
    return height.toInt().toDouble();
  } else {
    return width.toInt().toDouble();
  }
}

//Show Loading
void showLoading() {
  Get.dialog(
    const Center(
      child: CircularProgressIndicator(),
    ),
    barrierDismissible: false,
  );
}

//Hide Loading
void hideLoading() {
  if (Get.isDialogOpen!) {
    Get.back();
  }
}

//Password validation
bool isPasswordValid(String password) {
  // Special Character will be all the characters except a-z, A-Z, 0-9
  final regex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[^\w\s]).{8,}$');
  Fluttertoast.cancel();
  if (password.length < 8) {
    Fluttertoast.showToast(
      msg: 'Password must be at least 8 characters long',
      backgroundColor: Colors.red,
    );
    return false;
  } else if (!regex.hasMatch(password)) {
    Fluttertoast.showToast(
      msg:
          'Password must contain at least one Uppercase, one Lowercase, one Number and one Special Character',
      backgroundColor: Colors.red,
    );
    return false;
  }
  return regex.hasMatch(password);
}

List<Map<String, dynamic>> hustlersType = [
  {
    "id": 1,
    'title': 'full_time_hustler',
    "description":
        "Full-time hustler: For those who want to work hard and earn big bucks, a full-time position is perfect.",
  },
  {
    "id": 2,
    'title': 'part_time_pro',
    "description":
        "Part-time pro: Perfect for those who need a flexible schedule and want to work a short week.",
  },
  {
    "id": 3,
    'title': 'last_minute',
    "description":
        "Last-minute legend: If you're great under pressure and can handle last-minute requests, this is the job for you.",
  },
  {
    "id": 4,
    'title': 'part_time_pro_twist',
    "description":
        "Part-time pro with a twist: The perfect option for those who want to work part-time but still have the option to take on extra shifts when they want",
  }
];

List<Map<String, dynamic>> vehiclesType = [
  {
    "id": 'small_car',
    "title": "Small Car",
    "description": "Up to 50 parcels per trip",
    "image": "assets/images/smallcar.png",
  },
  {
    "id": 'hatchback',
    "title": "Hatchback",
    "description": "Up to 140 parcels per trip",
    "image": "assets/images/hatchback.png",
  },
  {
    "id": 'mpv',
    "title": "MPV",
    "description": "Up to 200 parcels per trip",
    "image": "assets/images/mpv.png",
  },
  {
    "id": 'estate',
    "title": "Estate",
    "description": "Up to 200 parcels per trip",
    "image": "assets/images/estate.png",
  },
  {
    "id": 'car_van',
    "title": "Car / Van",
    "description": "Up to 200 parcels per trip",
    "image": "assets/images/van.png",
  },
  {
    "id": 'small_van',
    "title": "Small Van",
    "description": "Up to 250 parcels per trip",
    "image": "assets/images/largevan.png",
  },
  {
    "id": 'large_van',
    "title": "Large Van",
    "description": "Up to 250 parcels per trip",
    "image": "assets/images/smallvan.png",
  },
];
