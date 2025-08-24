import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'features/routes/app_pages.dart';
import 'core/services/storage_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      initialRoute: initialRoute,
      getPages: AppPages.pages,
    );
  }
}
