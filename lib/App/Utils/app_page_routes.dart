import 'package:get/get.dart';
import 'package:thecourierapp/App/Customer/Login/customer_login.dart';
import 'package:thecourierapp/App/Customer/PostJob/post_job_module.dart';
import 'package:thecourierapp/App/Driver/ChangePassword/change_password_page.dart';
import 'package:thecourierapp/App/Driver/CompleteProfile/profile_complete_module.dart';
import 'package:thecourierapp/App/Driver/Home/home_page.dart';
import 'package:thecourierapp/App/Driver/Home/login_selection.dart';
import 'package:thecourierapp/App/Driver/Jobs/new_job_request_page.dart';
import 'package:thecourierapp/App/Driver/JoinUsModule/join_us_module.dart';
import 'package:thecourierapp/App/Driver/Notifications/notificaion_page.dart';
import 'package:thecourierapp/App/Driver/OnBoard/on_boarding_page.dart';
import 'package:thecourierapp/App/Driver/Profile/profile_page.dart';

import '../Customer/Home/customer_home_page.dart';
import '../Driver/ForgotPassword/forgot_password_page.dart';
import '../Driver/Login/login_page.dart';
import '../Driver/Splash/splash_screen.dart';

class AppPage {
  static const initial = '/';
  static const loginSelection = '/loginselection';
  static const joinUsModule = '/joinus';
  static const onboard = '/onboard';
  static const home = '/home';
  static const login = '/login';
  static const forgotpassword = '/forgotpassword';
  static const completeProfile = '/completeprofile';
  static const notification = '/notification';
  static const personalprofile = '/personalprofile';
  static const changepassword = '/changepassword';
  static const newjobrequest = '/newjobrequest';

  // Custom Routes
  static const customerlogin = '/customerlogin';
  static const customerhome = '/customerhome';
  static const customerPostJob = '/customerpostjob';

  static final routes = [
    GetPage(
      name: initial,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: loginSelection,
      page: () => const LoginSelectionPage(),
    ),
    GetPage(
      name: joinUsModule,
      page: () => const JoinUsModule(),
    ),
    GetPage(
      name: onboard,
      page: () => const OnBoardPage(),
    ),
    GetPage(
      name: home,
      page: () => const HomePage(),
    ),
    GetPage(
      name: login,
      page: () => const LoginPage(),
    ),

    GetPage(
      name: forgotpassword,
      page: () => const ForgotPasswordPage(),
    ),
    GetPage(
      name: completeProfile,
      page: () => const CompleteProfileModule(),
    ),
    GetPage(
      name: notification,
      page: () => const NotificationPage(),
    ),
    GetPage(
      name: personalprofile,
      page: () => const PersonalProfilePage(),
    ),
    GetPage(
      name: changepassword,
      page: () => const ChangePasswordPage(),
    ),
    GetPage(
      name: newjobrequest,
      page: () => const NewJobRequestPage(),
    ),

    //Customer Routes
    GetPage(
      name: customerlogin,
      page: () => const CustomeLogin(),
    ),
    GetPage(
      name: customerhome,
      page: () => const CustomerHomePage(),
    ),
    GetPage(
      name: customerPostJob,
      page: () => const PostJobModule(),
    ),
  ];
}

class AppRoute {
  static const initial = AppPage.initial;
  static const loginSelection = AppPage.loginSelection;
  static const joinUsModule = AppPage.joinUsModule;
  static const onboard = AppPage.onboard;
  static const home = AppPage.home;
  static const login = AppPage.login;
  static const forgotpassword = AppPage.forgotpassword;
  static const completeProfile = AppPage.completeProfile;
  static const notification = AppPage.notification;
  static const personalprofile = AppPage.personalprofile;
  static const changepassword = AppPage.changepassword;
  static const newjobrequest = AppPage.newjobrequest;

  //Customer Routes
  static const customerlogin = AppPage.customerlogin;
  static const customerhome = AppPage.customerhome;
  static const customerPostJob = AppPage.customerPostJob;
}
