import 'package:get/get.dart';
import '../services/step_service.dart';

class StepController extends GetxController {
  final StepService _service = StepService();
  var isLoading = false.obs;
  var steps = <Map<String, dynamic>>[].obs;
  var leaderboard = <Map<String, dynamic>>[].obs;
  var position = 0.obs;

  Future<void> addStep(int stepCount) async {
    try {
      isLoading.value = true;
      await _service.addStep(stepCount);
      await getMySteps();
      await getLeaderboard();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getMySteps() async {
    final data = await _service.getMySteps();
    steps.value = List<Map<String, dynamic>>.from(data);
  }

  Future<void> getLeaderboard() async {
    final data = await _service.getLeaderboard();
    leaderboard.value = List<Map<String, dynamic>>.from(data['topUsers']);
    position.value = data['position'] ?? 0;
  }
}
