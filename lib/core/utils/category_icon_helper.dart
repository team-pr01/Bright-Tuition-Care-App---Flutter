

import 'package:btcclient/core/data/constants/app_icons.dart';

String getCategoryIcon({
  required String category,
  dynamic className, // can be String or List
  String? gender,
}) {
  final normalizedClassName = className is List
      ? className.join(" ").toLowerCase()
      : className?.toLowerCase();

  // 1. Medium
  if (category == "Bangla Medium" ||
      category == "English Medium" ||
      category == "English Version") {
    if (gender == "male") return AppIcons.maleTutor;
    if (gender == "female") return AppIcons.female;
    return AppIcons.maleFemale;
  }

  if (category == "Madrasa Medium") return AppIcons.quran;

  // 2. Religious
  if (category == "Religious Studies") {
    if (normalizedClassName?.contains("islam") ?? false) return AppIcons.quran;
    if (normalizedClassName?.contains("hindu") ?? false) return AppIcons.hinduSymbol;
    if (normalizedClassName?.contains("buddh") ?? false) return AppIcons.buddhism;
    if (normalizedClassName?.contains("christ") ?? false) return AppIcons.bible;
    return AppIcons.quran;
  }

  // 3. Admission
  if (category == "Admission Test") {
    if (normalizedClassName?.contains("medical") ?? false) {
      return AppIcons.stethoscope;
    }
    return AppIcons.admissionTestIcon;
  }

  // 4. Arts
  if (category == "Arts") {
    if (normalizedClassName?.contains("drawing") ?? false) {
      return AppIcons.drawingIcon;
    }
    if (normalizedClassName?.contains("handwriting") ?? false) {
      return AppIcons.handwriting;
    }
    if (normalizedClassName?.contains("instrumental music") ?? false) {
      return AppIcons.guitar;
    }
    if (normalizedClassName?.contains("music") ?? false) {
      return AppIcons.music;
    }
    if (normalizedClassName?.contains("dance") ?? false) {
      return AppIcons.dance;
    }
    if (normalizedClassName?.contains("craft") ?? false) {
      return AppIcons.crafting;
    }
    return AppIcons.music;
  }

  // 5. Language
  if (category == "Language Learning") {
    return AppIcons.languageLearningIcon;
  }

  // 6. Test Prep
  if (category == "Test Preparation") {
    return AppIcons.testPreparationIcon;
  }

  // 7. Professional
  if (category == "Professional Skill Development") {
    return AppIcons.skillDevelopment;
  }

  // 8. Special Skills
  if (category == "Special Skill Development") {
    if (normalizedClassName?.contains("photography") ?? false) {
      return AppIcons.photography;
    }
    if (normalizedClassName?.contains("cooking") ?? false) {
      return AppIcons.cooking;
    }
    if (normalizedClassName?.contains("yoga") ?? false) {
      return AppIcons.yoga;
    }
    if (normalizedClassName?.contains("gym") ?? false) {
      return AppIcons.gym;
    }
    if ((normalizedClassName?.contains("driving") ?? false) ||
        (normalizedClassName?.contains("riding") ?? false)) {
      return AppIcons.driving;
    }
    if (normalizedClassName?.contains("karate") ?? false) {
      return AppIcons.karate;
    }
    return AppIcons.skillDevelopment;
  }

  // Default
  return AppIcons.skillDevelopment;
}