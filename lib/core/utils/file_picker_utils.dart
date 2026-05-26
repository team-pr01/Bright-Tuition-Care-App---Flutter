import 'dart:io';

import 'package:file_picker/file_picker.dart';

class FilePickerUtils {
  /// ================= PICK SINGLE FILE =================
  static Future<File?> pickSingleFile({List<String>? allowedExtensions}) async {
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
            .map((path) => File(path))
            .toList();
      }

      return [];
    } catch (e) {
      print("MULTIPLE FILE PICKER ERROR: $e");

      return [];
    }
  }
}
