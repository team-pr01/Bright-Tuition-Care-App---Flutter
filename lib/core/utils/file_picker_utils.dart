import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class FilePickerUtils {
  static final ImagePicker _picker = ImagePicker();

  /// ================= PICK IMAGE FROM GALLERY =================
  static Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1500,
      );

      if (image == null) return null;

      return File(image.path);
    } catch (e) {
      print("IMAGE PICKER ERROR: $e");
      return null;
    }
  }

  /// ================= TAKE PHOTO =================
  static Future<File?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1500,
      );

      if (image == null) return null;

      return File(image.path);
    } catch (e) {
      print("CAMERA ERROR: $e");
      return null;
    }
  }

  /// ================= PICK SINGLE FILE =================
  static Future<File?> pickSingleFile({
    List<String>? allowedExtensions,
  }) async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: allowedExtensions != null ? FileType.custom : FileType.any,
        allowedExtensions: allowedExtensions,
      );

      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }

      return null;
    } catch (e) {
      print("FILE PICKER ERROR: $e");
      return null;
    }
  }

  /// ================= PICK MULTIPLE FILES =================
  static Future<List<File>> pickMultipleFiles({
    List<String>? allowedExtensions,
  }) async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        allowMultiple: true,
        type: allowedExtensions != null ? FileType.custom : FileType.any,
        allowedExtensions: allowedExtensions,
      );

      if (result != null) {
        return result.paths
            .whereType<String>()
            .map((e) => File(e))
            .toList();
      }

      return [];
    } catch (e) {
      print("MULTIPLE FILE PICKER ERROR: $e");
      return [];
    }
  }
}