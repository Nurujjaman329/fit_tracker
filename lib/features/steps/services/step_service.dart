import 'dart:developer';
import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';

class StepService {
  final Dio _dio = DioClient().client;

  Future<void> addStep(int stepCount) async {
    const endpoint = '/steps/add';
    final data = {'stepCount': stepCount};

    try {
      log('[StepService] POST $endpoint, data: $data');
      final res = await _dio.post(endpoint, data: data);
      log('[StepService] Response: ${res.statusCode} | ${res.data}');
    } catch (e) {
      log('[StepService] Error POST $endpoint: $e');
      rethrow;
    }
  }

  Future<List<dynamic>> getMySteps() async {
    const endpoint = '/steps/my';
    try {
      log('[StepService] GET $endpoint');
      final res = await _dio.get(endpoint);
      log('[StepService] Response: ${res.statusCode} | ${res.data}');
      return res.data['steps'];
    } catch (e) {
      log('[StepService] Error GET $endpoint: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getLeaderboard() async {
    const endpoint = '/steps/leaderboard';
    try {
      log('[StepService] GET $endpoint');
      final res = await _dio.get(endpoint);
      log('[StepService] Response: ${res.statusCode} | ${res.data}');
      // Backend now returns { topUsers: [...], position: number }
      return {
        'topUsers': res.data['topUsers'] ?? [],
        'position': res.data['position'] ?? 0,
      };
    } catch (e) {
      log('[StepService] Error GET $endpoint: $e');
      rethrow;
    }
  }
}

