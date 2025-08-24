import 'package:get/get.dart';
import '../controllers/step_controller.dart';

class StepBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StepController());
  }
}
