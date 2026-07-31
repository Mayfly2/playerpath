import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:playerpath/app/theme/colors.dart';
import 'package:playerpath/core/widgets/scout_widgets.dart';
import 'package:playerpath/core/widgets/club_badge.dart';

class SavedClubsScreen extends StatefulWidget {
  const SavedClubsScreen({super.key});

  @override
  State<SavedClubsScreen> createState() => _SavedClubsScreenState();
}

class _SavedClubsScreenState extends State<SavedClubsScreen> {
  String _sortBy = 'Recent';
  String _searchQuery = '';
  final List<Map<String, String>> _allClubs = [
    {'name': 'Stockport County', 'league': 'National League North', 'step': 'Step 4', 'dist': '2.1 mi', 'saved': '2 days ago', 'score': '92'},
    {'name': 'FC Halifax Town', 'league': 'National League', 'step': 'Step 1', 'dist': '4.5 mi', 'saved': '5 days ago', 'score': '87'},
    {'name': 'Altrincham FC', 'league': 'National League North', 'step': 'Step 2', 'dist': '6.8 mi', 'saved': '1 week ago', 'score': '78'},
    {'name': 'Macclesfield FC', 'league': 'NPL Premier', 'step': 'Step 3', 'dist': '8.2 mi', 'saved': '1 week ago', 'score': '74'},
    {'name': 'Bury FC', 'league': 'NW Counties Premier', 'step': 'Step 5', 'dist': '18.7 mi', 'saved': '2 weeks ago', 'score': '88'},
    {'name': 'South Shields', 'league': 'National League North', 'step': 'Step 2', 'dist': '15.3 mi', 'saved': '3 weeks ago', 'score': '79'},
    {'name': 'Curzon Ashton', 'league': 'National League North', 'step': 'Step 2', 'dist': '12.0 mi', 'saved': '1 month ago', 'score': '82'},
    {'name': 'Chester FC', 'league': 'National League North', 'step': 'Step 2', 'dist': '22.1 mi', 'saved': '1 month ago', 'score': '76'},
    {'name': 'FC United', 'league': 'NPL Premier', 'step': 'Step 3', 'dist': '5.3 mi', 'saved': '2 months ago', 'score': '90'},
    {'name': 'Warrington Town', 'league': 'National League North', 'step': 'Step 2', 'dist': '18.0 mi', 'saved': '2 months ago', 'score': '71'},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    var clubs = List<Map<String, String>>.from(_allClubs);
    if (_searchQuery.isNotEmpty) {
      clubs = clubs.where((c) => c['name']!.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    if (_sortBy == 'Match') {
      clubs.sort((a, b) => int.parse(b['score']!).compareTo(int.parse(a['score']!)));
    } else if (_sortBy == 'Distance') {
      clubs.sort((a, b) {
        final da = double.parse(a['dist']!.split(' ')[0]);
        final db = double.parse(b['dist']!.split(' ')[0]);
        return da.compareTo(db);
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Saved Clubs', style: TextStyle(fontWeight: FontWeight.w700))),
      body: Column(
        children: [
          // Search + Sort
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search saved clubs...',
                      prefixIcon: const Icon(Icons.search, color: AppColors.textTertiary, size: 20),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    onChanged: (v) => setState(() => _searchQuery = v),
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  onSelected: (v) => setState(() => _sortBy = v),
                  itemBuilder: (_) => ['Recent', 'Match', 'Distance', 'Name'].map((e) => PopupMenuItem(value: e, child: Text(e))).toList(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.sort, size: 18, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(_sortBy, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        const Icon(Icons.arrow_drop_down, color: AppColors.textTertiary),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Results
          Expanded(
            child: clubs.isEmpty
                ? const EmptyState(
                    icon: Icons.bookmark_border,
                    title: 'No saved clubs',
                    subtitle: 'Start exploring and save clubs you\'re interested in',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: clubs.length,
                    itemBuilder: (context, index) {
                      final c = clubs[index];
                      return Dismissible(
                        key: Key(c['name']!),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.bookmark_remove, color: AppColors.error),
                        ),
                        onDismissed: (_) {
                          setState(() => _allClubs.removeWhere((x) => x['name'] == c['name']));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Club removed from saved'), backgroundColor: AppColors.textPrimary),
                          );
                        },
                        child: ScoutCard(
                          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                          onTap: () => context.push('/club/1'),
                          child: Row(
                            children: [
                              Container(
                                width: 48, height: 48,
                                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(14)),
                                child: ClubBadge(clubName: c['name']!, size: 48),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(c['name']!, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                                    const SizedBox(height: 2),
                                    Text('${c['league']} • ${c['step']} • ${c['dist']}', style: theme.textTheme.bodySmall),
                                    const SizedBox(height: 3),
                                    Text('Saved ${c['saved']}', style: theme.textTheme.labelSmall),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  MatchScoreBadge(score: int.parse(c['score']!), size: 40),
                                  const SizedBox(height: 6),
                                  SizedBox(
                                    height: 34,
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        minimumSize: Size.zero,
                                        textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                                      ),
                                      child: const Text('Apply'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
