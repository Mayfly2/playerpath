import 'package:flutter/material.dart';
import 'package:playerpath/app/theme/colors.dart';
import 'package:playerpath/core/widgets/scout_widgets.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Help & Support', style: TextStyle(fontWeight: FontWeight.w700))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search
            TextField(
              decoration: InputDecoration(
                hintText: 'Search help articles...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textTertiary),
                filled: true,
                fillColor: AppColors.surface,
              ),
            ),
            const SizedBox(height: 24),

            // Quick Links
            Text('Quick Links', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _QuickLinkCard(icon: Icons.question_answer_outlined, title: 'FAQs', subtitle: 'Common questions', onTap: () {})),
                const SizedBox(width: 10),
                Expanded(child: _QuickLinkCard(icon: Icons.headset_mic_outlined, title: 'Contact Us', subtitle: 'Get in touch', onTap: () {})),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _QuickLinkCard(icon: Icons.bug_report_outlined, title: 'Report Bug', subtitle: 'Found an issue?', onTap: () {})),
                const SizedBox(width: 10),
                Expanded(child: _QuickLinkCard(icon: Icons.lightbulb_outline, title: 'Feature Request', subtitle: 'Suggest ideas', onTap: () {})),
              ],
            ),

            const SizedBox(height: 28),

            // FAQs
            Text('Frequently Asked Questions', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            _FaqTile(
              question: 'How do I get verified?',
              answer: 'Submit proof of your club history and statistics. Our team reviews each submission within 48 hours. Once verified, you\'ll receive a blue checkmark on your profile.',
            ),
            _FaqTile(
              question: 'How does AI matching work?',
              answer: 'Our algorithm analyses your position, step, location, availability, and experience against club requirements. The score ranges from 0-100% and updates automatically.',
            ),
            _FaqTile(
              question: 'Can clubs message me directly?',
              answer: 'Yes! Clubs can send you messages and trial invitations. You can control who can contact you in your Privacy Settings.',
            ),
            _FaqTile(
              question: 'How do I upload highlights?',
              answer: 'Go to My Highlights from your profile, tap the + button, and select videos from your gallery. Max 500MB per video. Supported formats: MP4, MOV.',
            ),
            _FaqTile(
              question: 'Is my data secure?',
              answer: 'Absolutely. We use enterprise-grade encryption. You can export or delete your data at any time from Settings. We are GDPR compliant.',
            ),

            const SizedBox(height: 28),

            // Legal
            Text('Legal', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            _LegalItem(title: 'Privacy Policy', onTap: () {}),
            _LegalItem(title: 'Terms & Conditions', onTap: () {}),
            _LegalItem(title: 'Community Guidelines', onTap: () {}),
            _LegalItem(title: 'Cookie Policy', onTap: () {}),

            const SizedBox(height: 28),

            // About
            Text('About', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            ScoutCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48, height: 48,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: AppColors.orangeGradient),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.sports_soccer, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('PlayerPath', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
                          Text('Version 1.0.0', style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'The UK\'s easiest platform for grassroots football recruitment. Connecting players, clubs, scouts, and managers.',
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _SocialIcon(Icons.language),
                      const SizedBox(width: 16),
                      _SocialIcon(Icons.camera_alt),
                      const SizedBox(width: 16),
                      _SocialIcon(Icons.alternate_email),
                      const SizedBox(width: 16),
                      _SocialIcon(Icons.play_circle_outline),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _QuickLinkCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickLinkCard({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const SizedBox(height: 2),
            Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _FaqTile extends StatefulWidget {
  final String question;
  final String answer;
  const _FaqTile({required this.question, required this.answer});

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return ScoutCard(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      onTap: () => setState(() => _expanded = !_expanded),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(widget.question, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              ),
              Icon(_expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: AppColors.textTertiary),
            ],
          ),
          if (_expanded) ...[
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),
            Text(widget.answer, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5)),
          ],
        ],
      ),
    );
  }
}

class _LegalItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const _LegalItem({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.open_in_new, size: 16, color: AppColors.textTertiary),
      onTap: onTap,
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  const _SocialIcon(this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40, height: 40,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: AppColors.textSecondary, size: 20),
    );
  }
}
