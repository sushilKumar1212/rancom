import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:thecourierapp/App/Constants/constant_heplers.dart';

import '../../Utils/app_page_routes.dart';

class CustomerProfileController extends GetxController {
  String token = '';

  @override
  void onInit() {
    super.onInit();
    if (GetStorage().hasData('user') && GetStorage().read('user')) {
      token = GetStorage().read('token');
    }
  }

  bool get isUserLoggedIn => token.isNotEmpty;

  void logout() async {
    showLoading();
    await GetStorage().remove('user');
    await GetStorage().remove('token');
    Get.offAllNamed(AppRoute.loginSelection);
  }
}
