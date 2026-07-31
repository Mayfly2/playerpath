import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:playerpath/app/theme/colors.dart';
import 'package:playerpath/core/widgets/club_badge.dart';

class ClubProfileScreen extends StatefulWidget {
  const ClubProfileScreen({super.key});

  @override
  State<ClubProfileScreen> createState() => _ClubProfileScreenState();
}

class _ClubProfileScreenState extends State<ClubProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isFollowing = false;

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
    final theme = Theme.of(context);
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          // ── HERO HEADER ──
          SliverAppBar(
            expandedHeight: 360,
            pinned: true,
            stretch: true,
            backgroundColor: AppColors.background,
            leading: Container(
              margin: EdgeInsets.only(top: topPadding, left: 4),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
                onPressed: () => context.pop(),
              ),
            ),
            actions: [
              Container(
                margin: EdgeInsets.only(top: topPadding, right: 4),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: Icon(_isFollowing ? Icons.bookmark : Icons.bookmark_border, color: Colors.white, size: 22),
                  onPressed: () => setState(() => _isFollowing = !_isFollowing),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: topPadding, right: 8),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.ios_share, color: Colors.white, size: 20),
                  onPressed: () {},
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Stadium background
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF1A1A2E),
                          Color(0xFF16213E),
                          Color(0xFF0F3460),
                          Color(0xFF1A1A2E),
                        ],
                      ),
                    ),
                  ),
                  // Texture overlay (stadium feel)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _StadiumPatternPainter(),
                    ),
                  ),
                  // Dark gradient overlay for readability
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.5),
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.7),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Centered club identity
                  Positioned(
                    left: 0, right: 0,
                    bottom: 90,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Club Badge
                        Container(
                          width: 100, height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(26),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.4),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const ClubBadge(
                            clubName: 'Stockport County',
                            size: 84,
                            borderRadius: 20,
                          ),
                        ),
                        const SizedBox(height: 14),
                        // Club Name
                        Text(
                          'Stockport County',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        // League + Location
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.85),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text('National League North', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
                            ),
                            const SizedBox(width: 10),
                            Row(
                              children: [
                                Icon(Icons.location_on, size: 14, color: Colors.white.withValues(alpha: 0.8)),
                                const SizedBox(width: 4),
                                Text('Stockport', style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.8))),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── ACTION STRIP ──
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.surface,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Followers
                      _InfoChip(label: '12.4K', sublabel: 'Followers', icon: Icons.people),
                      const SizedBox(width: 16),
                      _InfoChip(label: 'Step 4', sublabel: 'Division', icon: Icons.emoji_events),
                      const SizedBox(width: 16),
                      _InfoChip(label: '1,852', sublabel: 'Capacity', icon: Icons.stadium),
                      const Spacer(),
                      // Apply button
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.send, size: 16),
                              SizedBox(width: 8),
                              Text('Apply to Club', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── TAB BAR ──
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabBarDelegate(
              TabBar(
                controller: _tabController,
                isScrollable: false,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textTertiary,
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                unselectedLabelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                tabs: const [
                  Tab(text: 'Overview'),
                  Tab(text: 'Squad'),
                  Tab(text: 'Matches'),
                  Tab(text: 'Stats'),
                  Tab(text: 'News'),
                ],
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _OverviewTab(),
            _SquadTab(),
            _MatchesTab(),
            _StatsTab(),
            _NewsTab(),
          ],
        ),
      ),
    );
  }
}

// ── STADIUM PATTERN PAINTER ──
class _StadiumPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.02)
      ..strokeWidth = 0.5;

    // Centre circle
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 80, paint);
    // Horizontal line
    canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), paint);
    // Vertical line
    canvas.drawLine(Offset(size.width / 2, 0), Offset(size.width / 2, size.height), paint);
    // Outer circle
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 160, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── TAB BAR DELEGATE ──
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _TabBarDelegate(this.tabBar);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.surface,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => 48;
  @override
  double get minExtent => 48;
  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) => false;
}

