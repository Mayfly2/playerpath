import 'package:dio/dio.dart';
import 'package:playerpath/core/network/api_client.dart';
import 'package:playerpath/core/network/api_endpoints.dart';

class FeedRepository {
  final Dio _dio = ApiClient.dio;

  Future<Map<String, dynamic>> getFeed() async {
    final response = await _dio.get(ApiEndpoints.feed);
    return response.data['data'] ?? response.data;
  }
}
