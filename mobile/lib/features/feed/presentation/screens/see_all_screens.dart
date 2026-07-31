import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:playerpath/app/theme/colors.dart';
import 'package:playerpath/core/widgets/scout_widgets.dart';
import 'package:playerpath/core/widgets/club_badge.dart';

class AllClubsScreen extends StatelessWidget {
  const AllClubsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final List<Map<String, dynamic>> clubs = [
      {'name': 'Stockport County', 'league': 'National League North', 'step': 'Step 4', 'dist': '2.1 mi', 'trials': '1', 'score': 92},
      {'name': 'FC Halifax Town', 'league': 'National League', 'step': 'Step 1', 'dist': '4.5 mi', 'trials': '3', 'score': 87},
      {'name': 'Altrincham FC', 'league': 'National League North', 'step': 'Step 2', 'dist': '6.8 mi', 'trials': '0', 'score': 78},
      {'name': 'Macclesfield FC', 'league': 'NPL Premier', 'step': 'Step 3', 'dist': '8.2 mi', 'trials': '2', 'score': 74},
      {'name': 'Curzon Ashton', 'league': 'National League North', 'step': 'Step 2', 'dist': '12.0 mi', 'trials': '0', 'score': 82},
      {'name': 'South Shields', 'league': 'National League North', 'step': 'Step 2', 'dist': '15.3 mi', 'trials': '1', 'score': 79},
      {'name': 'Bury FC', 'league': 'NW Counties Premier', 'step': 'Step 5', 'dist': '18.7 mi', 'trials': '4', 'score': 88},
      {'name': 'Chester FC', 'league': 'National League North', 'step': 'Step 2', 'dist': '22.1 mi', 'trials': '0', 'score': 76},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: Row(
                  children: [
                    IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
                    const SizedBox(width: 8),
                    Text('Nearby Clubs', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search clubs...',
                    prefixIcon: const Icon(Icons.search, color: AppColors.textTertiary),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final c = clubs[index];
                  final name = c['name'] as String;
                  final league = c['league'] as String;
                  final step = c['step'] as String;
                  final dist = c['dist'] as String;
                  final trials = c['trials'] as String;
                  final score = c['score'] as int;
                  final hasTrials = trials != '0';

                  return ScoutCard(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    onTap: () => context.push('/club/${index + 1}'),
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
                              Text(name, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                              const SizedBox(height: 2),
                              Text('$league • $step', style: theme.textTheme.bodySmall),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.location_on_outlined, size: 12, color: AppColors.textTertiary),
                                  const SizedBox(width: 2),
                                  Text(dist, style: theme.textTheme.labelSmall),
                                  if (hasTrials) ...[
                                    const SizedBox(width: 10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                                      child: Text('$trials trials', style: const TextStyle(fontSize: 10, color: AppColors.warning, fontWeight: FontWeight.w600)),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                        MatchScoreBadge(score: score, size: 44),
                      ],
                    ),
                  );
                },
                childCount: clubs.length,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }
}

class AllTrialsScreen extends StatelessWidget {
  const AllTrialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final List<Map<String, String>> trials = [
      {'club': 'FC United of Manchester', 'date': '20 Jul 2025', 'time': '10:00 AM', 'location': 'Broadhurst Park', 'spots': '15', 'step': 'Step 3'},
      {'club': 'Stockport County', 'date': '25 Jul 2025', 'time': '2:00 PM', 'location': 'Edgeley Park', 'spots': '8', 'step': 'Step 4'},
      {'club': 'Bury FC', 'date': '28 Jul 2025', 'time': '11:00 AM', 'location': 'Gigg Lane', 'spots': '20', 'step': 'Step 5'},
      {'club': 'Macclesfield FC', 'date': '1 Aug 2025', 'time': '9:30 AM', 'location': 'Leasing.com Stadium', 'spots': '12', 'step': 'Step 3'},
      {'club': 'South Shields', 'date': '5 Aug 2025', 'time': '1:00 PM', 'location': '1st Cloud Arena', 'spots': '6', 'step': 'Step 2'},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: Row(
                  children: [
                    IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
                    const SizedBox(width: 8),
                    Text('Open Trials', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final t = trials[index];
                  return ScoutCard(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 48, height: 48,
                              decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(14)),
                              child: const Icon(Icons.emoji_events, color: AppColors.primary),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(t['club']!, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                                  Text(t['step']!, style: theme.textTheme.bodySmall),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
                              child: Text('${t['spots']} spots', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 12)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            _TrialInfoChip(icon: Icons.calendar_today, text: t['date']!),
                            const SizedBox(width: 10),
                            _TrialInfoChip(icon: Icons.access_time, text: t['time']!),
                            const SizedBox(width: 10),
                            _TrialInfoChip(icon: Icons.location_on, text: t['location']!),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity, height: 44,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                            child: const Text('Apply Now', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                childCount: trials.length,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }
}

class _TrialInfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  const _TrialInfoChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }
}

class AllPlayersScreen extends StatelessWidget {
  const AllPlayersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final List<Map<String, dynamic>> players = [
      {'name': 'James Wilson', 'pos': 'ST', 'step': 'Step 4', 'age': '22', 'goals': '14', 'loc': 'Stockport', 'score': 94},
      {'name': 'Marcus Thompson', 'pos': 'ST, LW', 'step': 'Step 4', 'age': '22', 'goals': '12', 'loc': 'Manchester', 'score': 88},
      {'name': 'Alex Hughes', 'pos': 'CM', 'step': 'Step 5', 'age': '20', 'goals': '8', 'loc': 'Liverpool', 'score': 85},
      {'name': 'Ryan Davies', 'pos': 'CB', 'step': 'Step 3', 'age': '26', 'goals': '2', 'loc': 'Leeds', 'score': 78},
      {'name': 'Tom Baker', 'pos': 'GK', 'step': 'Step 6', 'age': '19', 'goals': '0', 'loc': 'Birmingham', 'score': 82},
      {'name': 'Liam Cooper', 'pos': 'RW', 'step': 'Step 4', 'age': '23', 'goals': '9', 'loc': 'Sheffield', 'score': 91},
      {'name': 'Dan Evans', 'pos': 'LB', 'step': 'Step 5', 'age': '21', 'goals': '3', 'loc': 'London', 'score': 76},
      {'name': 'Sam Patel', 'pos': 'ST', 'step': 'Step 5', 'age': '22', 'goals': '16', 'loc': 'Leicester', 'score': 93},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: Row(
                  children: [
                    IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
                    const SizedBox(width: 8),
                    Text('Trending Players', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final p = players[index];
                  final name = p['name'] as String;
                  final pos = p['pos'] as String;
                  final step = p['step'] as String;
                  final age = p['age'] as String;
                  final goals = p['goals'] as String;
                  final loc = p['loc'] as String;
                  final score = p['score'] as int;

                  return ScoutCard(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    onTap: () => context.push('/player/${index + 1}'),
                    child: Row(
                      children: [
                        UserAvatar(radius: 26, initials: name.split(' ').map((e) => e[0]).join()),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(name, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                              const SizedBox(height: 2),
                              Text('$pos • $step • $age yrs', style: theme.textTheme.bodySmall),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text('⚽ $goals goals', style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600)),
                                  const SizedBox(width: 8),
                                  Text('📍 $loc', style: const TextStyle(fontSize: 11, color: AppColors.textTertiary)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        MatchScoreBadge(score: score, size: 44),
                      ],
                    ),
                  );
                },
                childCount: players.length,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }
}
