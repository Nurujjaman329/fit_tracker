import 'dart:developer';
import 'package:fit_tracker/core/config/app_colors.dart';
import 'package:fit_tracker/core/utils/error_handler.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pedometer/pedometer.dart';
import '../services/step_service.dart';

class StepController extends GetxController {
  final StepService _service = StepService();

  var stepCount = 0.obs;
  var lastStepCount = 0.obs;
  var dailyTarget = 5000.obs;

  var steps = <Map<String, dynamic>>[].obs;
  var leaderboard = <Map<String, dynamic>>[].obs;
  var position = 0.obs;

  var errorMessage = RxnString();

  late Stream<StepCount> _stepCountStream;

  bool get isTargetReached => stepCount.value >= dailyTarget.value;

  // Throttle backend updates
  int _lastSyncedSteps = 0;
  DateTime _lastSyncTime = DateTime.now();

  // Public observable for UI
  final lastSyncTime = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    _initTarget();
    _initStepCounter();
    getMySteps();
    getLeaderboard();
  }

  void _initTarget() {
    try {
      final prefs = Get.find<SharedPreferences>();
      dailyTarget.value = prefs.getInt('dailyTarget') ?? 5000;
    } catch (e) {
      _showError('Failed to load daily target');
      log('Target Init Error: $e');
    }
  }

  void _initStepCounter() async {
    try {
      final prefs = Get.find<SharedPreferences>();
      _stepCountStream = Pedometer.stepCountStream;

      _stepCountStream.listen((event) {
        final currentDate = DateTime.now().toIso8601String().substring(0, 10);
        final lastRecordedDate = prefs.getString('lastRecordedDate') ?? '';
        final lastRecordedSteps = prefs.getInt('lastRecordedSteps') ?? 0;

        if (lastRecordedDate != currentDate) {
          prefs.setString('lastRecordedDate', currentDate);
          prefs.setInt('lastRecordedSteps', event.steps);
          stepCount.value = 0;
          lastStepCount.value = event.steps;
        } else {
          stepCount.value = event.steps - lastRecordedSteps;
          lastStepCount.value = event.steps;
        }

        _maybeSyncSteps(stepCount.value);
      }).onError((error) {
        _showError(ErrorHandler.getFriendlyMessage(error));
        log('StepCount Stream Error: $error');
      });
    } catch (e) {
      _showError('Step counter initialization failed');
      log('Step Init Error: $e');
    }
  }

  /// Only sync if difference >= 50 steps OR 1 minute passed
  void _maybeSyncSteps(int currentSteps) {
    final now = DateTime.now();
    if ((currentSteps - _lastSyncedSteps >= 50) ||
        now.difference(_lastSyncTime).inMinutes >= 1) {
      _sendStepToBackend(currentSteps);
      _lastSyncedSteps = currentSteps;
      _lastSyncTime = now;
      lastSyncTime.value = now;
    }
  }

  // Public method for manual sync
  Future<void> syncSteps() async {
    await _sendStepToBackend(stepCount.value);
    lastSyncTime.value = DateTime.now();
  }

  void updateDailyTarget(int target) {
    try {
      dailyTarget.value = target;
      final prefs = Get.find<SharedPreferences>();
      prefs.setInt('dailyTarget', target);
      Get.snackbar(
        'Target Updated',
        'Daily step target updated to $target',
        backgroundColor: AppColors.success.withOpacity(0.1),
        colorText: AppColors.success,
      );
    } catch (e) {
      _showError('Failed to update daily target');
      log('Update Target Error: $e');
    }
  }

  Future<void> _sendStepToBackend(int count) async {
    try {
      // ✅ Send latest total to backend (overwrite today)
      await _service.addStep(count);

      // Refresh UI after backend sync
      await getMySteps();
      await getLeaderboard();
    } catch (e) {
      _showError(ErrorHandler.getFriendlyMessage(e));
      log('Send Step Error: $e');
    }
  }

  Future<void> getMySteps() async {
    try {
      final data = await _service.getMySteps();
      steps.value = List<Map<String, dynamic>>.from(data);
    } catch (e) {
      _showError(ErrorHandler.getFriendlyMessage(e));
      log('Get My Steps Error: $e');
    }
  }

  Future<void> getLeaderboard() async {
    try {
      final data = await _service.getLeaderboard();
      leaderboard.value = List<Map<String, dynamic>>.from(data['topUsers']);
      position.value = data['position'] ?? 0;
    } catch (e) {
      _showError(ErrorHandler.getFriendlyMessage(e));
      log('Get Leaderboard Error: $e');
    }
  }

  void _showError(String message) {
    if (message.isNotEmpty) {
      Get.snackbar(
        'Error',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error.withOpacity(0.1),
        colorText: AppColors.error,
        duration: const Duration(seconds: 3),
      );
    }
  }
}
