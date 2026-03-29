class JobIconHelper {

  static String getCategoryIcon({
    required String category,
    List<String>? className,
    String? gender,
  }) {
    final normalizedClassName =
        (className ?? []).join(" ").toLowerCase();

    final cat = category.toLowerCase();
    final gen = gender?.toLowerCase();

    /// ---------- 1. Medium ----------
    if (cat == "bangla medium" ||
        cat == "english medium" ||
        cat == "english version") {
      if (gen == "male") return "assets/icons/job_card_icons/male_tutor.svg";
      if (gen == "female") return "assets/icons/job_card_icons/female.svg";
      return "assets/icons/job_card_icons/male_female.svg";
    }

    if (cat == "madrasa medium") {
      return "assets/icons/job_card_icons/quran.svg";
    }

    /// ---------- 2. Religious ----------
    if (cat == "religious studies") {
      if (normalizedClassName.contains("islam")) {
        return "assets/icons/job_card_icons/quran.svg";
      }
      if (normalizedClassName.contains("hindu")) {
        return "assets/icons/job_card_icons/hindu_symbol.svg";
      }
      if (normalizedClassName.contains("buddh")) {
        return "assets/icons/job_card_icons/buddhism.svg";
      }
      if (normalizedClassName.contains("christ")) {
        return "assets/icons/job_card_icons/bible.svg";
      }
      return "assets/icons/job_card_icons/quran.svg";
    }

    /// ---------- 3. Admission ----------
    if (cat == "admission test") {
      if (normalizedClassName.contains("medical")) {
        return "assets/icons/job_card_icons/stethoscope.svg";
      }
      return "assets/icons/job_card_icons/admission_test.svg";
    }

    /// ---------- 4. Arts ----------
    if (cat == "arts") {
      if (normalizedClassName.contains("drawing")) {
        return "assets/icons/job_card_icons/drawing.svg";
      }
      if (normalizedClassName.contains("handwriting")) {
        return "assets/icons/job_card_icons/handwriting.svg";
      }
      if (normalizedClassName.contains("instrumental music")) {
        return "assets/icons/job_card_icons/guitar.svg";
      }
      if (normalizedClassName.contains("music")) {
        return "assets/icons/job_card_icons/music.svg";
      }
      if (normalizedClassName.contains("dance")) {
        return "assets/icons/job_card_icons/dance.svg";
      }
      if (normalizedClassName.contains("craft")) {
        return "assets/icons/job_card_icons/crafting.svg";
      }
      return "assets/icons/job_card_icons/music.svg";
    }

    /// ---------- 5. Language ----------
    if (cat == "language learning") {
      return "assets/icons/job_card_icons/language_learning.svg";
    }

    /// ---------- 6. Test Prep ----------
    if (cat == "test preparation") {
      return "assets/icons/job_card_icons/test-preparation.svg"; // 🔴 check this filename carefully
    }

    /// ---------- 7. Professional ----------
    if (cat == "professional skill development") {
      return "assets/icons/job_card_icons/skill_development.svg";
    }

    /// ---------- 8. Special Skill ----------
    if (cat == "special skill development") {
      if (normalizedClassName.contains("photography")) {
        return "assets/icons/job_card_icons/photography.svg";
      }
      if (normalizedClassName.contains("cooking")) {
        return "assets/icons/job_card_icons/cooking.svg";
      }
      if (normalizedClassName.contains("yoga")) {
        return "assets/icons/job_card_icons/yoga.svg";
      }
      if (normalizedClassName.contains("gym")) {
        return "assets/icons/job_card_icons/gym.svg";
      }
      if (normalizedClassName.contains("driving") ||
          normalizedClassName.contains("riding")) {
        return "assets/icons/job_card_icons/driving.svg";
      }
      if (normalizedClassName.contains("karate")) {
        return "assets/icons/job_card_icons/karate.svg";
      }

      return "assets/icons/job_card_icons/skill_development.svg"; // fallback FIXED
    }

    /// ---------- DEFAULT ----------
    return "assets/icons/job_card_icons/skill_development.svg"; // fallback FIXED
  }
}