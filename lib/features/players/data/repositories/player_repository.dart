import 'package:dio/dio.dart';
import 'package:playerpath/core/network/api_client.dart';
import 'package:playerpath/core/network/api_endpoints.dart';

class PlayerRepository {
  final Dio _dio = ApiClient.dio;

  Future<Map<String, dynamic>> getOwnProfile() async {
    final response = await _dio.get(ApiEndpoints.playerProfile);
    return response.data['data'];
  }

  Future<Map<String, dynamic>> getPlayerById(String id) async {
    final response = await _dio.get(ApiEndpoints.playerById(id));
    return response.data['data'];
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    await _dio.patch(ApiEndpoints.playerProfile, data: data);
  }

  Future<void> updateStatistics(Map<String, dynamic> data) async {
    await _dio.put(ApiEndpoints.playerStatistics, data: data);
  }

  Future<void> addClubHistory(Map<String, dynamic> data) async {
    await _dio.post(ApiEndpoints.playerClubHistory, data: data);
  }

  Future<void> removeClubHistory(String id) async {
    await _dio.delete('${ApiEndpoints.playerClubHistory}/$id');
  }
}

class ClubRepository {
  final Dio _dio = ApiClient.dio;

  Future<Map<String, dynamic>> getOwnProfile() async {
    final response = await _dio.get(ApiEndpoints.clubProfile);
    return response.data['data'];
  }

  Future<Map<String, dynamic>> getClubById(String id) async {
    final response = await _dio.get(ApiEndpoints.clubById(id));
    return response.data['data'];
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    await _dio.patch(ApiEndpoints.clubProfile, data: data);
  }
}
