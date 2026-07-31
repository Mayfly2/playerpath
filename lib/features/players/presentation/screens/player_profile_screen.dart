import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:playerpath/app/theme/colors.dart';
import 'package:playerpath/core/services/share_service.dart';

class PlayerProfileScreen extends StatefulWidget {
  const PlayerProfileScreen({super.key});

  @override
  State<PlayerProfileScreen> createState() => _PlayerProfileScreenState();
}

class _PlayerProfileScreenState extends State<PlayerProfileScreen> {
  bool _bioExpanded = false;
  bool _cvExpanded = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final topPadding = MediaQuery.of(context).padding.top;
    final bannerHeight = 200.0;
    final avatarRadius = 52.0;
    final avatarDiameter = avatarRadius * 2;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── COVER BANNER + AVATAR ──
          SliverToBoxAdapter(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Banner
                Container(
                  height: bannerHeight,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFF97316), Color(0xFFFB923C)],
                    ),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
                  ),
                ),

                // Back button
                Positioned(
                  top: topPadding + 4,
                  left: 12,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
                    onPressed: () => context.pop(),
                    style: IconButton.styleFrom(backgroundColor: Colors.white24),
                  ),
                ),

                // Share button
                Positioned(
                  top: topPadding + 4,
                  right: 12,
                  child: IconButton(
                    icon: const Icon(Icons.ios_share, color: Colors.white, size: 20),
                    onPressed: () => _showShareSheet(context),
                    style: IconButton.styleFrom(backgroundColor: Colors.white24),
                  ),
                ),

                // Avatar — centered, overlapping banner bottom by ~25%
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: -(avatarRadius * 0.5),
                  child: Center(
                    child: Container(
                      width: avatarDiameter,
                      height: avatarDiameter,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.18),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary.withValues(alpha: 0.10),
                          ),
                          child: const Center(
                            child: Icon(Icons.person, size: 44, color: Color(0xFFF97316)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── PLAYER NAME + INFO (always below avatar) ──
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, avatarRadius * 0.5 + 20, 24, 16),
              child: Column(
                children: [
                  // Name + Verified
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          'James Wilson',
                          style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.verified, color: AppColors.primary, size: 22),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Badges row
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _Badge(text: 'ST', color: AppColors.primary),
                      _Badge(text: '22 yrs', color: AppColors.textSecondary),
                      _Badge(text: 'Step 4', color: AppColors.info),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Club + Location
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.shield_outlined, size: 14, color: AppColors.textTertiary),
                      const SizedBox(width: 4),
                      Text('Stockport County', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
                      const SizedBox(width: 14),
                      const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textTertiary),
                      const SizedBox(width: 4),
                      Flexible(child: Text('Greater Manchester', style: theme.textTheme.bodySmall, overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Availability + Match Score
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
                        ),
                        child: const Text('Available Now', style: TextStyle(fontSize: 11, color: AppColors.success, fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(width: 16),
                      // AI Match
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: AppColors.orangeGradient),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text('94% Match', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── QUICK ACTIONS ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _QuickAction(
                      icon: Icons.edit_outlined,
                      label: 'Edit Profile',
                      onTap: () => context.push('/profile/edit'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _QuickAction(
                      icon: Icons.play_circle_outline,
                      label: 'Highlights',
                      onTap: () => context.push('/player/1/highlights'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _QuickAction(
                      icon: Icons.analytics_outlined,
                      label: 'Analytics',
                      onTap: () => context.push('/profile/analytics'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _QuickAction(
                      icon: Icons.bookmark_outline,
                      label: 'Saved',
                      onTap: () => context.push('/profile/saved-clubs'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── STATISTICS CARDS ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle(title: 'Season Statistics', badge: '2025/26'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _StatCard(icon: Icons.sports_soccer, label: 'Matches', value: '28', color: AppColors.primary)),
                      const SizedBox(width: 8),
                      Expanded(child: _StatCard(icon: Icons.gps_fixed, label: 'Goals', value: '14', color: AppColors.success)),
                      const SizedBox(width: 8),
                      Expanded(child: _StatCard(icon: Icons.auto_graph, label: 'Assists', value: '8', color: AppColors.info)),
                      const SizedBox(width: 8),
                      Expanded(child: _StatCard(icon: Icons.timer_outlined, label: 'Minutes', value: '2,240', color: AppColors.warning)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: _StatCard(icon: Icons.trending_up, label: 'Match %', value: '94', color: AppColors.primary)),
                      const SizedBox(width: 8),
                      Expanded(child: _StatCard(icon: Icons.speed, label: 'Gls/Game', value: '0.50', color: AppColors.success)),
                      const SizedBox(width: 8),
                      Expanded(child: _StatCard(icon: Icons.straighten, label: 'Clean Sheets', value: '6', color: AppColors.info)),
                      const SizedBox(width: 8),
                      Expanded(child: _StatCard(icon: Icons.square_foot, label: 'Yellows', value: '2', color: AppColors.warning)),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // ── ABOUT ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionTitle(title: 'About'),
                    const SizedBox(height: 10),
                    Text(
                      'Quick and creative forward with an eye for goal. Comfortable playing as a lone striker or in a front two. Strong finisher with both feet, excellent movement off the ball, and a high football IQ. Looking for a club at Step 3-4 with ambitions of climbing the pyramid. Previously at Manchester United Academy and Altrincham FC youth setups.',
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.7, color: AppColors.textSecondary),
                      maxLines: _bioExpanded ? null : 3,
                      overflow: _bioExpanded ? null : TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => setState(() => _bioExpanded = !_bioExpanded),
                      child: Text(
                        _bioExpanded ? 'Show less' : 'Read more',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // ── FOOTBALL CV ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _cvExpanded = !_cvExpanded),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _SectionTitle(title: 'Football CV'),
                          Icon(_cvExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: AppColors.textTertiary),
                        ],
                      ),
                    ),
                    if (_cvExpanded) ...[
                      const SizedBox(height: 4),

                      // Personal
                      const _CvSubsection(label: 'Personal'),
                      _CvRow(label: 'Age', value: '22 years (15 May 2002)'),
                      _CvRow(label: 'Height', value: '182 cm (6\'0")'),
                      _CvRow(label: 'Weight', value: '76 kg'),
                      _CvRow(label: 'Preferred Foot', value: 'Right'),
                      _CvRow(label: 'Languages', value: 'English, Spanish'),
                      const SizedBox(height: 12),

                      // Football
                      const _CvSubsection(label: 'Football'),
                      _CvRow(label: 'Position', value: 'Striker (ST)'),
                      _CvRow(label: 'Secondary', value: 'Left Wing (LW)'),
                      _CvRow(label: 'Current Club', value: 'Stockport County'),
                      _CvRow(label: 'Current Step', value: 'Step 4'),
                      _CvRow(label: 'Highest Step', value: 'Step 4'),
                      _CvRow(label: 'Years Played', value: '9 years'),
                      const SizedBox(height: 12),

                      // Location & Availability
                      const _CvSubsection(label: 'Location & Availability'),
                      _CvRow(label: 'County', value: 'Greater Manchester'),
                      _CvRow(label: 'Travel Distance', value: 'Up to 30 miles'),
                      _CvRow(label: 'Availability', value: 'Available Immediately'),
                      _CvRow(label: 'Contract Status', value: 'Free Agent'),
                      const SizedBox(height: 12),

                      // Style
                      const _CvSubsection(label: 'Playing Style'),
                      Wrap(
                        spacing: 6, runSpacing: 6,
                        children: ['Pacey', 'Clinical Finisher', 'Good in Air', 'Link-up Play', 'Pressing', 'Both Feet'].map((s) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(s, style: const TextStyle(fontSize: 11, color: AppColors.primaryDark, fontWeight: FontWeight.w600)),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // ── CLUB HISTORY ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionTitle(title: 'Club History'),
                    const SizedBox(height: 12),
                    _ClubHistoryTile(club: 'Stockport County', years: '2023 - Present', step: 'Step 4', isCurrent: true),
                    const _DividerLine(),
                    _ClubHistoryTile(club: 'Altrincham FC', years: '2020 - 2023', step: 'Youth', isCurrent: false),
                    const _DividerLine(),
                    _ClubHistoryTile(club: 'Manchester United', years: '2016 - 2020', step: 'Academy', isCurrent: false),
                  ],
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // ── ACHIEVEMENTS ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionTitle(title: 'Achievements'),
                    const SizedBox(height: 12),
                    _AchievementTile(icon: Icons.emoji_events, title: 'Top Scorer 2025', subtitle: 'National League North • 14 goals', color: AppColors.warning),
                    const _DividerLine(),
                    _AchievementTile(icon: Icons.star, title: 'Player of the Month', subtitle: 'August 2024 • Stockport County', color: AppColors.primary),
                    const _DividerLine(),
                    _AchievementTile(icon: Icons.school, title: 'Academy Graduate', subtitle: 'Manchester United Academy 2016-2020', color: AppColors.info),
                  ],
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // ── HIGHLIGHTS PREVIEW ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _Card(
                onTap: () => context.push('/player/1/highlights'),
                child: Row(
                  children: [
                    Container(
                      width: 56, height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: AppColors.orangeGradient),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.play_arrow, color: Colors.white, size: 30),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('My Highlights', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                          const SizedBox(height: 2),
                          Text('4 videos • 2.3k views • Updated 2 days ago', style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text('View All', style: TextStyle(fontSize: 12, color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // ── ACTION BUTTONS ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () => context.push('/messages'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.message_outlined, size: 20),
                            SizedBox(width: 8),
                            Text('Message', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 52, height: 52,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.surface,
                        foregroundColor: AppColors.primary,
                        padding: EdgeInsets.zero,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: const BorderSide(color: AppColors.border),
                        ),
                      ),
                      child: const Icon(Icons.bookmark_border, size: 22),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 52, height: 52,
                    child: ElevatedButton(
                      onPressed: () => _showShareSheet(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.surface,
                        foregroundColor: AppColors.primary,
                        padding: EdgeInsets.zero,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: const BorderSide(color: AppColors.border),
                        ),
                      ),
                      child: const Icon(Icons.ios_share, size: 22),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  void _showShareSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 36, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
                const SizedBox(height: 20),
                Text('Share Profile', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _ShareOpt(
                      icon: Icons.link,
                      label: 'Copy Link',
                      color: AppColors.primary,
                      onTap: () async {
                        await ShareService.copyProfileLink(playerName: 'James Wilson');
                        if (ctx.mounted) {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('✓ Link copied successfully'), backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating),
                          );
                            }
                          },
                        ),
                        _ShareOpt(
                          icon: Icons.chat_bubble_outline,
                          label: 'Message',
                          color: AppColors.info,
                          onTap: () async {
                            Navigator.pop(ctx);
                            await ShareService.shareProfile(playerName: 'James Wilson', position: 'ST', club: 'Stockport County');
                          },
                        ),
                        _ShareOpt(
                          icon: Icons.mail_outline,
                          label: 'Email',
                          color: AppColors.warning,
                          onTap: () async {
                            Navigator.pop(ctx);
                            await ShareService.emailProfile(playerName: 'James Wilson', position: 'ST', step: 'Step 4');
                          },
                        ),
                        _ShareOpt(
                          icon: Icons.download,
                          label: 'Download CV',
                          color: AppColors.success,
                          onTap: () async {
                            Navigator.pop(ctx);
                            await ShareService.downloadCV(
                              playerName: 'James Wilson',
                              age: '22',
                              position: 'ST',
                              preferredFoot: 'Right',
                              currentClub: 'Stockport County',
                              currentStep: 'Step 4',
                              height: '182 cm',
                              weight: '76 kg',
                              county: 'Greater Manchester',
                              availability: 'Available Immediately',
                              achievements: ['Top Scorer 2025', 'Player of the Month Aug 2024', 'Academy Graduate'],
                              clubHistory: [
                                {'club': 'Stockport County', 'years': '2023-Present', 'step': 'Step 4'},
                                {'club': 'Altrincham FC', 'years': '2020-2023', 'step': 'Youth'},
                                {'club': 'Man United', 'years': '2016-2020', 'step': 'Academy'},
                              ],
                              stats: {'Matches': '28', 'Goals': '14', 'Assists': '8', 'Minutes': '2,240'},
                              email: 'james@example.com',
                              phone: '+44 7000 000000',
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      }
}

// ── REUSABLE WIDGETS ──

class _Card extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  const _Card({required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border, width: 0.5),
          boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: child,
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String? badge;
  const _SectionTitle({required this.title, this.badge});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        if (badge != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(8)),
            child: Text(badge!, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700, fontSize: 11)),
          ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  const _Badge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w700)),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickAction({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 22),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _StatCard({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 0.5),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 4, offset: const Offset(0, 1))],
      ),
      child: Column(
        children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          const SizedBox(height: 1),
          Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _CvSubsection extends StatelessWidget {
  final String label;
  const _CvSubsection({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary, letterSpacing: 0.3)),
    );
  }
}

class _CvRow extends StatelessWidget {
  final String label;
  final String value;
  const _CvRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          ),
        ],
      ),
    );
  }
}

class _ClubHistoryTile extends StatelessWidget {
  final String club;
  final String years;
  final String step;
  final bool isCurrent;
  const _ClubHistoryTile({required this.club, required this.years, required this.step, required this.isCurrent});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: isCurrent ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isCurrent ? Icons.shield : Icons.shield_outlined,
              color: isCurrent ? AppColors.primary : AppColors.textTertiary,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(club, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                Text('$years • $step', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          if (isCurrent)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(6)),
              child: const Text('Current', style: TextStyle(fontSize: 10, color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
            ),
        ],
      ),
    );
  }
}

class _DividerLine extends StatelessWidget {
  const _DividerLine();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 2, color: AppColors.divider);
  }
}

class _AchievementTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  const _AchievementTile({required this.icon, required this.title, required this.subtitle, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShareOpt extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ShareOpt({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
      children: [
        Container(
          width: 56, height: 56,
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
      ],
    ),
    );
  }
}
