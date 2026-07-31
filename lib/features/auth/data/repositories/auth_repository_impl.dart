import 'package:dio/dio.dart';
import 'package:playerpath/core/network/api_client.dart';
import 'package:playerpath/core/network/api_endpoints.dart';

abstract class AuthRepository {
  Future<Map<String, dynamic>> login(String email, String password);
  Future<Map<String, dynamic>> signup(String email, String password, String userType, String fullName);
  Future<Map<String, dynamic>> googleAuth(String idToken, String userType);
  Future<Map<String, dynamic>> appleAuth(String identityToken, String userType);
  Future<void> logout();
}

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio = ApiClient.dio;

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _dio.post(ApiEndpoints.login, data: {
      'email': email,
      'password': password,
    });
    return response.data['data'];
  }

  @override
  Future<Map<String, dynamic>> signup(
    String email, String password, String userType, String fullName) async {
    final response = await _dio.post(ApiEndpoints.signup, data: {
      'email': email,
      'password': password,
      'userType': userType,
      'fullName': fullName,
    });
    return response.data['data'];
  }

  @override
  Future<Map<String, dynamic>> googleAuth(String idToken, String userType) async {
    final response = await _dio.post(ApiEndpoints.google, data: {
      'idToken': idToken,
      'userType': userType,
    });
    return response.data['data'];
  }

  @override
  Future<Map<String, dynamic>> appleAuth(String identityToken, String userType) async {
    final response = await _dio.post(ApiEndpoints.apple, data: {
      'identityToken': identityToken,
      'userType': userType,
    });
    return response.data['data'];
  }

  @override
  Future<void> logout() async {
    await _dio.post(ApiEndpoints.logout);
  }
}
