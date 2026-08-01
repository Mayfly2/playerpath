import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:playerpath/app/theme/colors.dart';
import 'package:playerpath/core/widgets/scout_widgets.dart';
import 'package:playerpath/core/widgets/club_badge.dart';
import 'package:playerpath/features/search/presentation/cubit/discover_cubit.dart';
import 'package:playerpath/features/search/data/repositories/search_repository.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late DiscoverCubit _cubit;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _cubit = DiscoverCubit(SearchRepository());
    _cubit.loadAll();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Text('Discover', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search players, clubs, positions...',
                    prefixIcon: const Icon(Icons.search, color: AppColors.textTertiary),
                    suffixIcon: Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: AppColors.orangeGradient),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.tune, color: Colors.white, size: 20),
                    ),
                  ),
                  onSubmitted: (query) {
                    context.push('/search?q=$query');
                  },
                ),
              ),
              const SizedBox(height: 8),
              TabBar(
                controller: _tabController,
                tabs: const [Tab(text: 'Players'), Tab(text: 'Clubs')],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [_buildPlayersTab(context), _buildClubsTab(context)],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayersTab(BuildContext context) {
    return BlocBuilder<DiscoverCubit, DiscoverState>(
      builder: (context, state) {
        if (state is DiscoverLoading) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        if (state is DiscoverError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cloud_off, size: 48, color: AppColors.textTertiary),
                const SizedBox(height: 12),
                Text(state.message, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 16),
                PrimaryButton(label: 'Retry', onPressed: () => _cubit.loadAll()),
              ],
            ),
          );
        }

        final players = state is DiscoverLoaded ? state.players : <Map<String, dynamic>>[];
        final hasMore = state is DiscoverLoaded && state.hasMorePlayers;

        if (players.isEmpty && state is DiscoverLoaded) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.person_search, size: 48, color: AppColors.textTertiary),
                const SizedBox(height: 12),
                Text('No players found', style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => _cubit.loadPlayers(refresh: true),
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: players.length + (hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= players.length) {
                _cubit.loadPlayers();
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                );
              }

              final p = players[index];
              final name = p['fullName'] as String? ?? 'Unknown';
              final positions = p['positions'] as List<dynamic>?;
              final pos = positions != null && positions.isNotEmpty
                  ? (positions.map((e) => e['position']).join(', '))
                  : 'Unknown';
              final step = 'Step ${p['currentStep'] ?? '?'}';
              final age = _calculateAge(p['dateOfBirth'] as String?);
              final goals = p['statistics'] is List && (p['statistics'] as List).isNotEmpty
                  ? '${(p['statistics'] as List).fold<int>(0, (s, e) => s + (e['goals'] as int? ?? 0))}'
                  : '0';
              final location = p['county'] as String? ?? 'Unknown';

              return ScoutCard(
                margin: const EdgeInsets.only(bottom: 10),
                onTap: () => context.push('/player/${p['id']}'),
                child: Row(
                  children: [
                    UserAvatar(radius: 26, initials: name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').join()),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 2),
                          Text('$pos • $step • $age yrs', style: Theme.of(context).textTheme.bodySmall),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              _Tag(label: '⚽ $goals goals'),
                              const SizedBox(width: 6),
                              _Tag(label: '📍 $location'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildClubsTab(BuildContext context) {
    return BlocBuilder<DiscoverCubit, DiscoverState>(
      builder: (context, state) {
        if (state is DiscoverLoading) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        if (state is DiscoverError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cloud_off, size: 48, color: AppColors.textTertiary),
                const SizedBox(height: 12),
                Text(state.message, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 16),
                PrimaryButton(label: 'Retry', onPressed: () => _cubit.loadAll()),
              ],
            ),
          );
        }

        final clubs = state is DiscoverLoaded ? state.clubs : <Map<String, dynamic>>[];
        final hasMore = state is DiscoverLoaded && state.hasMoreClubs;

        if (clubs.isEmpty && state is DiscoverLoaded) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.shield, size: 48, color: AppColors.textTertiary),
                const SizedBox(height: 12),
                Text('No clubs found', style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => _cubit.loadClubs(refresh: true),
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: clubs.length + (hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= clubs.length) {
                _cubit.loadClubs();
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                );
              }

              final c = clubs[index];
              final name = c['clubName'] as String? ?? 'Unknown';
              final league = c['league'] as String? ?? 'Unknown';
              final step = 'Step ${c['step'] ?? '?'}';
              final location = c['location'] as String? ?? 'Unknown';

              return ScoutCard(
                margin: const EdgeInsets.only(bottom: 10),
                onTap: () => context.push('/club/${c['id']}'),
                child: Row(
                  children: [
                    Container(
                      width: 52, height: 52,
                      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(14)),
                      child: ClubBadge(clubName: name, size: 52),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 2),
                          Text('$league • $step', style: Theme.of(context).textTheme.bodySmall),
                          const SizedBox(height: 4),
                          _Tag(label: '📍 $location'),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: AppColors.textTertiary),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  int _calculateAge(String? dateOfBirth) {
    if (dateOfBirth == null) return 0;
    try {
      final dob = DateTime.parse(dateOfBirth);
      final now = DateTime.now();
      int age = now.year - dob.year;
      if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
        age--;
      }
      return age;
    } catch (_) {
      return 0;
    }
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color? color;
  const _Tag({required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: (color ?? AppColors.textSecondary).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label, style: TextStyle(fontSize: 10, color: color ?? AppColors.textSecondary, fontWeight: FontWeight.w600)),
    );
  }
}
