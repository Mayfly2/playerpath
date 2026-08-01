import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:playerpath/app/theme/colors.dart';
import 'package:playerpath/features/settings/presentation/cubit/theme_cubit.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _emailAlerts = true;
  bool _profilePublic = true;
  bool _showOnline = true;
  bool _twoFactor = false;
  String _language = 'English';
  String _units = 'Metric';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.w700))),
      body: ListView(
        children: [
          // ── Account ──
          _SectionHeader('Account'),
          _SettingsTile(
            icon: Icons.person_outline,
            title: 'Edit Profile',
            subtitle: 'Photo, bio, career details',
            onTap: () => context.push('/profile/edit'),
          ),
          _SettingsTile(
            icon: Icons.email_outlined,
            title: 'Email',
            subtitle: 'test@test.com',
            trailing: 'Verified',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.phone_outlined,
            title: 'Phone',
            subtitle: '+44 7000 000000',
            trailing: 'Verified',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.lock_outlined,
            title: 'Password',
            subtitle: '••••••••',
            trailing: 'Change',
            onTap: () {},
          ),
          _SwitchTile(
            icon: Icons.security_outlined,
            title: 'Two-Factor Auth',
            subtitle: 'Add extra security to your account',
            value: _twoFactor,
            onChanged: (v) => setState(() => _twoFactor = v),
          ),

          const SizedBox(height: 16),

          // ── Appearance ──
          _SectionHeader('Appearance'),
          _SwitchTile(
            icon: Icons.dark_mode_outlined,
            title: 'Dark Mode',
            subtitle: 'Switch to dark colour scheme',
            value: context.watch<ThemeCubit>().isDark,
            onChanged: (v) => context.read<ThemeCubit>().setDarkMode(v),
          ),
          _SettingsTile(
            icon: Icons.language_outlined,
            title: 'Language',
            subtitle: _language,
            onTap: () => _showPicker('Language', ['English', 'Spanish', 'French', 'German', 'Italian', 'Portuguese'], _language, (v) => setState(() => _language = v)),
          ),
          _SettingsTile(
            icon: Icons.straighten_outlined,
            title: 'Units',
            subtitle: _units,
            onTap: () => _showPicker('Units', ['Metric', 'Imperial'], _units, (v) => setState(() => _units = v)),
          ),

          const SizedBox(height: 16),

          // ── Notifications ──
          _SectionHeader('Notifications'),
          _SwitchTile(
            icon: Icons.notifications_outlined,
            title: 'Push Notifications',
            subtitle: 'Receive alerts on your device',
            value: _notifications,
            onChanged: (v) => setState(() => _notifications = v),
          ),
          _SwitchTile(
            icon: Icons.email_outlined,
            title: 'Email Alerts',
            subtitle: 'Club interest, messages, trials',
            value: _emailAlerts,
            onChanged: (v) => setState(() => _emailAlerts = v),
          ),

          const SizedBox(height: 16),

          // ── Privacy ──
          _SectionHeader('Privacy'),
          _SwitchTile(
            icon: Icons.public_outlined,
            title: 'Public Profile',
            subtitle: 'Visible to all clubs and scouts',
            value: _profilePublic,
            onChanged: (v) => setState(() => _profilePublic = v),
          ),
          _SwitchTile(
            icon: Icons.circle_outlined,
            title: 'Show Online Status',
            subtitle: 'Let others see when you\'re active',
            value: _showOnline,
            onChanged: (v) => setState(() => _showOnline = v),
          ),
          _SettingsTile(
            icon: Icons.block_outlined,
            title: 'Blocked Users',
            subtitle: '0 users blocked',
            onTap: () {},
          ),

          const SizedBox(height: 16),

          // ── Data ──
          _SectionHeader('Data & Storage'),
          _SettingsTile(
            icon: Icons.download_outlined,
            title: 'Export My Data',
            subtitle: 'Download all your data (GDPR)',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.delete_outline,
            title: 'Clear Cache',
            subtitle: 'Free up storage space',
            onTap: () {},
          ),

          const SizedBox(height: 16),

          // ── Danger Zone ──
          _SectionHeader('Danger Zone', color: AppColors.error),
          _SettingsTile(
            icon: Icons.delete_forever_outlined,
            title: 'Delete Account',
            subtitle: 'Permanently delete your account and data',
            isDestructive: true,
            onTap: () => _showDeleteConfirmation(context),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void _showPicker(String title, List<String> options, String current, Function(String) onSelect) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 36, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            ...options.map((o) => ListTile(
              title: Text(o, style: TextStyle(fontWeight: o == current ? FontWeight.w700 : FontWeight.w400, color: o == current ? AppColors.primary : AppColors.textPrimary)),
              trailing: o == current ? const Icon(Icons.check, color: AppColors.primary) : null,
              onTap: () {
                onSelect(o);
                Navigator.pop(ctx);
              },
            )),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Account?', style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text('This action cannot be undone. All your data, including profile, highlights, and applications, will be permanently deleted.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Color? color;
  const _SectionHeader(this.title, {this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color ?? AppColors.textTertiary, letterSpacing: 0.5)),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? trailing;
  final bool isDestructive;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.isDestructive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      leading: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: isDestructive ? AppColors.error.withValues(alpha: 0.08) : AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: isDestructive ? AppColors.error : AppColors.textSecondary, size: 20),
      ),
      title: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isDestructive ? AppColors.error : AppColors.textPrimary)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null) ...[
            Text(trailing!, style: const TextStyle(fontSize: 12, color: AppColors.textTertiary)),
            const SizedBox(width: 4),
          ],
          const Icon(Icons.chevron_right, color: AppColors.textTertiary, size: 20),
        ],
      ),
      onTap: onTap,
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      leading: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: AppColors.textSecondary, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppColors.primary,
      ),
    );
  }
}
