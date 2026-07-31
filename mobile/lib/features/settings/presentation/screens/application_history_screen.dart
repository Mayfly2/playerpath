import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:playerpath/app/theme/colors.dart';
import 'package:playerpath/core/widgets/scout_widgets.dart';
import 'package:playerpath/core/widgets/club_badge.dart';

class ApplicationHistoryScreen extends StatefulWidget {
  const ApplicationHistoryScreen({super.key});

  @override
  State<ApplicationHistoryScreen> createState() => _ApplicationHistoryScreenState();
}

class _ApplicationHistoryScreenState extends State<ApplicationHistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> _allApps = [
    {'club': 'Stockport County', 'league': 'National League North', 'role': 'Striker', 'date': '15 Jul 2025', 'status': 'pending'},
    {'club': 'FC Halifax Town', 'league': 'National League', 'role': 'Forward', 'date': '12 Jul 2025', 'status': 'accepted'},
    {'club': 'Bury FC', 'league': 'NW Counties Premier', 'role': 'Striker', 'date': '10 Jul 2025', 'status': 'trial'},
    {'club': 'Macclesfield FC', 'league': 'NPL Premier', 'role': 'Forward', 'date': '8 Jul 2025', 'status': 'rejected'},
    {'club': 'South Shields', 'league': 'National League North', 'role': 'Striker', 'date': '5 Jul 2025', 'status': 'completed'},
    {'club': 'Curzon Ashton', 'league': 'National League North', 'role': 'Winger', 'date': '1 Jul 2025', 'status': 'cancelled'},
    {'club': 'Altrincham FC', 'league': 'National League North', 'role': 'Forward', 'date': '28 Jun 2025', 'status': 'accepted'},
    {'club': 'FC United', 'league': 'NPL Premier', 'role': 'Striker', 'date': '20 Jun 2025', 'status': 'trial'},
    {'club': 'Chester FC', 'league': 'National League North', 'role': 'Winger', 'date': '15 Jun 2025', 'status': 'rejected'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Applications', style: TextStyle(fontWeight: FontWeight.w700))),
      body: Column(
        children: [
          // Stats bar
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.surface,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _AppStat(value: '9', label: 'Total', color: AppColors.textPrimary),
                _AppStat(value: '1', label: 'Pending', color: AppColors.warning),
                _AppStat(value: '2', label: 'Accepted', color: AppColors.success),
                _AppStat(value: '2', label: 'Trials', color: AppColors.info),
                _AppStat(value: '2', label: 'Rejected', color: AppColors.error),
              ],
            ),
          ),
          // Tabs
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Pending'),
              Tab(text: 'Accepted'),
              Tab(text: 'Trials'),
              Tab(text: 'Completed'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: ['all', 'pending', 'accepted', 'trial', 'completed'].map((filter) {
                final filtered = filter == 'all'
                    ? _allApps
                    : _allApps.where((a) => a['status'] == filter).toList();

                if (filtered.isEmpty) {
                  return EmptyState(
                    icon: Icons.inbox_outlined,
                    title: 'No applications',
                    subtitle: 'Your applications in this category will appear here',
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final a = filtered[index];
                    return _AppCard(
                      club: a['club']!,
                      league: a['league']!,
                      role: a['role']!,
                      date: a['date']!,
                      status: a['status']!,
                      onTap: () => context.push('/club/1'),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _AppStat extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _AppStat({required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: color)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
      ],
    );
  }
}

class _AppCard extends StatelessWidget {
  final String club;
  final String league;
  final String role;
  final String date;
  final String status;
  final VoidCallback onTap;

  const _AppCard({
    required this.club,
    required this.league,
    required this.role,
    required this.date,
    required this.status,
    required this.onTap,
  });

  Color get _statusColor {
    switch (status) {
      case 'pending': return AppColors.warning;
      case 'accepted': return AppColors.success;
      case 'trial': return AppColors.info;
      case 'rejected': return AppColors.error;
      case 'completed': return AppColors.primary;
      default: return AppColors.textTertiary;
    }
  }

  String get _statusLabel {
    switch (status) {
      case 'pending': return 'Pending Review';
      case 'accepted': return 'Accepted';
      case 'trial': return 'Trial Invited';
      case 'rejected': return 'Not Successful';
      case 'completed': return 'Completed';
      default: return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScoutCard(
      margin: const EdgeInsets.only(bottom: 10),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: _statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: ClubBadge(clubName: club, size: 48),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(club, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text('$league • $role', style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 11, color: AppColors.textTertiary),
                    const SizedBox(width: 4),
                    Text(date, style: Theme.of(context).textTheme.labelSmall),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(_statusLabel, style: TextStyle(fontSize: 10, color: _statusColor, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textTertiary),
        ],
      ),
    );
  }
}
