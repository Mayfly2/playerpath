import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playerpath/features/players/data/repositories/player_repository.dart';

abstract class ProfileState {}
class ProfileInitial extends ProfileState {}
class ProfileLoading extends ProfileState {}
class ProfileLoaded extends ProfileState {
  final Map<String, dynamic> player;
  final Map<String, dynamic>? club;
  ProfileLoaded(this.player, {this.club});
}
class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

class ProfileCubit extends Cubit<ProfileState> {
  final PlayerRepository _playerRepo;

  ProfileCubit(this._playerRepo) : super(ProfileInitial());

  Future<void> loadProfile(String userType) async {
    emit(ProfileLoading());
    try {
      final player = await _playerRepo.getOwnProfile();
      emit(ProfileLoaded(player));
    } catch (e) {
      // Fall back to empty profile if not created yet
      emit(ProfileLoaded({}));
    }
  }
}
