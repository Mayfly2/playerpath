import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:playerpath/app/theme/colors.dart';
import 'package:playerpath/core/widgets/scout_widgets.dart';
import 'package:playerpath/core/services/image_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  Uint8List? _profileImage;
  Uint8List? _coverImage;
  final _bioCtrl = TextEditingController(text: 'Quick and creative forward with an eye for goal.');
  final _phoneCtrl = TextEditingController(text: '+44 7000 000000');
  final _emailCtrl = TextEditingController(text: 'james@example.com');
  final _instagramCtrl = TextEditingController(text: '@jameswilson9');
  final _twitterCtrl = TextEditingController(text: '@jw9_football');
  final _tiktokCtrl = TextEditingController(text: '@james_wilson');
  String _position = 'ST';
  String _secondaryPosition = 'LW';
  String _preferredFoot = 'Right';
  String _currentClub = 'Stockport County';
  String _currentStep = 'Step 4';
  String _highestStep = 'Step 4';
  String _county = 'Greater Manchester';
  String _travelDistance = '30 miles';
  String _availability = 'Available Immediately';
  int _height = 182;
  int _weight = 76;
  int _age = 22;
  final List<String> _languages = ['English', 'Spanish'];
  final List<String> _achievements = ['Top Scorer 2025', 'Player of the Month Aug 2024'];

  bool _isSaving = false;

  @override
  void dispose() {
    _bioCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _instagramCtrl.dispose();
    _twitterCtrl.dispose();
    _tiktokCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => context.pop()),
        title: const Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.w700)),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _handleSave,
            child: _isSaving
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Save', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo section
              _SectionTitle('Photos'),
              const SizedBox(height: 12),
              Row(
                children: [
                  // Profile photo
                  GestureDetector(
                    onTap: () async {
                      final file = await ImageService.showImagePicker(context, title: 'Profile Photo');
                      if (file != null) {
                        final bytes = await ImageService.readAsBytes(file);
                        if (bytes != null && mounted) setState(() => _profileImage = bytes);
                      }
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 80, height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 2),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: _profileImage != null
                              ? Image.memory(_profileImage!, fit: BoxFit.cover)
                              : Container(
                                  color: AppColors.accent,
                                  child: const Center(child: Icon(Icons.person, size: 36, color: AppColors.primary)),
                                ),
                        ),
                        const SizedBox(height: 8),
                        Text('Profile Photo', style: TextStyle(fontSize: 11, color: AppColors.textTertiary)),
                        Text('Tap to change', style: TextStyle(fontSize: 10, color: AppColors.primary)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Cover photo
                  GestureDetector(
                    onTap: () async {
                      final file = await ImageService.showImagePicker(context, title: 'Cover Photo');
                      if (file != null) {
                        final bytes = await ImageService.readAsBytes(file);
                        if (bytes != null && mounted) setState(() => _coverImage = bytes);
                      }
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 120, height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: _coverImage != null
                              ? Image.memory(_coverImage!, fit: BoxFit.cover)
                              : Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(colors: AppColors.orangeGradient),
                                  ),
                                  child: const Center(child: Icon(Icons.add_photo_alternate, color: Colors.white38, size: 28)),
                                ),
                        ),
                        const SizedBox(height: 8),
                        Text('Cover Photo', style: TextStyle(fontSize: 11, color: AppColors.textTertiary)),
                        Text('Tap to change', style: TextStyle(fontSize: 10, color: AppColors.primary)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Personal Info
              _SectionTitle('Personal Information'),
              const SizedBox(height: 12),
              _buildField('Bio', _bioCtrl, maxLines: 3),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(child: _buildNumberField('Age', _age, (v) => _age = int.tryParse(v) ?? _age)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildNumberField('Height (cm)', _height, (v) => _height = int.tryParse(v) ?? _height)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildNumberField('Weight (kg)', _weight, (v) => _weight = int.tryParse(v) ?? _weight)),
                ],
              ),

              const SizedBox(height: 28),

              // Football Info
              _SectionTitle('Football Career'),
              const SizedBox(height: 12),
              _buildDropdown('Position', _position, ['ST', 'LW', 'RW', 'CAM', 'CM', 'CDM', 'LB', 'RB', 'CB', 'GK'], (v) => setState(() => _position = v!)),
              const SizedBox(height: 14),
              _buildDropdown('Secondary', _secondaryPosition, ['None', 'ST', 'LW', 'RW', 'CAM', 'CM', 'CDM', 'LB', 'RB', 'CB', 'GK'], (v) => setState(() => _secondaryPosition = v!)),
              const SizedBox(height: 14),
              _buildDropdown('Preferred Foot', _preferredFoot, ['Right', 'Left', 'Both'], (v) => setState(() => _preferredFoot = v!)),
              const SizedBox(height: 14),
              _buildField('Current Club', TextEditingController(text: _currentClub), onChanged: (v) => _currentClub = v),
              const SizedBox(height: 14),
              _buildDropdown('Current Step', _currentStep, ['Step 1', 'Step 2', 'Step 3', 'Step 4', 'Step 5', 'Step 6', 'Step 7'], (v) => setState(() => _currentStep = v!)),
              const SizedBox(height: 14),
              _buildDropdown('Highest Step', _highestStep, ['Step 1', 'Step 2', 'Step 3', 'Step 4', 'Step 5', 'Step 6', 'Step 7'], (v) => setState(() => _highestStep = v!)),
              const SizedBox(height: 14),
              _buildDropdown('County', _county, ['Greater Manchester', 'Lancashire', 'Merseyside', 'West Yorkshire', 'South Yorkshire', 'West Midlands', 'Greater London', 'Cheshire'], (v) => setState(() => _county = v!)),
              const SizedBox(height: 14),
              _buildDropdown('Travel Distance', _travelDistance, ['10 miles', '20 miles', '30 miles', '50 miles', '75 miles', '100 miles', 'Anywhere'], (v) => setState(() => _travelDistance = v!)),
              const SizedBox(height: 14),
              _buildDropdown('Availability', _availability, ['Available Immediately', 'Available Next Season', 'Open to Offers', 'Not Available'], (v) => setState(() => _availability = v!)),

              const SizedBox(height: 28),

              // Contact
              _SectionTitle('Contact & Social'),
              const SizedBox(height: 12),
              _buildField('Email', _emailCtrl, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 14),
              _buildField('Phone', _phoneCtrl, keyboardType: TextInputType.phone),
              const SizedBox(height: 14),
              _buildField('Instagram', _instagramCtrl),
              const SizedBox(height: 14),
              _buildField('X (Twitter)', _twitterCtrl),
              const SizedBox(height: 14),
              _buildField('TikTok', _tiktokCtrl),

              const SizedBox(height: 28),

              // Languages
              _SectionTitle('Languages'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8, runSpacing: 8,
                children: _languages.map((lang) {
                  return Chip(
                    label: Text(lang),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () => setState(() => _languages.remove(lang)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => setState(() => _languages.add('English')),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Language'),
              ),

              const SizedBox(height: 28),

              // Achievements
              _SectionTitle('Achievements'),
              const SizedBox(height: 12),
              ..._achievements.map((a) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const Icon(Icons.emoji_events, color: AppColors.warning, size: 18),
                    const SizedBox(width: 10),
                    Expanded(child: Text(a, style: const TextStyle(fontSize: 14))),
                    IconButton(
                      icon: const Icon(Icons.close, size: 18, color: AppColors.textTertiary),
                      onPressed: () => setState(() => _achievements.remove(a)),
                    ),
                  ],
                ),
              )),
              OutlinedButton.icon(
                onPressed: () => setState(() => _achievements.add('New Achievement')),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Achievement'),
              ),

              const SizedBox(height: 40),
              PrimaryButton(label: 'Save Changes', onPressed: _handleSave),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: OutlinedButton(
                  onPressed: () => context.pop(),
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.textSecondary),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSave() async {
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!'), backgroundColor: AppColors.success),
      );
      context.pop();
    }
  }

  Widget _buildField(String label, TextEditingController controller, {int maxLines = 1, TextInputType keyboardType = TextInputType.text, void Function(String)? onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          onChanged: onChanged,
          decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12)),
        ),
      ],
    );
  }

  Widget _buildNumberField(String label, int value, void Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: value.toString(),
          keyboardType: TextInputType.number,
          onChanged: onChanged,
          decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12)),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, void Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: value,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14)))).toList(),
          onChanged: onChanged,
          decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12)),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary));
  }
}
