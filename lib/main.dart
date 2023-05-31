import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:thecourierapp/App/Constants/colors.dart';
import 'package:thecourierapp/App/Controllers/Customer/JobPost/delivery_controller.dart';
import 'package:thecourierapp/App/Controllers/Customer/JobPost/package_controller.dart';
import 'package:thecourierapp/App/Controllers/Customer/JobPost/pickup_controller.dart';
import 'package:thecourierapp/App/Controllers/Customer/job_pos_controller.dart';
import 'package:thecourierapp/App/Controllers/chnage_password_controller.dart';
import 'package:thecourierapp/App/Controllers/complete_profile_controller.dart';
import 'package:thecourierapp/App/Controllers/forgot_password_controller.dart';
import 'package:thecourierapp/App/Controllers/home_controller.dart';
import 'package:thecourierapp/App/Controllers/login_controller.dart';
import 'package:thecourierapp/App/Controllers/on_board_controller.dart';
import 'package:thecourierapp/App/Controllers/profile_controller.dart';

import 'App/Controllers/join_us_controller.dart';
import 'App/Controllers/user_controller.dart';
import 'App/Utils/app_page_routes.dart';
import 'firebase_options.dart';

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

initNotification() async {
  const initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const initializationSettingsDarwin = DarwinInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );
}

@override
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log('Handling a background message ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.instance.requestPermission();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  initNotification();
  await ScreenUtil.ensureScreenSize();
  await GetStorage.init();
  return runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => JoinUsController()),
      ChangeNotifierProvider(create: (_) => OnBoardController()),
      ChangeNotifierProvider(create: (_) => UserController()),
      ChangeNotifierProvider(create: (_) => LoginController()),
      ChangeNotifierProvider(create: (_) => HomeController()),
      ChangeNotifierProvider(create: (_) => ForgotPasswordController()),
      ChangeNotifierProvider(create: (_) => CompleteProfileController()),
      ChangeNotifierProvider(create: (_) => ProfileController()),
      ChangeNotifierProvider(create: (_) => ChangePasswordController()),
      ChangeNotifierProvider(create: (_) => JobPostController()),
      ChangeNotifierProvider(create: (_) => PickupController()),
      ChangeNotifierProvider(create: (_) => DeliveryController()),
      ChangeNotifierProvider(create: (_) => PackageController()),
    ], child: const MyApp()),
  );
}

String? deviceToken;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    getDeviceToken();
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final controller = Provider.of<HomeController>(context, listen: false);
      controller.getjobsCount();
      final notification = message.notification;
      const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'com.ibyte.thecarcourier',
        'The Car Courier',
        channelDescription: "your channel description",
        importance: Importance.max,
        priority: Priority.high,
      );
      const iOSPlatformChannelSpecifics = DarwinNotificationDetails();
      const platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );
      if (Platform.isAndroid) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification!.title,
          notification.body,
          platformChannelSpecifics,
        );
      }
    });
  }

  Future<void> getDeviceToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    setState(() {
      deviceToken = token;
    });
    log('deviceToken: $deviceToken');
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 760),
      builder: (context, child) {
        return GetMaterialApp(
          title: 'The Courier',
          theme: ThemeData(
            fontFamily: 'TTNorms',
            primarySwatch: MaterialColor(
              AppColors.primary.value,
              <int, Color>{
                50: AppColors.primary.withOpacity(0.1),
                100: AppColors.primary.withOpacity(0.2),
                200: AppColors.primary.withOpacity(0.3),
                300: AppColors.primary.withOpacity(0.4),
                400: AppColors.primary.withOpacity(0.5),
                500: AppColors.primary.withOpacity(0.6),
                600: AppColors.primary.withOpacity(0.7),
                700: AppColors.primary.withOpacity(0.8),
                800: AppColors.primary.withOpacity(0.9),
                900: AppColors.primary.withOpacity(1.0),
              },
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(
                color: AppColors.black,
              ),
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: AppColors.transparent,
                statusBarIconBrightness: Brightness.dark,
              ),
            ),
            cupertinoOverrideTheme: const CupertinoThemeData(
              brightness: Brightness.light,
              primaryColor: AppColors.primary,
              textTheme: CupertinoTextThemeData(
                textStyle: TextStyle(
                  fontFamily: 'TTNorms',
                  color: AppColors.black,
                ),
              ),
            ),
          ),
          debugShowCheckedModeBanner: false,
          getPages: AppPage.routes,
          initialRoute: AppRoute.customerhome,
        );
      },
    );
  }
}
