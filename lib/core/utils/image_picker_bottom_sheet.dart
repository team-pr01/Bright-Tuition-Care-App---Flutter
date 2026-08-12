import 'dart:io';

import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/utils/file_picker_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ImagePickerBottomSheet {
  static Future<File?> show(BuildContext context) async {
    return showModalBottomSheet<File?>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
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

                const SizedBox(height: 20),

                // --------------------------------------------------
                // GALLERY
                // --------------------------------------------------
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xffEDF4FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.photo_library_outlined,
                      color: AppColors.primary01,
                    ),
                  ),
                  title: const Text(
                    "Choose from Gallery",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: const Text(
                    "Select an image from your device",
                  ),
                  onTap: () async {
                    try {
                      final image =
                          await FilePickerUtils.pickImageFromGallery();

                      if (!sheetContext.mounted) return;

                      Navigator.pop(sheetContext, image);
                    } catch (e, stackTrace) {
                      debugPrint(
                        "❌ Gallery picker error: $e",
                      );
                      debugPrintStack(
                        stackTrace: stackTrace,
                      );

                      if (!sheetContext.mounted) return;

                      Navigator.pop(sheetContext);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Unable to select image: $e",
                          ),
                        ),
                      );
                    }
                  },
                ),

                const SizedBox(height: 4),

                // --------------------------------------------------
                // CAMERA
                // --------------------------------------------------
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xffEDF4FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      color: AppColors.primary01,
                    ),
                  ),
                  title: const Text(
                    "Take Photo",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    kIsWeb
                        ? "Camera is not available here"
                        : "Take a new profile photo",
                  ),
                  onTap: () async {
                    // Windows/Web cannot be assumed to support
                    // the same mobile camera implementation.
                    if (kIsWeb || !Platform.isAndroid && !Platform.isIOS) {
                      Navigator.pop(sheetContext);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Camera is available on Android/iOS. "
                            "Please choose an image from Gallery on this device.",
                          ),
                        ),
                      );

                      return;
                    }

                    try {
                      final image =
                          await FilePickerUtils.pickImageFromCamera();

                      if (!sheetContext.mounted) return;

                      Navigator.pop(sheetContext, image);
                    } catch (e, stackTrace) {
                      debugPrint(
                        "❌ Camera picker error: $e",
                      );
                      debugPrintStack(
                        stackTrace: stackTrace,
                      );

                      if (!sheetContext.mounted) return;

                      Navigator.pop(sheetContext);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Unable to open camera: $e",
                          ),
                        ),
                      );
                    }
                  },
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}