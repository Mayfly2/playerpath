import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playerpath/features/messaging/data/repositories/messaging_repository.dart';

abstract class MessagingState {}
class MessagingInitial extends MessagingState {}
class MessagingLoading extends MessagingState {}
class MessagingLoaded extends MessagingState {
  final List<Map<String, dynamic>> conversations;
  MessagingLoaded(this.conversations);
}
class MessagingError extends MessagingState {
  final String message;
  MessagingError(this.message);
}

class MessagingCubit extends Cubit<MessagingState> {
  final MessagingRepository _repo;

  MessagingCubit(this._repo) : super(MessagingInitial());

  Future<void> loadConversations() async {
    emit(MessagingLoading());
    try {
      final data = await _repo.getConversations();
      final conversations = List<Map<String, dynamic>>.from(
        data['conversations'] ?? data['items'] ?? [],
      );
      emit(MessagingLoaded(conversations));
    } catch (e) {
      emit(MessagingError('Could not load messages.'));
    }
  }
}
