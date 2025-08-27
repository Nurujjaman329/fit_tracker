import 'package:dio/dio.dart';

class ErrorHandler {
  /// Converts Dio or general exceptions into user-friendly messages
  static String getFriendlyMessage(dynamic error) {
    if (error is DioException) {
      // Network issues
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        return 'Request timed out. Please check your internet connection.';
      }

      // HTTP status codes
      final status = error.response?.statusCode ?? 0;
      switch (status) {
        case 400:
          return 'Invalid request. Please check your input.';
        case 401:
          return 'Unauthorized. Please login again.';
        case 403:
          return 'Access denied.';
        case 404:
          return 'Resource not found.';
        case 422:
          // Example: validation errors
          final data = error.response?.data;
          if (data != null && data['message'] != null) {
            return data['message'];
          }
          return 'Invalid data. Please check and try again.';
        case 500:
          return 'Server error. Please try again later.';
        default:
          return 'Something went wrong. Please try again.';
      }
    }

    // Non-Dio exceptions fallback
    return 'An unexpected error occurred. Please try again.';
  }
}
