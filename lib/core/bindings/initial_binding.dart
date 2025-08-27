import 'package:fit_tracker/features/auth/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // AuthController lives for the whole app
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<SharedPreferences>(Get.find<SharedPreferences>(), permanent: true);

  }
}