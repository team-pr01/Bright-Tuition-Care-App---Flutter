class LegalDocument {
  final String title;
  final List<LegalSection> sections;

  const LegalDocument({
    required this.title,
    required this.sections,
  });
}

class LegalSection {
  final String title;
  final String? description;      // Optional intro text
  final List<String>? content;     // Optional paragraph lines
  final List<String>? points;      // Optional bullet points
  final List<LegalSubsection>? subsections; // Optional nested blocks
  final String? note;              // Optional highlighted note

  const LegalSection({
    required this.title,
    this.description,
    this.content,
    this.points,
    this.subsections,
    this.note,
  });
}

class LegalSubsection {
  final String title;
  final String? description;
  final List<String>? content;
  final List<String>? points;
  final String? note;

  const LegalSubsection({
    required this.title,
    this.description,
    this.content,
    this.points,
    this.note,
  });
}