import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';

class AuthService {
  final Dio _dio = DioClient().client;

  Future<String> login(String email, String password) async {
    final res = await _dio.post('/auth/login', data: {'email': email, 'password': password});
    return res.data['token'];
  }

  Future<void> register(String name, String email, String password) async {
    await _dio.post('/auth/register', data: {'name': name, 'email': email, 'password': password});
  }
}
