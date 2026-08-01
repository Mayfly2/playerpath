import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/colors.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/feed/presentation/screens/home_screen.dart';
import '../../features/feed/presentation/screens/see_all_screens.dart';
import '../../features/search/presentation/screens/discover_screen.dart';
import '../../features/messaging/presentation/screens/messages_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/settings/presentation/screens/profile_screen.dart';
import '../../features/settings/presentation/screens/edit_profile_screen.dart';
import '../../features/settings/presentation/screens/saved_clubs_screen.dart';
import '../../features/settings/presentation/screens/application_history_screen.dart';
import '../../features/settings/presentation/screens/profile_analytics_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/settings/presentation/screens/help_support_screen.dart';
import '../../features/players/presentation/screens/player_profile_screen.dart';
import '../../features/players/presentation/screens/highlights_screen.dart';
import '../../features/clubs/presentation/screens/club_profile_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';

class AppRouter {
  static GoRouter createRouter({required bool isAuthenticated}) {
    return GoRouter(
      initialLocation: isAuthenticated ? '/home' : '/login',
      routes: [
        // ── Auth ──
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/signup',
          name: 'signup',
          builder: (context, state) => const SignupScreen(),
        ),

        // ── Main Shell ──
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return _AppShell(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/home',
                  name: 'home',
                  builder: (context, state) => const HomeScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/discover',
                  name: 'discover',
                  builder: (context, state) => const DiscoverScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/messages',
                  name: 'messages',
                  builder: (context, state) => const MessagesScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/notifications',
                  name: 'notifications',
                  builder: (context, state) => const NotificationsScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/profile',
                  name: 'profile',
                  builder: (context, state) => const ProfileScreen(),
                ),
              ],
            ),
          ],
        ),

        // ── Player Detail ──
        GoRoute(
          path: '/player/:id',
          builder: (context, state) => const PlayerProfileScreen(),
          routes: [
            GoRoute(path: 'highlights', builder: (context, state) => const HighlightsScreen()),
          ],
        ),

        // ── Club Detail ──
        GoRoute(path: '/club/:id', builder: (context, state) => const ClubProfileScreen()),

        // ── See All Screens ──
        GoRoute(path: '/clubs/all', builder: (context, state) => const AllClubsScreen()),
        GoRoute(path: '/trials', builder: (context, state) => const AllTrialsScreen()),
        GoRoute(path: '/players/all', builder: (context, state) => const AllPlayersScreen()),
        GoRoute(path: '/search', builder: (context, state) => const SearchScreen()),

        // ── Profile Sub-Screens ──
        GoRoute(path: '/profile/edit', builder: (context, state) => const EditProfileScreen()),
        GoRoute(path: '/profile/saved-clubs', builder: (context, state) => const SavedClubsScreen()),
        GoRoute(path: '/profile/applications', builder: (context, state) => const ApplicationHistoryScreen()),
        GoRoute(path: '/profile/analytics', builder: (context, state) => const ProfileAnalyticsScreen()),

        // ── Settings ──
        GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),

        // ── Help & About ──
        GoRoute(path: '/help', builder: (context, state) => const HelpSupportScreen()),
        GoRoute(path: '/about', builder: (context, state) => const AboutScreen()),
      ],
    );
  }
}

class _AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const _AppShell({required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);
        },
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        indicatorColor: AppColors.primary.withValues(alpha: 0.1),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore), label: 'Discover'),
          NavigationDestination(icon: Icon(Icons.message_outlined), selectedIcon: Icon(Icons.message), label: 'Messages'),
          NavigationDestination(icon: Icon(Icons.notifications_outlined), selectedIcon: Icon(Icons.notifications), label: 'Alerts'),
          NavigationDestination(icon: Icon(Icons.person_outlined), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('About PlayerPath', style: TextStyle(fontWeight: FontWeight.w700))),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: AppColors.orangeGradient),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(Icons.sports_soccer, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 24),
              Text('PlayerPath', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text('Version 1.0.0 (Build 42)', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 16),
              Text('The UK\'s premier grassroots football recruitment platform. Connecting talented players with ambitious clubs.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6)),
              const SizedBox(height: 32),
              Text('Made with ❤️ in Manchester', style: Theme.of(context).textTheme.bodySmall),
              Text('© 2025 PlayerPath Ltd', style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
        ),
      ),
    );
  }
}
