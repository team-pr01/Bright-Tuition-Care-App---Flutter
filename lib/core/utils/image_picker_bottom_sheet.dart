import 'dart:io';

import 'package:btcclient/core/utils/file_picker_utils.dart';
import 'package:flutter/material.dart';

class ImagePickerBottomSheet {
  static Future<File?> show(BuildContext context) async {
    return showModalBottomSheet<File>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Change Profile Photo",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.photo_library_outlined),
                ),
                title: const Text("Choose from Gallery"),
                onTap: () async {
                  final image =
                      await FilePickerUtils.pickImageFromGallery();

                  if (context.mounted) {
                    Navigator.pop(context, image);
                  }
                },
              ),

              ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.camera_alt_outlined),
                ),
                title: const Text("Take Photo"),
                onTap: () async {
                  final image =
                      await FilePickerUtils.pickImageFromCamera();

                  if (context.mounted) {
                    Navigator.pop(context, image);
                  }
                },
              ),

              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}