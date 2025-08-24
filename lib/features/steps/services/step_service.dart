import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';

class StepService {
  final Dio _dio = DioClient().client;

  Future<void> addStep(int stepCount) async {
    await _dio.post('/steps/add', data: {'stepCount': stepCount});
  }

  Future<List<dynamic>> getMySteps() async {
    final res = await _dio.get('/steps/my');
    return res.data['steps'];
  }

  Future<Map<String, dynamic>> getLeaderboard() async {
    final res = await _dio.get('/steps/leaderboard');
    return res.data;
  }
}
