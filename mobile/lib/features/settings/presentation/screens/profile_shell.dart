import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileShell extends StatelessWidget {
  final StatefulNavigationShell? navigationShell;

  const ProfileShell({super.key, this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell ?? const Center(child: Text('Profile')),
      bottomNavigationBar: navigationShell != null
          ? NavigationBar(
              selectedIndex: navigationShell!.currentIndex,
              onDestinationSelected: (index) {
                navigationShell!.goBranch(
                  index,
                  initialLocation: index == navigationShell!.currentIndex,
                );
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.search_outlined),
                  selectedIcon: Icon(Icons.search),
                  label: 'Discover',
                ),
                NavigationDestination(
                  icon: Icon(Icons.message_outlined),
                  selectedIcon: Icon(Icons.message),
                  label: 'Messages',
                ),
                NavigationDestination(
                  icon: Icon(Icons.notifications_outlined),
                  selectedIcon: Icon(Icons.notifications),
                  label: 'Alerts',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outlined),
                  selectedIcon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            )
          : null,
    );
  }
}
