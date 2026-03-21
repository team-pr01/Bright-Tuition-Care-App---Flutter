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
  final String? description;
  final List<String>? points;
  final String? note;

  const ImportantGuidelineSection({
    required this.title,
    this.description,
    this.points,
    this.note,
  });
}