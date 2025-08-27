import 'package:fit_tracker/core/bindings/initial_binding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/routes/app_pages.dart';
import 'core/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // Inject into GetX so controllers can use Get.find<SharedPreferences>()
  Get.put<SharedPreferences>(prefs);

  // Load token
  final token = await StorageService.getToken();

  runApp(MyApp(initialRoute: token != null ? '/home' : '/login'));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Health Tracker',
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(), // <-- still keeps AuthController etc.
      initialRoute: initialRoute,
      getPages: AppPages.pages,
    );
  }
}
