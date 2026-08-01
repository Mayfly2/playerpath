import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:playerpath/app/theme/colors.dart';
import 'package:playerpath/core/widgets/scout_widgets.dart';
import 'package:playerpath/core/widgets/club_badge.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Simulate network fetch — replace with actual API call
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isLoading) {
      return _buildShimmer(isDark);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadData,
          child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back 👋',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Find your next opportunity',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: AppColors.orangeGradient,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.sports_soccer,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Nearby Clubs
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
                  itemCount: 5,
                  itemBuilder: (context, index) => _ClubHorizontalCard(
                    name: ['Stockport County', 'FC Halifax', 'Altrincham FC', 'Macclesfield', 'Curzon Ashton'][index],
                    league: ['National League North', 'National League', 'National League North', 'NPL Premier', 'National League North'][index],
                    distance: ['2.1 mi', '4.5 mi', '6.8 mi', '8.2 mi', '12.0 mi'][index],
                    matchScore: [92, 87, 78, 74, 82][index],
                    onTap: () => context.push('/club/${index + 1}'),
                  ),
                ),
              ),
            ),

            // Open Trials
            SliverToBoxAdapter(
              child: SectionHeader(
                title: 'Open Trials',
                actionLabel: 'See All',
                onAction: () => context.push('/trials'),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: List.generate(3, (i) {
                  return ScoutCard(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    onTap: () => context.push('/trials'),
                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
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
                              Text(
                                'FC United - Open Trial',
                                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Sat 20 Jul • Manchester • 15 spots left',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        const MatchScoreBadge(score: 92, size: 44),
                      ],
                    ),
                  );
                }),
              ),
            ),

            // Trending Players
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
                  itemCount: 6,
                  itemBuilder: (context, index) => _PlayerHorizontalCard(
                    name: ['James Wilson', 'Marcus Thompson', 'Alex Hughes', 'Ryan Davies', 'Tom Baker', 'Liam Cooper'][index],
                    position: ['ST', 'CM', 'LW', 'CB', 'GK', 'RW'][index],
                    age: [22, 24, 20, 26, 19, 23][index],
                    goals: [14, 8, 12, 2, 0, 9][index],
                    matchScore: [94, 88, 85, 78, 82, 91][index],
                    onTap: () => context.push('/player/${index + 1}'),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmer(bool isDark) {
    final baseColor = isDark ? AppColors.darkSurface : AppColors.surfaceAlt;
    final highlightColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: SafeArea(
        child: Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header shimmer
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
                // Section header
                Container(width: 100, height: 16, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4))),
                const SizedBox(height: 14),
                // Club cards row
                SizedBox(
                  height: 186,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (_, __) => Container(
                      width: 170,
                      margin: const EdgeInsets.only(right: 12),
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
                      width: 155,
                      margin: const EdgeInsets.only(right: 12),
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
}

class _ClubHorizontalCard extends StatelessWidget {
  final String name;
  final String league;
  final String distance;
  final int matchScore;
  final VoidCallback onTap;

  const _ClubHorizontalCard({
    required this.name,
    required this.league,
    required this.distance,
    required this.matchScore,
    required this.onTap,
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
          boxShadow: [
            BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 72,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.15),
                    AppColors.primary.withValues(alpha: 0.03),
                  ],
                ),
              ),
              child: Center(
                child: ClubBadge(clubName: name, size: 48),
              ),
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
                      const Icon(Icons.location_on_outlined, size: 13, color: AppColors.textTertiary),
                      const SizedBox(width: 3),
                      Text(distance, style: Theme.of(context).textTheme.labelSmall),
                      const Spacer(),
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
    required this.name,
    required this.position,
    required this.age,
    required this.goals,
    required this.matchScore,
    required this.onTap,
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
                  child: const Center(
                    child: Icon(Icons.person, size: 44, color: AppColors.primary),
                  ),
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
            Positioned(
              top: 8,
              right: 8,
              child: MatchScoreBadge(score: matchScore, size: 36),
            ),
          ],
        ),
      ),
    );
  }
}
