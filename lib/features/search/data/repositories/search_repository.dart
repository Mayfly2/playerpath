import 'package:dio/dio.dart';
import 'package:playerpath/core/network/api_client.dart';
import 'package:playerpath/core/network/api_endpoints.dart';

class SearchRepository {
  final Dio _dio = ApiClient.dio;

  Future<Map<String, dynamic>> searchPlayers({
    String? position,
    int? ageMin,
    int? ageMax,
    int? currentStep,
    String? county,
    String? sort,
    int page = 1,
    int limit = 20,
  }) async {
    final params = <String, dynamic>{'page': page, 'limit': limit};
    if (position != null && position.isNotEmpty) params['position'] = position;
    if (ageMin != null) params['ageMin'] = ageMin;
    if (ageMax != null) params['ageMax'] = ageMax;
    if (currentStep != null) params['currentStep'] = currentStep;
    if (county != null) params['county'] = county;
    if (sort != null) params['sort'] = sort;

    final response = await _dio.get(ApiEndpoints.searchPlayers, queryParameters: params);
    return response.data;
  }

  Future<Map<String, dynamic>> searchClubs({
    String? league,
    int? step,
    bool? hasTrials,
    String? sort,
    int page = 1,
    int limit = 20,
  }) async {
    final params = <String, dynamic>{'page': page, 'limit': limit};
    if (league != null) params['league'] = league;
    if (step != null) params['step'] = step;
    if (hasTrials != null) params['hasTrials'] = hasTrials;
    if (sort != null) params['sort'] = sort;

    final response = await _dio.get(ApiEndpoints.searchClubs, queryParameters: params);
    return response.data;
  }
}
