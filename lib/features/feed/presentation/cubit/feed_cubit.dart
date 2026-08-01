import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playerpath/features/feed/data/repositories/feed_repository.dart';

// States
abstract class FeedState {}
class FeedInitial extends FeedState {}
class FeedLoading extends FeedState {}
class FeedLoaded extends FeedState {
  final List<Map<String, dynamic>> nearbyClubs;
  final List<Map<String, dynamic>> clubsWithTrials;
  final List<Map<String, dynamic>> suggestedClubs;
  final List<Map<String, dynamic>> nearbyPlayers;
  final List<Map<String, dynamic>> trendingPlayers;

  FeedLoaded({
    this.nearbyClubs = const [],
    this.clubsWithTrials = const [],
    this.suggestedClubs = const [],
    this.nearbyPlayers = const [],
    this.trendingPlayers = const [],
  });

  bool get hasData =>
      nearbyClubs.isNotEmpty ||
      clubsWithTrials.isNotEmpty ||
      nearbyPlayers.isNotEmpty;
}
class FeedError extends FeedState {
  final String message;
  FeedError(this.message);
}

class FeedCubit extends Cubit<FeedState> {
  final FeedRepository _repo;

  FeedCubit(this._repo) : super(FeedInitial());

  Future<void> loadFeed() async {
    emit(FeedLoading());
    try {
      final data = await _repo.getFeed();
      emit(FeedLoaded(
        nearbyClubs: List<Map<String, dynamic>>.from(data['nearbyClubs'] ?? []),
        clubsWithTrials: List<Map<String, dynamic>>.from(data['clubsWithTrials'] ?? []),
        suggestedClubs: List<Map<String, dynamic>>.from(data['suggestedClubs'] ?? []),
        nearbyPlayers: List<Map<String, dynamic>>.from(data['nearbyPlayers'] ?? []),
        trendingPlayers: List<Map<String, dynamic>>.from(data['trendingPlayers'] ?? []),
      ));
    } catch (e) {
      emit(FeedError(_parseError(e)));
    }
  }

  String _parseError(dynamic e) {
    if (e is Exception) {
      final msg = e.toString();
      if (msg.contains('401')) return 'Please log in again.';
      return 'Could not load feed. Pull to refresh.';
    }
    return 'Network error. Check your connection.';
  }
}
