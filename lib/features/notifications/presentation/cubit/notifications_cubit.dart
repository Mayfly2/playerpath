import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playerpath/features/notifications/data/repositories/notifications_repository.dart';

abstract class NotificationsState {}
class NotificationsInitial extends NotificationsState {}
class NotificationsLoading extends NotificationsState {}
class NotificationsLoaded extends NotificationsState {
  final List<Map<String, dynamic>> notifications;
  NotificationsLoaded(this.notifications);
}
class NotificationsError extends NotificationsState {
  final String message;
  NotificationsError(this.message);
}

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepository _repo;

  NotificationsCubit(this._repo) : super(NotificationsInitial());

  Future<void> load() async {
    emit(NotificationsLoading());
    try {
      final data = await _repo.getNotifications();
      final list = List<Map<String, dynamic>>.from(
        data['notifications'] ?? data['items'] ?? [],
      );
      emit(NotificationsLoaded(list));
    } catch (e) {
      emit(NotificationsError('Could not load notifications.'));
    }
  }

  Future<void> markAllRead() async {
    try {
      await _repo.markAllRead();
      final current = state;
      if (current is NotificationsLoaded) {
        final updated = current.notifications.map((n) => {...n, 'isRead': true}).toList();
        emit(NotificationsLoaded(updated));
      }
    } catch (_) {}
  }
}
