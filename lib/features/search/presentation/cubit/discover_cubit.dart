import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playerpath/features/search/data/repositories/search_repository.dart';

// States
abstract class DiscoverState extends Equatable {
  const DiscoverState();
  @override
  List<Object?> get props => [];
}

class DiscoverInitial extends DiscoverState {}
class DiscoverLoading extends DiscoverState {}
class DiscoverLoaded extends DiscoverState {
  final List<Map<String, dynamic>> players;
  final List<Map<String, dynamic>> clubs;
  final bool hasMorePlayers;
  final bool hasMoreClubs;
  final int playerPage;
  final int clubPage;
  final String? errorMessage;

  const DiscoverLoaded({
    this.players = const [],
    this.clubs = const [],
    this.hasMorePlayers = true,
    this.hasMoreClubs = true,
    this.playerPage = 1,
    this.clubPage = 1,
    this.errorMessage,
  });

  DiscoverLoaded copyWith({
    List<Map<String, dynamic>>? players,
    List<Map<String, dynamic>>? clubs,
    bool? hasMorePlayers,
    bool? hasMoreClubs,
    int? playerPage,
    int? clubPage,
    String? errorMessage,
  }) {
    return DiscoverLoaded(
      players: players ?? this.players,
      clubs: clubs ?? this.clubs,
      hasMorePlayers: hasMorePlayers ?? this.hasMorePlayers,
      hasMoreClubs: hasMoreClubs ?? this.hasMoreClubs,
      playerPage: playerPage ?? this.playerPage,
      clubPage: clubPage ?? this.clubPage,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [players, clubs, hasMorePlayers, hasMoreClubs, playerPage, clubPage, errorMessage];
}

class DiscoverError extends DiscoverState {
  final String message;
  const DiscoverError(this.message);
  @override
  List<Object?> get props => [message];
}

// Cubit
class DiscoverCubit extends Cubit<DiscoverState> {
  final SearchRepository _searchRepo;

  DiscoverCubit(this._searchRepo) : super(DiscoverInitial());

  Future<void> loadPlayers({bool refresh = false}) async {
    final currentState = state;
    final page = refresh ? 1 : (currentState is DiscoverLoaded ? currentState.playerPage : 1);

    if (currentState is DiscoverLoaded && !refresh) {
      emit(currentState.copyWith(errorMessage: null));
    } else {
      emit(DiscoverLoading());
    }

    try {
      final data = await _searchRepo.searchPlayers(page: page);
      final players = List<Map<String, dynamic>>.from(data['data']['players'] ?? []);
      final meta = data['data']['meta'] ?? {};
      final totalPages = meta['pages'] as int? ?? 1;

      if (currentState is DiscoverLoaded && !refresh) {
        emit(currentState.copyWith(
          players: [...currentState.players, ...players],
          hasMorePlayers: page < totalPages,
          playerPage: page + 1,
        ));
      } else {
        emit(DiscoverLoaded(
          players: players,
          hasMorePlayers: page < totalPages,
          playerPage: page + 1,
        ));
      }
    } catch (e) {
      if (currentState is DiscoverLoaded) {
        emit(currentState.copyWith(errorMessage: 'Failed to load players. Pull to retry.'));
      } else {
        emit(const DiscoverError('Failed to load players. Check your connection.'));
      }
    }
  }

  Future<void> loadClubs({bool refresh = false}) async {
    final currentState = state;
    final page = refresh ? 1 : (currentState is DiscoverLoaded ? currentState.clubPage : 1);

    if (currentState is DiscoverLoaded && !refresh) {
      emit(currentState.copyWith(errorMessage: null));
    } else if (state is! DiscoverLoaded) {
      emit(DiscoverLoading());
    }

    try {
      final data = await _searchRepo.searchClubs(page: page);
      final clubs = List<Map<String, dynamic>>.from(data['data']['clubs'] ?? []);
      final meta = data['data']['meta'] ?? {};
      final totalPages = meta['pages'] as int? ?? 1;

      if (currentState is DiscoverLoaded && !refresh) {
        emit(currentState.copyWith(
          clubs: [...currentState.clubs, ...clubs],
          hasMoreClubs: page < totalPages,
          clubPage: page + 1,
        ));
      } else if (currentState is DiscoverLoaded) {
        emit(currentState.copyWith(
          clubs: clubs,
          hasMoreClubs: page < totalPages,
          clubPage: page + 1,
        ));
      } else {
        // Preserve any existing players if we loaded them first
        final existingPlayers = currentState is DiscoverLoaded ? currentState.players : <Map<String, dynamic>>[];
        emit(DiscoverLoaded(
          players: existingPlayers,
          clubs: clubs,
          hasMoreClubs: page < totalPages,
          clubPage: page + 1,
        ));
      }
    } catch (e) {
      if (currentState is DiscoverLoaded) {
        emit(currentState.copyWith(errorMessage: 'Failed to load clubs. Pull to retry.'));
      } else {
        emit(const DiscoverError('Failed to load clubs. Check your connection.'));
      }
    }
  }

  Future<void> loadAll() async {
    emit(DiscoverLoading());
    try {
      final playersData = await _searchRepo.searchPlayers();
      final clubsData = await _searchRepo.searchClubs();

      final players = List<Map<String, dynamic>>.from(playersData['data']['players'] ?? []);
      final clubs = List<Map<String, dynamic>>.from(clubsData['data']['clubs'] ?? []);
      final playersMeta = playersData['data']['meta'] ?? {};
      final clubsMeta = clubsData['data']['meta'] ?? {};

      emit(DiscoverLoaded(
        players: players,
        clubs: clubs,
        hasMorePlayers: 1 < (playersMeta['pages'] as int? ?? 1),
        hasMoreClubs: 1 < (clubsMeta['pages'] as int? ?? 1),
        playerPage: 2,
        clubPage: 2,
      ));
    } catch (e) {
      emit(const DiscoverError('Failed to load data. Check your connection.'));
    }
  }
}
