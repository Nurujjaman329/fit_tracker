import 'dart:developer';
import 'package:fit_tracker/core/config/app_colors.dart';
import 'package:fit_tracker/core/utils/error_handler.dart';
import 'package:get/get.dart';
import '../../../core/services/storage_service.dart';
import '../services/auth_service.dart';


class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  var isLoading = false.obs;

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      final token = await _authService.login(email, password);
      await StorageService.saveToken(token);

      Get.offAllNamed('/home');
      Get.snackbar(
        'Success',
        'Login successful',
        backgroundColor: AppColors.success.withOpacity(0.1),
        colorText: AppColors.success,
      );
    } catch (e) {
      final message = ErrorHandler.getFriendlyMessage(e);
      _showError(message);
      log('Login Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      isLoading.value = true;
      await _authService.register(name, email, password);

      Get.back(); // Return to login page
      Get.snackbar(
        'Success',
        'Registration successful, please login.',
        backgroundColor: AppColors.success.withOpacity(0.1),
        colorText: AppColors.success,
      );
    } catch (e) {
      final message = ErrorHandler.getFriendlyMessage(e);
      _showError(message);
      log('Register Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await StorageService.removeToken();
    Get.offAllNamed('/login');
    Get.snackbar(
      'Logged Out',
      'You have successfully logged out.',
      backgroundColor: AppColors.background.withOpacity(0.1),
      colorText: AppColors.textPrimary,
    );
  }

  Future<bool> checkLogin() async {
    final token = await StorageService.getToken();
    return token != null;
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: AppColors.error.withOpacity(0.1),
      colorText: AppColors.error,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }
}
