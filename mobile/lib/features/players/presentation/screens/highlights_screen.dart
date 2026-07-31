import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:playerpath/app/theme/colors.dart';
import 'package:playerpath/core/services/image_service.dart';

class HighlightsScreen extends StatefulWidget {
  const HighlightsScreen({super.key});

  @override
  State<HighlightsScreen> createState() => _HighlightsScreenState();
}

class _HighlightsScreenState extends State<HighlightsScreen> {
  String _activeFilter = 'All';
  final List<_HighlightVideo> _videos = [
    _HighlightVideo(title: 'Hat-trick vs FC United', views: 1245, duration: '2:34', date: '15 Jul', category: 'goals'),
    _HighlightVideo(title: 'Pre-season training', views: 856, duration: '1:45', date: '10 Jul', category: 'training'),
    _HighlightVideo(title: 'Best skills 2025', views: 342, duration: '3:12', date: '5 Jul', category: 'skills'),
    _HighlightVideo(title: 'Match highlights', views: 2180, duration: '4:18', date: '28 Jun', category: 'goals'),
    _HighlightVideo(title: 'Fitness drill', views: 189, duration: '1:02', date: '20 Jun', category: 'fitness'),
    _HighlightVideo(title: 'Defending masterclass', views: 567, duration: '2:51', date: '15 Jun', category: 'defending'),
  ];

  bool _isUploading = false;

  void _uploadVideo() async {
    final file = await ImageService.showImagePicker(context, title: 'Upload Highlight');
    if (file != null) {
      setState(() => _isUploading = true);
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        setState(() {
          _isUploading = false;
          _videos.insert(0, _HighlightVideo(
            title: 'New Highlight',
            views: 0,
            duration: '0:30',
            date: 'Just now',
            category: 'goals',
          ));
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✓ Video uploaded successfully'), backgroundColor: AppColors.success),
        );
      }
    }
  }

  void _deleteVideo(int index) {
    final video = _videos[index];
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Highlight?', style: TextStyle(fontWeight: FontWeight.w800)),
        content: Text('"${video.title}" will be permanently deleted.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() => _videos.removeAt(index));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Video deleted'), backgroundColor: AppColors.textPrimary),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _renameVideo(int index) {
    final controller = TextEditingController(text: _videos[index].title);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Rename Video', style: TextStyle(fontWeight: FontWeight.w800)),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Video title'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() => _videos[index].title = controller.text);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  List<_HighlightVideo> get _filteredVideos {
    if (_activeFilter == 'All') return _videos;
    return _videos.where((v) => v.category == _activeFilter.toLowerCase()).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = _filteredVideos;
    final categories = ['All', 'Goals', 'Skills', 'Training', 'Fitness', 'Passing', 'Defending'];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 16, 4),
              child: Row(
                children: [
                  IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text('My Highlights', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                  ),
                  if (_isUploading)
                    const Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                    ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: AppColors.orangeGradient),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 2))],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: _isUploading ? null : _uploadVideo,
                    ),
                  ),
                ],
              ),
            ),

            // Upload prompt
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.cloud_upload_outlined, color: AppColors.primaryDark, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Upload Highlights', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primaryDark)),
                          Text('Share your best moments. Max 500MB.', style: theme.textTheme.bodySmall?.copyWith(color: AppColors.primaryDark.withValues(alpha: 0.7))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Category chips
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length,
                itemBuilder: (_, i) {
                  final cat = categories[i];
                  final selected = _activeFilter == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(cat),
                      selected: selected,
                      onSelected: (_) => setState(() => _activeFilter = cat),
                      selectedColor: AppColors.primary,
                      checkmarkColor: Colors.white,
                      backgroundColor: AppColors.surface,
                      side: BorderSide(color: selected ? AppColors.primary : AppColors.border),
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),

            // Video grid
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.videocam_off_outlined, size: 48, color: AppColors.textTertiary),
                          const SizedBox(height: 12),
                          Text('No videos in this category', style: theme.textTheme.bodyMedium),
                          const SizedBox(height: 4),
                          Text('Upload your first highlight!', style: theme.textTheme.bodySmall),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(20),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.82,
                      ),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final v = filtered[index];
                        final globalIndex = _videos.indexOf(v);
                        return GestureDetector(
                          onTap: () {},
                          onLongPress: () => _showVideoOptions(context, globalIndex),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.border, width: 0.5),
                              boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 4, offset: const Offset(0, 1))],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Thumbnail
                                Stack(
                                  children: [
                                    Container(
                                      height: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                        gradient: LinearGradient(
                                          colors: [AppColors.primaryDark.withValues(alpha: 0.8), AppColors.primary.withValues(alpha: 0.5)],
                                        ),
                                      ),
                                      child: const Center(
                                        child: Icon(Icons.play_circle_fill, color: Colors.white, size: 36),
                                      ),
                                    ),
                                    Positioned(
                                      top: 6, right: 6,
                                      child: GestureDetector(
                                        onTap: () => _deleteVideo(globalIndex),
                                        child: Container(
                                          width: 26, height: 26,
                                          decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(8)),
                                          child: const Icon(Icons.close, color: Colors.white, size: 15),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 8, right: 8,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(4)),
                                        child: Text(v.duration, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(v.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Icon(Icons.visibility_outlined, size: 12, color: AppColors.textTertiary),
                                          const SizedBox(width: 3),
                                          Text(_formatViews(v.views), style: const TextStyle(fontSize: 10, color: AppColors.textTertiary)),
                                          const Spacer(),
                                          Text(v.date, style: const TextStyle(fontSize: 10, color: AppColors.textTertiary)),
                                        ],
                                      ),
                                    ],
                                  ),
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
      ),
    );
  }

  void _showVideoOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 36, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.edit_outlined, color: AppColors.primary),
                title: const Text('Rename', style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () { Navigator.pop(ctx); _renameVideo(index); },
              ),
              ListTile(
                leading: const Icon(Icons.play_circle_outline, color: AppColors.info),
                title: const Text('Play Fullscreen', style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () => Navigator.pop(ctx),
              ),
              ListTile(
                leading: const Icon(Icons.ios_share, color: AppColors.warning),
                title: const Text('Share', style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () => Navigator.pop(ctx),
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: AppColors.error),
                title: const Text('Delete', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.error)),
                onTap: () { Navigator.pop(ctx); _deleteVideo(index); },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatViews(int views) {
    if (views >= 1000) return '${(views / 1000).toStringAsFixed(1)}k';
    return views.toString();
  }
}

class _HighlightVideo {
  String title;
  final int views;
  final String duration;
  final String date;
  final String category;

  _HighlightVideo({
    required this.title,
    required this.views,
    required this.duration,
    required this.date,
    required this.category,
  });
}
