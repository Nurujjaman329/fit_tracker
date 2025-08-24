import 'dart:developer';

import 'package:dio/dio.dart';
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
    } on DioException catch (e) {
      // DioException has useful info
      final status = e.response?.statusCode ?? 'No Status';
      final data = e.response?.data ?? e.message;
      Get.snackbar('Dio Error [$status]', data.toString());
      log('DioException Status: $status');
      log('DioException Response: $data');
    } catch (e) {
      Get.snackbar('Error', e.toString());
      log('General Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      isLoading.value = true;
      await _authService.register(name, email, password);
      Get.back(); // Go back to login
    } on DioException catch (e) {
      final status = e.response?.statusCode ?? 'No Status';
      final data = e.response?.data ?? e.message;
      Get.snackbar('Dio Error [$status]', data.toString());
      log('DioException Status: $status');
      log('DioException Response: $data');
    } catch (e) {
      Get.snackbar('Error', e.toString());
      log('General Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await StorageService.removeToken();
    Get.offAllNamed('/login');
  }

  Future<bool> checkLogin() async {
    final token = await StorageService.getToken();
    return token != null;
  }
}
