class ImportantGuidelinesData {
  final String title;
  final List<ImportantGuidelineSection> sections;

  const ImportantGuidelinesData({
    required this.title,
    required this.sections,
  });
}

class ImportantGuidelineSection {
  final String title;
  final List<String>? content;
  final String? description;

  /// Bullet points
  final List<String>? points;

  /// Nested subsections
  final List<ImportantGuidelineSubsection>? subsections;

  /// Highlighted note
  final String? note;

  const ImportantGuidelineSection({
    required this.title,
    this.content,
    this.description,
    this.points,
    this.subsections,
    this.note,
  });
}

class ImportantGuidelineSubsection {
  final String title;
  final List<String>? content;
  final String? note;

  const ImportantGuidelineSubsection({
    required this.title,
    this.content,
    this.note,
  });
}