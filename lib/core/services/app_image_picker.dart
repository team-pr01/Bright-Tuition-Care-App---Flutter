import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../config/theme.dart';

class AppImagePicker extends StatelessWidget {
  final File? image;
  final String? imageUrl;
  final String title;
  final String subtitle;
  final double size;
  final bool circular;
  final VoidCallback onTap;
  final VoidCallback? onRemove;

  const AppImagePicker({
    super.key,
    this.image,
    this.imageUrl,
    required this.onTap,
    this.onRemove,
    this.title = "Upload Image",
    this.subtitle = "Tap to choose image",
    this.size = 120,
    this.circular = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (image != null) {
      child = Image.file(
        image!,
        fit: BoxFit.cover,
      );
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      child = Image.network(
        imageUrl!,
        fit: BoxFit.cover,
      );
    } else {
      child = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_a_photo_outlined,
            size: 34,
            color: AppColors.primary01,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.neutrals03,
                ),
          ),
        ],
      );
    }

    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: size,
            width: size,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: AppColors.neutrals01,
              shape: circular ? BoxShape.circle : BoxShape.rectangle,
              borderRadius:
                  circular ? null : BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primary01.withOpacity(.20),
              ),
            ),
            child: child,
          ),
        ),
        if ((image != null || (imageUrl?.isNotEmpty ?? false)) &&
            onRemove != null)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextButton.icon(
              onPressed: onRemove,
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.red,
              ),
              label: const Text(
                "Remove",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ),
      ],
    );
  }

  static Future<XFile?> showPicker(BuildContext context) async {
    final picker = ImagePicker();

    return await showModalBottomSheet<XFile>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(18),
        ),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 5,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 24),
                ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.photo_camera),
                  ),
                  title: const Text("Camera"),
                  onTap: () async {
                    final file = await picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 85,
                    );

                    if (context.mounted) {
                      Navigator.pop(context, file);
                    }
                  },
                ),
                ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.photo_library),
                  ),
                  title: const Text("Gallery"),
                  onTap: () async {
                    final file = await picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 85,
                    );

                    if (context.mounted) {
                      Navigator.pop(context, file);
                    }
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}