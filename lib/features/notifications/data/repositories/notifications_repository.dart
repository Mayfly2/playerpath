import 'package:dio/dio.dart';
import 'package:playerpath/core/network/api_client.dart';

class NotificationsRepository {
  final Dio _dio = ApiClient.dio;

  Future<Map<String, dynamic>> getNotifications() async {
    final response = await _dio.get('/notifications');
    return response.data['data'] ?? response.data;
  }

  Future<void> markRead(String id) async {
    await _dio.patch('/notifications/$id/read');
  }

  Future<void> markAllRead() async {
    await _dio.patch('/notifications/read-all');
  }

  Future<void> updatePreferences(Map<String, dynamic> data) async {
    await _dio.put('/notifications/preferences', data: data);
  }
}
