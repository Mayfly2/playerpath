import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:playerpath/app/theme/colors.dart';
import 'package:playerpath/core/widgets/scout_widgets.dart';
import 'package:playerpath/core/widgets/club_badge.dart';
import 'package:playerpath/features/feed/presentation/cubit/feed_cubit.dart';
import 'package:playerpath/features/feed/data/repositories/feed_repository.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FeedCubit(FeedRepository())..loadFeed(),
      child: const _HomeBody(),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<FeedCubit, FeedState>(
      builder: (context, state) {
        if (state is FeedLoading) {
          return _buildShimmer(isDark);
        }
        if (state is FeedError) {
          return _buildError(context, state.message);
        }
        if (state is FeedLoaded && !state.hasData) {
          return _buildEmpty(context);
        }

        final feed = state is FeedLoaded ? state : null;
        final clubs = feed?.nearbyClubs ?? [];
        final trials = feed?.clubsWithTrials ?? [];
        final players = feed?.trendingPlayers ?? [];

        return Scaffold(
          backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async => context.read<FeedCubit>().loadFeed(),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Welcome back 👋',
                                style: theme.textTheme.titleMedium?.copyWith(color: AppColors.textSecondary)),
                              const SizedBox(height: 4),
                              Text('Find your next opportunity',
                                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.3)),
                            ],
                          ),
                          Hero(
                            tag: 'app-logo',
                            child: Container(
                              width: 44, height: 44,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: AppColors.orangeGradient),
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 3)),
                                ],
                              ),
                              child: const Icon(Icons.sports_soccer, color: Colors.white, size: 22),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Nearby Clubs
                  if (clubs.isNotEmpty) ...[
                    SliverToBoxAdapter(
                      child: SectionHeader(
                        title: 'Nearby Clubs',
                        actionLabel: 'See All',
                        onAction: () => context.push('/clubs/all'),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 186,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: clubs.length,
                          itemBuilder: (context, index) {
                            final c = clubs[index];
                            return _ClubHorizontalCard(
                              name: c['clubName'] ?? 'Club',
                              league: c['league'] ?? '',
                              distance: _formatDistance(c),
                              matchScore: 82,
                              badgeName: c['clubName'] ?? 'C',
                              onTap: () => context.push('/club/${c['id']}'),
                            );
                          },
                        ),
                      ),
                    ),
                  ],

                  // Open Trials
                  if (trials.isNotEmpty) ...[
                    SliverToBoxAdapter(
                      child: SectionHeader(
                        title: 'Open Trials',
                        actionLabel: 'See All',
                        onAction: () => context.push('/trials'),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        children: trials.take(3).map((c) {
                          return ScoutCard(
                            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                            onTap: () => context.push('/club/${c['id']}'),
                            child: Row(
                              children: [
                                Container(
                                  width: 52, height: 52,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Icon(Icons.emoji_events_outlined, color: AppColors.primary),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(c['clubName'] ?? 'Club',
                                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                                      const SizedBox(height: 3),
                                      Text('Open Trial • ${c['league'] ?? ''}',
                                        style: theme.textTheme.bodySmall),
                                    ],
                                  ),
                                ),
                                const MatchScoreBadge(score: 85, size: 44),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],

                  // Trending Players
                  if (players.isNotEmpty) ...[
                    SliverToBoxAdapter(
                      child: SectionHeader(
                        title: 'Trending Players',
                        actionLabel: 'See All',
                        onAction: () => context.push('/players/all'),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 224,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: players.length,
                          itemBuilder: (context, index) {
                            final p = players[index];
                            final posList = p['positions'] as List<dynamic>?;
                            final pos = posList != null && posList.isNotEmpty
                                ? (posList.first['position'] ?? '?')
                                : '?';
                            final stats = p['statistics'] as List<dynamic>?;
                            final goals = stats != null && stats.isNotEmpty
                                ? stats.fold<int>(0, (sum, s) => sum + (s['goals'] as int? ?? 0))
                                : 0;

                            return _PlayerHorizontalCard(
                              name: p['fullName'] ?? 'Player',
                              position: pos.toString(),
                              age: _calcAge(p['dateOfBirth'] as String?),
                              goals: goals,
                              matchScore: 88,
                              onTap: () => context.push('/player/${p['id']}'),
                            );
                          },
                        ),
                      ),
                    ),
                  ],

                  const SliverToBoxAdapter(child: SizedBox(height: 32)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  int _calcAge(String? dob) {
    if (dob == null) return 0;
    try {
      final d = DateTime.parse(dob);
      final now = DateTime.now();
      int age = now.year - d.year;
      if (now.month < d.month || (now.month == d.month && now.day < d.day)) age--;
      return age;
    } catch (_) {
      return 0;
    }
  }

  String _formatDistance(Map<String, dynamic> club) {
    // Return distance if available, otherwise location
    return club['distance']?.toString() ?? club['location']?.toString() ?? '';
  }

  Widget _buildShimmer(bool isDark) {
    final base = isDark ? AppColors.darkSurface : AppColors.surfaceAlt;
    final highlight = isDark ? AppColors.darkBorder : AppColors.border;
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: SafeArea(
        child: Shimmer.fromColors(
          baseColor: base,
          highlightColor: highlight,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: 120, height: 14, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4))),
                        const SizedBox(height: 8),
                        Container(width: 180, height: 20, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4))),
                      ],
                    ),
                    Container(width: 48, height: 48, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16))),
                  ],
                ),
                const SizedBox(height: 28),
                Container(width: 100, height: 16, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4))),
                const SizedBox(height: 14),
                SizedBox(
                  height: 186,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (_, __) => Container(
                      width: 170, margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Container(width: 90, height: 16, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4))),
                const SizedBox(height: 14),
                ...List.generate(3, (_) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(height: 72, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16))),
                )),
                const SizedBox(height: 24),
                Container(width: 120, height: 16, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4))),
                const SizedBox(height: 14),
                SizedBox(
                  height: 224,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (_, __) => Container(
                      width: 155, margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, size: 48, color: AppColors.textTertiary),
            const SizedBox(height: 16),
            Text(message, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            PrimaryButton(
              label: 'Retry',
              onPressed: () => context.read<FeedCubit>().loadFeed(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Scaffold(
      body: EmptyState(
        icon: Icons.explore_outlined,
        title: 'No content yet',
        subtitle: 'Complete your profile to get personalised recommendations.',
        actionLabel: 'Edit Profile',
        onAction: () => context.push('/profile/edit'),
      ),
    );
  }
}

class _ClubHorizontalCard extends StatelessWidget {
  final String name;
  final String league;
  final String distance;
  final int matchScore;
  final String badgeName;
  final VoidCallback onTap;

  const _ClubHorizontalCard({
    required this.name, required this.league, required this.distance,
    required this.matchScore, required this.badgeName, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 170,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border, width: 0.5),
          boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 72,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                gradient: LinearGradient(
                  colors: [AppColors.primary.withValues(alpha: 0.15), AppColors.primary.withValues(alpha: 0.03)],
                ),
              ),
              child: Center(child: ClubBadge(clubName: badgeName, size: 48)),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(league, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (distance.isNotEmpty) ...[
                        const Icon(Icons.location_on_outlined, size: 13, color: AppColors.textTertiary),
                        const SizedBox(width: 3),
                        Text(distance, style: Theme.of(context).textTheme.labelSmall),
                        const Spacer(),
                      ],
                      MatchScoreBadge(score: matchScore, size: 34),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayerHorizontalCard extends StatelessWidget {
  final String name;
  final String position;
  final int age;
  final int goals;
  final int matchScore;
  final VoidCallback onTap;

  const _PlayerHorizontalCard({
    required this.name, required this.position, required this.age,
    required this.goals, required this.matchScore, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 155,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 110,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    color: AppColors.accent.withValues(alpha: 0.1),
                  ),
                  child: const Center(child: Icon(Icons.person, size: 44, color: AppColors.primary)),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Text('$position • $age yrs', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11)),
                      const SizedBox(height: 3),
                      Text('⚽ $goals goals', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(top: 8, right: 8, child: MatchScoreBadge(score: matchScore, size: 36)),
          ],
        ),
      ),
    );
  }
}
