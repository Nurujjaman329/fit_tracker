import 'package:dio/dio.dart';
import 'package:fit_tracker/core/services/storage_service.dart';

class DioClient {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://192.168.0.235:5000/api'));

  DioClient() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await StorageService.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  Dio get client => _dio;
}
