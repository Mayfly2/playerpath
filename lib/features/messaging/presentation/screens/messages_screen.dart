import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playerpath/app/theme/colors.dart';
import 'package:playerpath/core/widgets/scout_widgets.dart';
import 'package:playerpath/features/messaging/presentation/cubit/messaging_cubit.dart';
import 'package:playerpath/features/messaging/data/repositories/messaging_repository.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MessagingCubit(MessagingRepository())..loadConversations(),
      child: const _MessagesBody(),
    );
  }
}

class _MessagesBody extends StatelessWidget {
  const _MessagesBody();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<MessagingCubit, MessagingState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Messages', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                      IconButton(
                        icon: const Icon(Icons.edit_square, color: AppColors.primary),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search conversations...',
                      prefixIcon: const Icon(Icons.search, color: AppColors.textTertiary),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      filled: true,
                      fillColor: isDark ? AppColors.darkInputFill : AppColors.inputFill,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: _buildContent(context, state),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, MessagingState state) {
    if (state is MessagingLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }
    if (state is MessagingError) {
      return Center(
        child: EmptyState(
          icon: Icons.cloud_off,
          title: 'Could not load messages',
          subtitle: state.message,
          actionLabel: 'Retry',
          onAction: () => context.read<MessagingCubit>().loadConversations(),
        ),
      );
    }
    if (state is MessagingLoaded && state.conversations.isEmpty) {
      return const EmptyState(
        icon: Icons.message_outlined,
        title: 'No messages yet',
        subtitle: 'When clubs message you, they\'ll appear here.',
      );
    }

    final conversations = state is MessagingLoaded ? state.conversations : <Map<String, dynamic>>[];
    return RefreshIndicator(
      onRefresh: () => context.read<MessagingCubit>().loadConversations(),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final c = conversations[index];
          final name = c['club'] is Map ? c['club']['email'] ?? 'Club' : 'Conversation';
          final lastMsg = c['lastMessageAt'] != null ? 'New message' : '';
          final unread = c['status'] == 'pending' ? 1 : 0;
          final hasUnread = unread > 0;

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            leading: Stack(
              children: [
                UserAvatar(radius: 26, initials: name.toString().substring(0, 2).toUpperCase()),
                Positioned(
                  right: -2, bottom: -2,
                  child: Container(
                    width: 16, height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.surface, width: 2),
                    ),
                    child: const Icon(Icons.shield, color: Colors.white, size: 9),
                  ),
                ),
              ],
            ),
            title: Text(name.toString(),
              style: TextStyle(
                fontWeight: hasUnread ? FontWeight.w800 : FontWeight.w600,
                fontSize: 14, color: AppColors.textPrimary,
              )),
            subtitle: Text(lastMsg, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13, color: hasUnread ? AppColors.textPrimary : AppColors.textSecondary)),
            trailing: hasUnread
                ? Container(
                    width: 20, height: 20,
                    decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                    child: Center(child: Text('$unread', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700))),
                  )
                : null,
            onTap: () {},
          );
        },
      ),
    );
  }
}
