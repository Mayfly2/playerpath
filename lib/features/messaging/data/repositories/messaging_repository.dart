import 'dart:async';
import 'package:dio/dio.dart';
import 'package:playerpath/core/network/api_client.dart';
import 'package:playerpath/core/network/api_endpoints.dart';

class MessagingRepository {
  final Dio _dio = ApiClient.dio;
  Timer? _pollTimer;

  Future<Map<String, dynamic>> getConversations() async {
    final response = await _dio.get(ApiEndpoints.conversations);
    return response.data['data'] ?? response.data;
  }

  Future<Map<String, dynamic>> getConversation(String id) async {
    final response = await _dio.get(ApiEndpoints.conversation(id));
    return response.data['data'] ?? response.data;
  }

  Future<Map<String, dynamic>> getMessages(String conversationId) async {
    final response = await _dio.get(ApiEndpoints.messages(conversationId));
    return response.data['data'] ?? response.data;
  }

  Future<void> sendMessage(String conversationId, String content, {String type = 'text'}) async {
    await _dio.post(
      ApiEndpoints.messages(conversationId),
      data: {'content': content, 'type': type},
    );
  }

  Future<void> markRead(String conversationId) async {
    await _dio.patch(ApiEndpoints.markRead(conversationId));
  }

  Future<void> sendInvite(Map<String, dynamic> data) async {
    await _dio.post(ApiEndpoints.sendInvite, data: data);
  }

  Future<void> acceptInvite(String id) async {
    await _dio.patch(ApiEndpoints.acceptInvite(id));
  }

  Future<void> rejectInvite(String id) async {
    await _dio.patch(ApiEndpoints.rejectInvite(id));
  }

  void dispose() {
    _pollTimer?.cancel();
  }
}
