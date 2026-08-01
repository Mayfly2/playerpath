import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playerpath/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:playerpath/core/storage/secure_storage.dart';
import 'package:playerpath/core/network/api_client.dart';
import 'package:playerpath/features/auth/domain/entities/user.dart';

// States
abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthAuthenticated extends AuthState {
  final User user;
  const AuthAuthenticated(this.user);
  @override
  List<Object?> get props => [user];
}
class AuthUnauthenticated extends AuthState {}
class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object?> get props => [message];
}

// Cubit
class AuthCubit extends Cubit<AuthState> {
  final AuthRepositoryImpl _authRepo;

  AuthCubit(this._authRepo) : super(AuthInitial());

  Future<void> checkAuth() async {
    final token = await SecureStorage.getAccessToken();
    if (token == null) {
      emit(AuthUnauthenticated());
      return;
    }

    // Validate token by fetching user profile
    try {
      final response = await ApiClient.dio.get('/users/me');
      final userData = response.data['data'];
      if (userData != null) {
        final user = User.fromJson(userData);
        emit(AuthAuthenticated(user));
      } else {
        await SecureStorage.clearTokens();
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      // Token invalid — try refresh
      await SecureStorage.clearTokens();
      emit(AuthUnauthenticated());
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final data = await _authRepo.login(email, password);
      await SecureStorage.setAccessToken(data['accessToken']);
      await SecureStorage.setRefreshToken(data['refreshToken']);
      final user = User.fromJson(data['user']);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(_parseError(e)));
    }
  }

  Future<void> signup(String email, String password, String userType, String fullName) async {
    emit(AuthLoading());
    try {
      final data = await _authRepo.signup(email, password, userType, fullName);
      await SecureStorage.setAccessToken(data['accessToken']);
      await SecureStorage.setRefreshToken(data['refreshToken']);
      final user = User.fromJson(data['user']);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(_parseError(e)));
    }
  }

  Future<void> logout() async {
    try {
      await _authRepo.logout();
    } catch (_) {}
    await SecureStorage.clearTokens();
    emit(AuthUnauthenticated());
  }

  String _parseError(dynamic e) {
    if (e is Exception) {
      final msg = e.toString();
      if (msg.contains('Invalid email or password')) return 'Invalid email or password';
      if (msg.contains('already registered')) return 'Email already registered';
      return 'Something went wrong. Please try again.';
    }
    return 'Network error. Please check your connection.';
  }
}
