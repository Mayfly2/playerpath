import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:playerpath/app/theme/colors.dart';
import 'package:playerpath/core/widgets/scout_widgets.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chats = [
      {'name': 'FC United of Manchester', 'lastMsg': 'Would you like to come for a trial next week?', 'time': '2m', 'unread': '3', 'type': 'club'},
      {'name': 'Stockport County Scout', 'lastMsg': 'Great profile. We\'d love to see you play.', 'time': '1h', 'unread': '1', 'type': 'club'},
      {'name': 'Marcus Thompson', 'lastMsg': 'Thanks for the recommendation mate!', 'time': '3h', 'unread': '0', 'type': 'player'},
      {'name': 'Altrincham FC', 'lastMsg': 'Your application has been reviewed', 'time': 'Yesterday', 'unread': '0', 'type': 'club'},
      {'name': 'Coach Williams', 'lastMsg': 'See you at training on Tuesday', 'time': '2d', 'unread': '0', 'type': 'coach'},
      {'name': 'Bury FC Manager', 'lastMsg': 'We are interested in offering you a contract', 'time': '3d', 'unread': '0', 'type': 'club'},
      {'name': 'Alex Hughes', 'lastMsg': 'Good luck with the trial!', 'time': '1w', 'unread': '0', 'type': 'player'},
      {'name': 'Macclesfield FC', 'lastMsg': 'Trial confirmed for August 1st', 'time': '1w', 'unread': '0', 'type': 'club'},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
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

            // Search
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search conversations...',
                  prefixIcon: const Icon(Icons.search, color: AppColors.textTertiary),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Conversations
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final c = chats[index];
                  final hasUnread = int.parse(c['unread']!) > 0;

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    leading: Stack(
                      children: [
                        UserAvatar(
                          radius: 26,
                          initials: c['name']!.split(' ').map((e) => e[0]).take(2).join(),
                        ),
                        if (c['type'] == 'club')
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
                    title: Text(
                      c['name']!,
                      style: TextStyle(
                        fontWeight: hasUnread ? FontWeight.w800 : FontWeight.w600,
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      c['lastMsg']!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: hasUnread ? AppColors.textPrimary : AppColors.textSecondary,
                        fontWeight: hasUnread ? FontWeight.w500 : FontWeight.w400,
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(c['time']!, style: const TextStyle(fontSize: 11, color: AppColors.textTertiary)),
                        if (hasUnread) ...[
                          const SizedBox(height: 4),
                          Container(
                            width: 20, height: 20,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(c['unread']!, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                            ),
                          ),
                        ],
                      ],
                    ),
                    onTap: () {},
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

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
        title: const Row(
          children: [
            UserAvatar(radius: 16, initials: 'FC'),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('FC United', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                Text('Online now', style: TextStyle(fontSize: 11, color: AppColors.success)),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: EmptyState(
                icon: Icons.chat_bubble_outline,
                title: 'Start the conversation',
                subtitle: 'Send a message to get started with this club',
                actionLabel: 'Send Message',
                onAction: () {},
              ),
            ),
          ),
          // Message input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(icon: const Icon(Icons.attach_file, color: AppColors.textSecondary), onPressed: () {}),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        filled: true,
                        fillColor: AppColors.inputFill,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: AppColors.orangeGradient),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white, size: 20),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
