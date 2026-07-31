import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';

class ClubBadge extends StatelessWidget {
  final String clubName;
  final String? imageUrl;
  final double size;
  final double borderRadius;
  final bool showBorder;

  const ClubBadge({
    super.key,
    required this.clubName,
    this.imageUrl,
    this.size = 48,
    this.borderRadius = 14,
    this.showBorder = false,
  });

  String get _initials {
    final words = clubName.split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return clubName.substring(0, 2).toUpperCase();
  }

  Color get _bgColor {
    final colors = [
      const Color(0xFFFFEDD5),
      const Color(0xFFDBEAFE),
      const Color(0xFFD1FAE5),
      const Color(0xFFFEE2E2),
      const Color(0xFFEDE9FE),
      const Color(0xFFFEF3C7),
    ];
    return colors[clubName.hashCode.abs() % colors.length];
  }

  Color get _textColor {
    final colors = [
      const Color(0xFFEA580C),
      const Color(0xFF2563EB),
      const Color(0xFF059669),
      const Color(0xFFDC2626),
      const Color(0xFF7C3AED),
      const Color(0xFFD97706),
    ];
    return colors[clubName.hashCode.abs() % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: imageUrl != null ? null : _bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: showBorder ? Border.all(color: AppColors.border, width: 0.5) : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: imageUrl != null
          ? Image.network(imageUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _buildInitials())
          : _buildInitials(),
    );
  }

  Widget _buildInitials() {
    return Center(
      child: Text(
        _initials,
        style: TextStyle(
          fontSize: size * 0.38,
          fontWeight: FontWeight.w800,
          color: _textColor,
          letterSpacing: -0.5,
        ),
      ),
    );
  }
}
