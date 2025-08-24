import 'package:fit_tracker/features/auth/controllers/auth_controller.dart';
import 'package:get/get.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // AuthController lives for the whole app
    Get.put<AuthController>(AuthController(), permanent: true);
  }
}