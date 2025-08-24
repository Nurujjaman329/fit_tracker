import 'package:get/get.dart';
import '../controllers/step_controller.dart';

class StepBinding extends Bindings {
  @override
  void dependencies() {
    // Lazy put the controller when needed
    Get.lazyPut<StepController>(() => StepController());
  }
}
