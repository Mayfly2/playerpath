import 'package:flutter/material.dart';
import 'package:playerpath/app/theme/colors.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final notifications = [
      {'icon': Icons.message_outlined, 'title': 'New message from FC United', 'body': 'Would you like to come for a trial next week?', 'time': '2 min ago', 'new': true, 'type': 'message'},
      {'icon': Icons.visibility_outlined, 'title': 'Profile viewed by 3 clubs', 'body': 'Stockport County, Altrincham FC & Macclesfield viewed your profile', 'time': '1 hour ago', 'new': true, 'type': 'view'},
      {'icon': Icons.emoji_events_outlined, 'title': 'Trial invitation received', 'body': 'Bury FC invited you to an open trial on July 28th', 'time': '3 hours ago', 'new': true, 'type': 'trial'},
      {'icon': Icons.bookmark_added, 'title': 'Stockport County saved your profile', 'body': 'They added you to their shortlist for the upcoming season', 'time': 'Yesterday', 'new': true, 'type': 'save'},
      {'icon': Icons.check_circle_outlined, 'title': 'Application accepted', 'body': 'FC Halifax Town accepted your trial application', 'time': '2 days ago', 'new': false, 'type': 'accept'},
      {'icon': Icons.person_add, 'title': 'New follower', 'body': 'Coach Williams started following your profile', 'time': '3 days ago', 'new': false, 'type': 'follow'},
      {'icon': Icons.trending_up, 'title': 'Profile trending', 'body': 'Your profile is trending in Greater Manchester this week', 'time': '4 days ago', 'new': false, 'type': 'trend'},
      {'icon': Icons.videocam_outlined, 'title': 'New highlight uploaded', 'body': 'Your hat-trick video reached 500 views', 'time': '5 days ago', 'new': false, 'type': 'video'},
      {'icon': Icons.star_outlined, 'title': 'Match score updated', 'body': 'Your AI match score with Stockport County is now 94%', 'time': '1 week ago', 'new': false, 'type': 'match'},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Notifications', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                    child: const Text('Mark all read', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final n = notifications[index];
                  final isNew = n['new'] as bool;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    decoration: BoxDecoration(
                      color: isNew ? AppColors.primary.withValues(alpha: 0.03) : AppColors.surface,
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
                        child: Icon(
                          n['icon'] as IconData,
                          color: isNew ? AppColors.primary : AppColors.textTertiary,
                          size: 22,
                        ),
                      ),
                      title: Text(
                        n['title'] as String,
                        style: TextStyle(fontSize: 13, fontWeight: isNew ? FontWeight.w700 : FontWeight.w600, color: AppColors.textPrimary),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 2),
                          Text(n['body'] as String, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary), maxLines: 2),
                          const SizedBox(height: 4),
                          Text(n['time'] as String, style: const TextStyle(fontSize: 11, color: AppColors.textTertiary)),
                        ],
                      ),
                      trailing: isNew
                          ? Container(
                              width: 8, height: 8,
                              decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                            )
                          : null,
                      onTap: () {},
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
