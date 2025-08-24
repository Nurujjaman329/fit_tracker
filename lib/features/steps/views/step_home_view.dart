import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/step_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../core/config/app_colors.dart';

class StepHomeView extends StatelessWidget {
  final StepController stepController = Get.find();
  final AuthController authController = Get.find();
  final TextEditingController stepInput = TextEditingController();

  StepHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    stepController.getMySteps();
    stepController.getLeaderboard();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Health Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.buttonText),
            onPressed: () => authController.logout(),
          )
        ],
      ),
      body: Obx(() => stepController.isLoading.value
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: stepInput,
                    decoration: InputDecoration(
                      labelText: 'Add Step Count',
                      filled: true,
                      fillColor: AppColors.card,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.button,
                      foregroundColor: AppColors.buttonText,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      final count = int.tryParse(stepInput.text) ?? 0;
                      stepController.addStep(count);
                      stepInput.clear();
                    },
                    child: const Text('Add Steps', style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(height: 20),
                  const Text('My Steps', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontSize: 18)),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: stepController.steps.length,
                    itemBuilder: (_, index) {
                      final step = stepController.steps[index];
                      return Card(
                        color: AppColors.card,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          title: Text('${step['date']}', style: const TextStyle(color: AppColors.textPrimary)),
                          trailing: Text('${step['stepCount']} steps', style: const TextStyle(color: AppColors.secondary)),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text('Leaderboard (Top 10)', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontSize: 18)),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: stepController.leaderboard.length,
                    itemBuilder: (_, index) {
                      final user = stepController.leaderboard[index];
                      return Card(
                        color: AppColors.card,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(backgroundColor: AppColors.secondary, child: Text('${index + 1}')),
                          title: Text('${user['name']}', style: const TextStyle(color: AppColors.textPrimary)),
                          trailing: Text('${user['stepCount']} steps', style: const TextStyle(color: AppColors.primary)),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  Text('My Position: ${stepController.position.value}', style: const TextStyle(fontSize: 16, color: AppColors.accent)),
                ],
              ),
            )),
    );
  }
}
