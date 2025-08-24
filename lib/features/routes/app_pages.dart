import 'package:get/get.dart';
import '../auth/views/login_view.dart';
import '../auth/views/register_view.dart';
import '../auth/bindings/auth_binding.dart';
import '../steps/views/step_home_view.dart';
import '../steps/bindings/step_binding.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: '/login',
      page: () => LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: '/register',
      page: () => RegisterView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: '/home',
      page: () => StepHomeView(),
      binding: StepBinding(),
    ),
  ];
}
