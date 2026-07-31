import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageService {
  static final ImagePicker _picker = ImagePicker();

  /// Pick image from gallery
  static Future<XFile?> pickFromGallery() async {
    try {
      return await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );
    } catch (e) {
      return null;
    }
  }

  /// Take photo with camera
  static Future<XFile?> takePhoto() async {
    try {
      return await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
        preferredCameraDevice: CameraDevice.front,
      );
    } catch (e) {
      return null;
    }
  }

  /// Read file as bytes (for web compatibility)
  static Future<Uint8List?> readAsBytes(XFile file) async {
    try {
      return await file.readAsBytes();
    } catch (e) {
      return null;
    }
  }

  /// Show image source picker bottom sheet
  static Future<XFile?> showImagePicker(BuildContext context, {String title = 'Profile Photo'}) async {
    return showModalBottomSheet<XFile>(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 36, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 20),
              Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _PickerOption(
                    icon: Icons.camera_alt,
                    label: 'Camera',
                    color: const Color(0xFFF97316),
                    onTap: () async {
                      final file = await takePhoto();
                      if (ctx.mounted) Navigator.pop(ctx, file);
                    },
                  ),
                  _PickerOption(
                    icon: Icons.photo_library,
                    label: 'Gallery',
                    color: const Color(0xFF3B82F6),
                    onTap: () async {
                      final file = await pickFromGallery();
                      if (ctx.mounted) Navigator.pop(ctx, file);
                    },
                  ),
                  _PickerOption(
                    icon: Icons.delete_outline,
                    label: 'Remove',
                    color: const Color(0xFFDC2626),
                    onTap: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _PickerOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _PickerOption({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF6B7280))),
        ],
      ),
    );
  }
}
