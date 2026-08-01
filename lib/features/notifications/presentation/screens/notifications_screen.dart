import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playerpath/app/theme/colors.dart';
import 'package:playerpath/core/widgets/scout_widgets.dart';
import 'package:playerpath/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:playerpath/features/notifications/data/repositories/notifications_repository.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationsCubit(NotificationsRepository())..load(),
      child: const _NotificationsBody(),
    );
  }
}

class _NotificationsBody extends StatelessWidget {
  const _NotificationsBody();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<NotificationsCubit, NotificationsState>(
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
                      Text('Notifications',
                        style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                      TextButton(
                        onPressed: () => context.read<NotificationsCubit>().markAllRead(),
                        style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                        child: const Text('Mark all read', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Expanded(child: _buildContent(context, state)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, NotificationsState state) {
    if (state is NotificationsLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }
    if (state is NotificationsError) {
      return Center(
        child: EmptyState(
          icon: Icons.cloud_off,
          title: 'Could not load notifications',
          subtitle: state.message,
          actionLabel: 'Retry',
          onAction: () => context.read<NotificationsCubit>().load(),
        ),
      );
    }
    if (state is NotificationsLoaded && state.notifications.isEmpty) {
      return const EmptyState(
        icon: Icons.notifications_none,
        title: 'No notifications',
        subtitle: 'You\'ll see alerts about clubs, messages, and trials here.',
      );
    }

    final notifications = state is NotificationsLoaded ? state.notifications : <Map<String, dynamic>>[];
    return RefreshIndicator(
      onRefresh: () => context.read<NotificationsCubit>().load(),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final n = notifications[index];
          final isNew = n['isRead'] != true;
          final icon = _iconForType(n['type'] as String?);
          final title = n['title'] ?? n['message'] ?? 'Notification';
          final body = n['body'] ?? n['message'] ?? '';
          final time = _formatTime(n['createdAt'] as String?);

          return Container(
            margin: const EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(
              color: isNew
                  ? AppColors.primary.withValues(alpha: 0.03)
                  : (isNew ? AppColors.surface : AppColors.surface),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isNew ? AppColors.primary.withValues(alpha: 0.15) : AppColors.border,
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              leading: Container(
                width: 46, height: 46,
                decoration: BoxDecoration(
                  color: isNew ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surfaceAlt,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: isNew ? AppColors.primary : AppColors.textTertiary, size: 22),
              ),
              title: Text(title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isNew ? FontWeight.w700 : FontWeight.w600,
                  color: AppColors.textPrimary,
                )),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 2),
                  Text(body, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary), maxLines: 2),
                  const SizedBox(height: 4),
                  Text(time, style: const TextStyle(fontSize: 11, color: AppColors.textTertiary)),
                ],
              ),
              trailing: isNew
                  ? Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle))
                  : null,
              onTap: () {},
            ),
          );
        },
      ),
    );
  }

  IconData _iconForType(String? type) {
    return switch (type) {
      'message' => Icons.message_outlined,
      'trial' => Icons.emoji_events_outlined,
      'save' => Icons.bookmark_added,
      'view' => Icons.visibility_outlined,
      'match' => Icons.trending_up,
      _ => Icons.notifications_outlined,
    };
  }

  String _formatTime(String? timestamp) {
    if (timestamp == null) return '';
    try {
      final dt = DateTime.parse(timestamp);
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inMinutes < 1) return 'Just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return '';
    }
  }
}
