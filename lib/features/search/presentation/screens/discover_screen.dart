import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:playerpath/app/theme/colors.dart';
import 'package:playerpath/core/widgets/scout_widgets.dart';
import 'package:playerpath/core/widgets/club_badge.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
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
    );
  }

  Widget _buildPlayersTab(BuildContext context) {
    final theme = Theme.of(context);
    final List<Map<String, dynamic>> players = [
      {'name': 'Marcus Thompson', 'pos': 'ST, LW', 'step': 'Step 4', 'age': '22', 'goals': '12', 'location': 'Manchester', 'score': 88},
      {'name': 'James Wilson', 'pos': 'ST', 'step': 'Step 4', 'age': '22', 'goals': '14', 'location': 'Stockport', 'score': 94},
      {'name': 'Alex Hughes', 'pos': 'CM, CDM', 'step': 'Step 5', 'age': '20', 'goals': '8', 'location': 'Liverpool', 'score': 85},
      {'name': 'Ryan Davies', 'pos': 'CB', 'step': 'Step 3', 'age': '26', 'goals': '2', 'location': 'Leeds', 'score': 78},
      {'name': 'Tom Baker', 'pos': 'GK', 'step': 'Step 6', 'age': '19', 'goals': '0', 'location': 'Birmingham', 'score': 82},
      {'name': 'Liam Cooper', 'pos': 'RW, LW', 'step': 'Step 4', 'age': '23', 'goals': '9', 'location': 'Sheffield', 'score': 91},
      {'name': 'Dan Evans', 'pos': 'LB', 'step': 'Step 5', 'age': '21', 'goals': '3', 'location': 'London', 'score': 76},
      {'name': 'Ollie Wright', 'pos': 'CAM', 'step': 'Step 3', 'age': '24', 'goals': '11', 'location': 'Nottingham', 'score': 89},
      {'name': 'Harry Green', 'pos': 'CDM', 'step': 'Step 4', 'age': '25', 'goals': '5', 'location': 'Bristol', 'score': 80},
      {'name': 'Sam Patel', 'pos': 'ST', 'step': 'Step 5', 'age': '22', 'goals': '16', 'location': 'Leicester', 'score': 93},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: players.length,
      itemBuilder: (context, index) {
        final p = players[index];
        final name = p['name'] as String;
        final pos = p['pos'] as String;
        final step = p['step'] as String;
        final age = p['age'] as String;
        final goals = p['goals'] as String;
        final location = p['location'] as String;
        final score = p['score'] as int;

        return ScoutCard(
          margin: const EdgeInsets.only(bottom: 10),
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
                        _Tag(label: '⚽ $goals goals'),
                        const SizedBox(width: 6),
                        _Tag(label: '📍 $location'),
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
    );
  }

  Widget _buildClubsTab(BuildContext context) {
    final theme = Theme.of(context);
    final List<Map<String, dynamic>> clubs = [
      {'name': 'FC Halifax Town', 'league': 'National League', 'step': 'Step 1', 'trials': '3 open', 'location': 'Halifax'},
      {'name': 'Stockport County', 'league': 'National League North', 'step': 'Step 2', 'trials': '1 open', 'location': 'Stockport'},
      {'name': 'Altrincham FC', 'league': 'National League North', 'step': 'Step 2', 'trials': 'None', 'location': 'Altrincham'},
      {'name': 'Macclesfield FC', 'league': 'NPL Premier', 'step': 'Step 3', 'trials': '2 open', 'location': 'Macclesfield'},
      {'name': 'Curzon Ashton', 'league': 'National League North', 'step': 'Step 2', 'trials': 'None', 'location': 'Ashton'},
      {'name': 'South Shields', 'league': 'National League North', 'step': 'Step 2', 'trials': '1 open', 'location': 'South Shields'},
      {'name': 'Bury FC', 'league': 'NW Counties Premier', 'step': 'Step 5', 'trials': '4 open', 'location': 'Bury'},
      {'name': 'Chester FC', 'league': 'National League North', 'step': 'Step 2', 'trials': 'None', 'location': 'Chester'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: clubs.length,
      itemBuilder: (context, index) {
        final c = clubs[index];
        final name = c['name'] as String;
        final league = c['league'] as String;
        final step = c['step'] as String;
        final trials = c['trials'] as String;
        final location = c['location'] as String;

        return ScoutCard(
          margin: const EdgeInsets.only(bottom: 10),
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
                        _Tag(label: '📍 $location'),
                        const SizedBox(width: 6),
                        _Tag(label: trials, color: AppColors.primary),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textTertiary),
            ],
          ),
        );
      },
    );
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