// ── INFO CHIP ──
class _InfoChip extends StatelessWidget {
  final String label;
  final String sublabel;
  final IconData icon;
  const _InfoChip({required this.label, required this.sublabel, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: AppColors.textTertiary),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            Text(sublabel, style: const TextStyle(fontSize: 10, color: AppColors.textTertiary)),
          ],
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════
// OVERVIEW TAB
// ═══════════════════════════════════════════
class _OverviewTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // About Card
        _Card(
          title: 'About the Club',
          child: Column(
            children: [
              _InfoRow('Manager', 'Dave Challinor'),
              _InfoRow('Ground', 'Edgeley Park'),
              _InfoRow('Capacity', '10,852'),
              _InfoRow('Founded', '1883'),
              _InfoRow('Training', 'Tue & Thu, 19:00-21:00'),
              _InfoRow('Colours', 'Blue & White'),
              _InfoRow('Philosophy', 'High-pressing, attacking football with a focus on youth development and community engagement.'),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Open Positions
        _Card(
          title: 'Open Positions',
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
            child: const Text('5 open', style: TextStyle(fontSize: 11, color: AppColors.warning, fontWeight: FontWeight.w700)),
          ),
          child: Wrap(
            spacing: 8, runSpacing: 8,
            children: ['ST', 'CM', 'LB', 'GK', 'RW'].map((pos) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.sports_soccer, size: 14, color: AppColors.primaryDark),
                    const SizedBox(width: 6),
                    Text(pos, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primaryDark)),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),

        // Recent Form
        _Card(
          title: 'Recent Form',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _FormBadge(result: 'W', color: AppColors.success),
              _FormBadge(result: 'W', color: AppColors.success),
              _FormBadge(result: 'D', color: AppColors.warning),
              _FormBadge(result: 'W', color: AppColors.success),
              _FormBadge(result: 'L', color: AppColors.error),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Open Trials
        _Card(
          title: 'Open Trials',
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
            child: const Text('1 active', style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w700)),
          ),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.emoji_events, color: AppColors.primary, size: 18),
                    const SizedBox(width: 8),
                    Text('First Team Open Trial', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 10),
                _TrialLine('📅', 'Sat 20 July 2025 • 10:00 AM'),
                _TrialLine('📍', 'Edgeley Park Training Ground'),
                _TrialLine('👥', '15 spots remaining'),
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
          ),
        ),
        const SizedBox(height: 16),

        // Recent Signings
        _Card(
          title: 'Recent Signings',
          child: Column(
            children: [
              _SigningTile(name: 'Marcus Thompson', position: 'ST', from: 'FC United'),
              const _DividerLine(),
              _SigningTile(name: 'Alex Hughes', position: 'CM', from: 'Curzon Ashton'),
              const _DividerLine(),
              _SigningTile(name: 'Dan Evans', position: 'LB', from: 'Free Agent'),
            ],
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}

// ═══════════════════════════════════════════
// SQUAD TAB
// ═══════════════════════════════════════════
class _SquadTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final squad = [
      {'name': 'James Wilson', 'pos': 'ST', 'no': '9', 'age': '22', 'goals': '14'},
      {'name': 'Marcus Thompson', 'pos': 'LW', 'no': '11', 'age': '24', 'goals': '12'},
      {'name': 'Alex Hughes', 'pos': 'CM', 'no': '8', 'age': '20', 'goals': '8'},
      {'name': 'Ryan Davies', 'pos': 'CB', 'no': '5', 'age': '26', 'goals': '2'},
      {'name': 'Tom Baker', 'pos': 'GK', 'no': '1', 'age': '19', 'goals': '0'},
      {'name': 'Liam Cooper', 'pos': 'RW', 'no': '7', 'age': '23', 'goals': '9'},
      {'name': 'Dan Evans', 'pos': 'LB', 'no': '3', 'age': '21', 'goals': '3'},
      {'name': 'Sam Patel', 'pos': 'ST', 'no': '10', 'age': '22', 'goals': '16'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: squad.length,
      itemBuilder: (context, index) {
        final p = squad[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border, width: 0.5),
            boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 4, offset: const Offset(0, 1))],
          ),
          child: Row(
            children: [
              // Jersey number
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(p['no']!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p['name']!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    const SizedBox(height: 2),
                    Text('${p['pos']} • ${p['age']} yrs', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${p['goals']} ⚽', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
                  const Text('goals', style: TextStyle(fontSize: 10, color: AppColors.textTertiary)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════
// MATCHES TAB
// ═══════════════════════════════════════════
class _MatchesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final fixtures = [
      {'home': 'Stockport County', 'away': 'FC Halifax', 'date': 'Sat 22 Jul', 'time': '15:00', 'comp': 'League'},
      {'home': 'Altrincham', 'away': 'Stockport County', 'date': 'Tue 25 Jul', 'time': '19:45', 'comp': 'League'},
      {'home': 'Stockport County', 'away': 'Bury FC', 'date': 'Sat 29 Jul', 'time': '15:00', 'comp': 'FA Cup'},
      {'home': 'Curzon Ashton', 'away': 'Stockport County', 'date': 'Sat 5 Aug', 'time': '15:00', 'comp': 'League'},
      {'home': 'Stockport County', 'away': 'South Shields', 'date': 'Sat 12 Aug', 'time': '15:00', 'comp': 'League'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: fixtures.length,
      itemBuilder: (context, index) {
        final f = fixtures[index];
        final isHome = f['home'] == 'Stockport County';

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border, width: 0.5),
            boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 4, offset: const Offset(0, 1))],
          ),
          child: Row(
            children: [
              // Date
              SizedBox(
                width: 70,
                child: Column(
                  children: [
                    Text(f['date']!, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                    const SizedBox(height: 2),
                    Text(f['time']!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(4)),
                      child: Text(f['comp']!, style: const TextStyle(fontSize: 9, color: AppColors.primaryDark, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Match
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const ClubBadge(clubName: 'STK', size: 28, borderRadius: 8),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(f['home']!, style: TextStyle(fontSize: 13, fontWeight: isHome ? FontWeight.w800 : FontWeight.w500, color: AppColors.textPrimary)),
                        ),
                        Text('vs', style: TextStyle(fontSize: 11, color: AppColors.textTertiary)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(f['away']!, textAlign: TextAlign.end, style: TextStyle(fontSize: 13, fontWeight: !isHome ? FontWeight.w800 : FontWeight.w500, color: AppColors.textPrimary)),
                        ),
                        const SizedBox(width: 10),
                        ClubBadge(clubName: f['away'] == 'FC Halifax' ? 'FCH' : f['away'] == 'Bury FC' ? 'BFC' : 'AFC', size: 28, borderRadius: 8),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════
// STATS TAB
// ═══════════════════════════════════════════
class _StatsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Season stats
        _Card(
          title: 'Season 2025/26',
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: _StatBox(label: 'Played', value: '28', color: AppColors.primary)),
                  const SizedBox(width: 8),
                  Expanded(child: _StatBox(label: 'Won', value: '18', color: AppColors.success)),
                  const SizedBox(width: 8),
                  Expanded(child: _StatBox(label: 'Drawn', value: '6', color: AppColors.warning)),
                  const SizedBox(width: 8),
                  Expanded(child: _StatBox(label: 'Lost', value: '4', color: AppColors.error)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _StatBox(label: 'Goals For', value: '56', color: AppColors.primary)),
                  const SizedBox(width: 8),
                  Expanded(child: _StatBox(label: 'Goals Against', value: '24', color: AppColors.info)),
                  const SizedBox(width: 8),
                  Expanded(child: _StatBox(label: 'GD', value: '+32', color: AppColors.success)),
                  const SizedBox(width: 8),
                  Expanded(child: _StatBox(label: 'Points', value: '60', color: AppColors.primaryDark)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // League Table (simplified)
        _Card(
          title: 'League Position',
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
            child: const Text('2nd', style: TextStyle(fontSize: 13, color: AppColors.success, fontWeight: FontWeight.w800)),
          ),
          child: Column(
            children: [
              _TableRow(pos: '1', club: 'FC Halifax', pts: '64', isHighlighted: false),
              _TableRow(pos: '2', club: 'Stockport County', pts: '60', isHighlighted: true),
              _TableRow(pos: '3', club: 'Altrincham', pts: '54', isHighlighted: false),
              _TableRow(pos: '4', club: 'South Shields', pts: '48', isHighlighted: false),
              _TableRow(pos: '5', club: 'Curzon Ashton', pts: '42', isHighlighted: false),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Top Scorers
        _Card(
          title: 'Top Scorers',
          child: Column(
            children: [
              _TopScorer(rank: '1', name: 'James Wilson', goals: '14'),
              const _DividerLine(),
              _TopScorer(rank: '2', name: 'Marcus Thompson', goals: '12'),
              const _DividerLine(),
              _TopScorer(rank: '3', name: 'Sam Patel', goals: '9'),
            ],
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}

// ═══════════════════════════════════════════
// NEWS TAB
// ═══════════════════════════════════════════
class _NewsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final news = [
      {'title': 'Wilson nets hat-trick in dominant win over Curzon Ashton', 'date': '2 days ago', 'type': 'Match Report', 'read': '1.2k'},
      {'title': 'New signing: Marcus Thompson joins from FC United', 'date': '5 days ago', 'type': 'Transfer', 'read': '3.4k'},
      {'title': 'Open Trial announced for July 20th at Edgeley Park', 'date': '1 week ago', 'type': 'Announcement', 'read': '2.1k'},
      {'title': 'Youth Academy produces three first-team graduates', 'date': '2 weeks ago', 'type': 'Academy', 'read': '856'},
      {'title': 'Manager signs contract extension until 2027', 'date': '3 weeks ago', 'type': 'Club News', 'read': '4.2k'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: news.length,
      itemBuilder: (context, index) {
        final n = news[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border, width: 0.5),
            boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 6, offset: const Offset(0, 2))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image placeholder
              Container(
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  gradient: LinearGradient(
                    colors: [AppColors.primaryDark.withValues(alpha: 0.8), AppColors.primary.withValues(alpha: 0.4)],
                  ),
                ),
                child: Stack(
                  children: [
                    const Center(child: Icon(Icons.article, color: Colors.white24, size: 48)),
                    Positioned(
                      top: 10, left: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(6)),
                        child: Text(n['type']!, style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(n['title']!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.4)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 12, color: AppColors.textTertiary),
                        const SizedBox(width: 4),
                        Text(n['date']!, style: const TextStyle(fontSize: 11, color: AppColors.textTertiary)),
                        const Spacer(),
                        const Icon(Icons.visibility_outlined, size: 12, color: AppColors.textTertiary),
                        const SizedBox(width: 4),
                        Text('${n['read']} reads', style: const TextStyle(fontSize: 11, color: AppColors.textTertiary)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════
// SHARED WIDGETS
// ═══════════════════════════════════════════

class _Card extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;
  const _Card({required this.title, required this.child, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border, width: 0.5),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 100, child: Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary))),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
        ],
      ),
    );
  }
}

class _FormBadge extends StatelessWidget {
  final String result;
  final Color color;
  const _FormBadge({required this.result, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40, height: 40,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Center(
        child: Text(result, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color)),
      ),
    );
  }
}

class _SigningTile extends StatelessWidget {
  final String name, position, from;
  const _SigningTile({required this.name, required this.position, required this.from});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.person_add, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                Text('$position • from $from', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label, value;
  final Color color;
  const _StatBox({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: color)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _TableRow extends StatelessWidget {
  final String pos, club, pts;
  final bool isHighlighted;
  const _TableRow({required this.pos, required this.club, required this.pts, required this.isHighlighted});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      decoration: isHighlighted
          ? BoxDecoration(color: AppColors.primary.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(8))
          : null,
      child: Row(
        children: [
          SizedBox(width: 24, child: Text(pos, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isHighlighted ? AppColors.primary : AppColors.textTertiary))),
          const SizedBox(width: 8),
          Expanded(child: Text(club, style: TextStyle(fontSize: 13, fontWeight: isHighlighted ? FontWeight.w800 : FontWeight.w500, color: AppColors.textPrimary))),
          Text(pts, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _TopScorer extends StatelessWidget {
  final String rank, name, goals;
  const _TopScorer({required this.rank, required this.name, required this.goals});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(width: 24, child: Text('#$rank', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary))),
          const SizedBox(width: 8),
          Expanded(child: Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
          Text('$goals ⚽', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
        ],
      ),
    );
  }
}

class _TrialLine extends StatelessWidget {
  final String emoji, text;
  const _TrialLine(this.emoji, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _DividerLine extends StatelessWidget {
  const _DividerLine();
  @override
  Widget build(BuildContext context) => const Divider(height: 2, color: AppColors.divider);
}
