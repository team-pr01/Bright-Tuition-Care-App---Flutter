class LegalSection {

  final String title;
  final String content;

  const LegalSection({
    required this.title,
    required this.content,
  });

}

class LegalDocument {

  final String title;
  final List<LegalSection> sections;

  const LegalDocument({
    required this.title,
    required this.sections,
  });

}