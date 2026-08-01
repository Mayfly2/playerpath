import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:playerpath/app/theme/colors.dart';
import 'package:playerpath/core/widgets/scout_widgets.dart';
import 'package:playerpath/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:playerpath/features/players/presentation/cubit/profile_cubit.dart';
import 'package:playerpath/features/players/data/repositories/player_repository.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(PlayerRepository())..loadProfile('player'),
      child: const _ProfileBody(),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authState = context.watch<AuthCubit>().state;
    final user = authState is AuthAuthenticated ? authState.user : null;

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final profile = state is ProfileLoaded ? state.player : <String, dynamic>{};
        final name = profile['fullName'] as String? ?? user?.email ?? 'Player';
        final posList = profile['positions'] as List<dynamic>?;
        final position = posList != null && posList.isNotEmpty
            ? posList.first['position'] ?? 'ST'
            : 'ST';
        final step = profile['currentStep']?.toString() ?? 'Step 4';
        final county = profile['county'] as String? ?? 'Location';

        return Scaffold(
          backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () => context.read<ProfileCubit>().loadProfile('player'),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : AppColors.surface,
                        border: Border(bottom: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.border)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.ios_share, size: 20),
                                onPressed: () {},
                                style: IconButton.styleFrom(backgroundColor: AppColors.surfaceAlt),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 20, color: AppColors.primary),
                                onPressed: () => context.push('/profile/edit'),
                                style: IconButton.styleFrom(backgroundColor: AppColors.primary.withValues(alpha: 0.08)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Stack(
                            children: [
                              Container(
                                width: 88, height: 88,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(color: AppColors.border, width: 2),
                                  color: AppColors.accent.withValues(alpha: 0.2),
                                ),
                                child: Center(
                                  child: Text(
                                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                                    style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: AppColors.primary),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: -2, bottom: -2,
                                child: Container(
                                  width: 26, height: 26,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary, shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2.5),
                                  ),
                                  child: const Icon(Icons.verified, color: Colors.white, size: 14),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(name,
                                  style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
                                  overflow: TextOverflow.ellipsis),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text('94% Match',
                                  style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w700)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text('$position • $step', style: theme.textTheme.bodyMedium),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textTertiary),
                              const SizedBox(width: 2),
                              Text(county, style: theme.textTheme.bodySmall),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
                            ),
                            child: const Text('Available Now',
                              style: TextStyle(fontSize: 11, color: AppColors.success, fontWeight: FontWeight.w700)),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              _ProfileStat(value: '1,234', label: 'Views'),
                              _ProfileStat(value: '486', label: 'Followers'),
                              _ProfileStat(value: '52', label: 'Following'),
                              _ProfileStat(value: '68%', label: 'Complete'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 20)),

                  // Menu
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ScoutCard(
                        padding: EdgeInsets.zero,
                        child: Column(
                          children: [
                            _MenuItem(icon: Icons.person_outline, title: 'View My Profile',
                              subtitle: 'See your full football CV', onTap: () => context.push('/player/1')),
                            const _MenuDivider(),
                            _MenuItem(icon: Icons.play_circle_outline, title: 'My Highlights',
                              subtitle: '4 videos • 2.3k views', onTap: () => context.push('/player/1/highlights')),
                            const _MenuDivider(),
                            _MenuItem(icon: Icons.bookmark_outline, title: 'Saved Clubs',
                              subtitle: '12 clubs saved', badge: '12', onTap: () => context.push('/profile/saved-clubs')),
                            const _MenuDivider(),
                            _MenuItem(icon: Icons.send_outlined, title: 'Application History',
                              subtitle: '5 applications', badge: '5', onTap: () => context.push('/profile/applications')),
                            const _MenuDivider(),
                            _MenuItem(icon: Icons.analytics_outlined, title: 'Profile Analytics',
                              subtitle: 'Views, matches, and insights', onTap: () => context.push('/profile/analytics')),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 16)),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ScoutCard(
                        padding: EdgeInsets.zero,
                        child: Column(
                          children: [
                            _MenuItem(icon: Icons.settings_outlined, title: 'Settings',
                              subtitle: 'Account, notifications, privacy', onTap: () => context.push('/settings')),
                            const _MenuDivider(),
                            _MenuItem(icon: Icons.help_outline, title: 'Help & Support',
                              subtitle: 'FAQs, contact us, report a bug', onTap: () => context.push('/help')),
                            const _MenuDivider(),
                            _MenuItem(icon: Icons.info_outline, title: 'About PlayerPath',
                              subtitle: 'v1.0.0 • Terms & Privacy', onTap: () => context.push('/about')),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 16)),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: double.infinity, height: 54,
                        child: OutlinedButton(
                          onPressed: () {
                            context.read<AuthCubit>().logout();
                            context.go('/login');
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.error,
                            side: const BorderSide(color: AppColors.error),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: const Text('Sign Out', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 40)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String value, label;
  const _ProfileStat({required this.value, required this.label});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final String? badge;
  final VoidCallback onTap;
  const _MenuItem({required this.icon, required this.title, required this.subtitle, this.badge, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ),
            if (badge != null)
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
                child: Text(badge!, style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w700)),
              ),
            const Icon(Icons.chevron_right, color: AppColors.textTertiary, size: 20),
          ],
        ),
      ),
    );
  }
}

class _MenuDivider extends StatelessWidget {
  const _MenuDivider();
  @override
  Widget build(BuildContext context) => const Divider(height: 1, indent: 76, endIndent: 20);
}
