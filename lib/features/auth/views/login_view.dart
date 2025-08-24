import 'package:fit_tracker/core/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import 'register_view.dart';

class LoginView extends StatelessWidget {
  final AuthController authController = Get.find();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Obx(() => authController.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                      controller: emailCtrl,
                      decoration: const InputDecoration(labelText: 'Email')),
                  TextField(
                      controller: passCtrl,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true),
                  const SizedBox(height: 20),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.buttonText,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () =>
                          authController.login(emailCtrl.text, passCtrl.text),
                      child: const Text('Login')),
                  TextButton(
                      onPressed: () => Get.to(() => RegisterView()),
                      child: const Text('Register'))
                ],
              ),
            )),
    );
  }
}
