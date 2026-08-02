import 'package:dio/dio.dart';
import '../storage/secure_storage.dart';

class ApiClient {
  // static const String baseUrl = 'http://10.0.2.2:3000/api/v1'; // Android emulator
  static const String baseUrl = 'http://192.168.1.169:3000/api/v1'; // Local network

  static final Dio dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  static Future<void> init() async {
    // Auth interceptor
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await SecureStorage.getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          // Try token refresh
          final refreshToken = await SecureStorage.getRefreshToken();
          if (refreshToken != null) {
            try {
              final response = await Dio().post(
                '$baseUrl/auth/refresh',
                data: {'refreshToken': refreshToken},
              );
              final newAccessToken = response.data['data']['accessToken'];
              final newRefreshToken = response.data['data']['refreshToken'];

              await SecureStorage.setAccessToken(newAccessToken);
              await SecureStorage.setRefreshToken(newRefreshToken);

              // Retry original request
              final opts = error.requestOptions;
              opts.headers['Authorization'] = 'Bearer $newAccessToken';
              final retryResponse = await Dio().fetch(opts);
              handler.resolve(retryResponse);
              return;
            } catch (_) {
              await SecureStorage.clearTokens();
            }
          }
        }
        handler.next(error);
      },
    ));
  }
}
