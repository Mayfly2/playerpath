import 'package:flutter/material.dart';
import 'package:playerpath/app/theme/colors.dart';
import 'package:playerpath/core/widgets/scout_widgets.dart';
import 'package:playerpath/core/widgets/club_badge.dart';

class ProfileAnalyticsScreen extends StatelessWidget {
  const ProfileAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Profile Analytics', style: TextStyle(fontWeight: FontWeight.w700))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overview Cards
            Row(
              children: [
                Expanded(child: _MetricCard(label: 'Profile Views', value: '1,234', change: '+12%', icon: Icons.visibility_outlined, color: AppColors.primary)),
                const SizedBox(width: 10),
                Expanded(child: _MetricCard(label: 'Video Views', value: '2,345', change: '+28%', icon: Icons.play_circle_outline, color: AppColors.info)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _MetricCard(label: 'Applications', value: '9', change: '+2', icon: Icons.send_outlined, color: AppColors.warning)),
                const SizedBox(width: 10),
                Expanded(child: _MetricCard(label: 'Accepted', value: '2', change: '22%', icon: Icons.check_circle_outline, color: AppColors.success)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _MetricCard(label: 'Messages', value: '48', change: '+5', icon: Icons.message_outlined, color: AppColors.info)),
                const SizedBox(width: 10),
                Expanded(child: _MetricCard(label: 'Followers', value: '486', change: '+23', icon: Icons.person_add, color: AppColors.primary)),
              ],
            ),

            const SizedBox(height: 28),

            // Views Chart
            Text('Weekly Profile Views', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            ScoutCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  SizedBox(
                    height: 160,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _Bar(height: 0.45, label: 'Mon', value: '45'),
                        _Bar(height: 0.62, label: 'Tue', value: '62'),
                        _Bar(height: 0.38, label: 'Wed', value: '38'),
                        _Bar(height: 0.78, label: 'Thu', value: '78'),
                        _Bar(height: 0.55, label: 'Fri', value: '55'),
                        _Bar(height: 0.85, label: 'Sat', value: '85'),
                        _Bar(height: 0.92, label: 'Sun', value: '92'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total this week', style: theme.textTheme.bodySmall),
                      Text('455 views', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800, color: AppColors.primary)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // AI Match Score
            Text('AI Match Score', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            ScoutCard(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  SizedBox(
                    width: 80, height: 80,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 80, height: 80,
                          child: CircularProgressIndicator(value: 0.94, strokeWidth: 6, backgroundColor: AppColors.border, valueColor: const AlwaysStoppedAnimation(AppColors.primary)),
                        ),
                        Text('94%', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.primary)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Elite Match', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Text('Your profile ranks in the top 6% of players in your region. Clubs are actively seeking players with your profile.', style: theme.textTheme.bodySmall?.copyWith(height: 1.5)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Search Ranking
            Text('Search Ranking', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            ScoutCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  _RankRow(label: 'Greater Manchester', value: '#4', change: '↑ 2'),
                  const Divider(height: 20),
                  _RankRow(label: 'Strikers (Step 4)', value: '#2', change: '↑ 1'),
                  const Divider(height: 20),
                  _RankRow(label: 'Under 23', value: '#7', change: '↓ 1'),
                  const Divider(height: 20),
                  _RankRow(label: 'Overall (UK)', value: '#128', change: '↑ 15'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Club Interest
            Text('Club Interest', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            ScoutCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  _InterestRow(club: 'Stockport County', league: 'National League North', match: '94%'),
                  const Divider(height: 20),
                  _InterestRow(club: 'FC Halifax Town', league: 'National League', match: '87%'),
                  const Divider(height: 20),
                  _InterestRow(club: 'Bury FC', league: 'NW Counties Premier', match: '88%'),
                  const Divider(height: 20),
                  _InterestRow(club: 'FC United', league: 'NPL Premier', match: '90%'),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final String change;
  final IconData icon;
  final Color color;
  const _MetricCard({required this.label, required this.value, required this.change, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    final isPositive = !change.startsWith('-');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 18),
              Text(change, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isPositive ? AppColors.success : AppColors.error)),
            ],
          ),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final double height;
  final String label;
  final String value;
  const _Bar({required this.height, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(value, style: const TextStyle(fontSize: 9, color: AppColors.textTertiary)),
            const SizedBox(height: 4),
            FractionallySizedBox(
              heightFactor: height,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: AppColors.orangeGradient, begin: Alignment.bottomCenter, end: Alignment.topCenter),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 9, color: AppColors.textTertiary, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

class _RankRow extends StatelessWidget {
  final String label;
  final String value;
  final String change;
  const _RankRow({required this.label, required this.value, required this.change});

  @override
  Widget build(BuildContext context) {
    final isUp = change.startsWith('↑');
    return Row(
      children: [
        Expanded(child: Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary))),
        Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        const SizedBox(width: 8),
        Text(change, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isUp ? AppColors.success : AppColors.error)),
      ],
    );
  }
}

class _InterestRow extends StatelessWidget {
  final String club;
  final String league;
  final String match;
  const _InterestRow({required this.club, required this.league, required this.match});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
          child: ClubBadge(clubName: club, size: 36),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(club, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              Text(league, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)),
          child: Text('$match match', style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}
