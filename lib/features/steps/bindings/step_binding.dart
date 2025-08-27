import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/step_controller.dart';

class StepBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize SharedPreferences asynchronously
    Get.putAsync<SharedPreferences>(() async {
      return await SharedPreferences.getInstance();
    });
    
    // Lazy put the controller
    Get.lazyPut<StepController>(() => StepController());
  }
}