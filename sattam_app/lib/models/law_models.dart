class LawSection {
  final String sectionNumber;
  final String title;
  final String description;
  final String completeExplanation;

  const LawSection({
    required this.sectionNumber,
    required this.title,
    required this.description,
    required this.completeExplanation,
  });

  factory LawSection.fromJson(Map<String, dynamic> json) {
    return LawSection(
      sectionNumber: json['sectionNumber'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      completeExplanation: json['completeExplanation'] ?? '',
    );
  }
}

class LawAct {
  final String title;
  final String shortDescription;
  final String year;
  final List<LawSection> sections;

  const LawAct({
    required this.title,
    required this.shortDescription,
    required this.year,
    required this.sections,
  });

  factory LawAct.fromJson(Map<String, dynamic> json) {
    return LawAct(
      title: json['title'] ?? '',
      shortDescription: json['shortDescription'] ?? '',
      year: json['year'] ?? '',
      sections: (json['sections'] as List?)
              ?.map((e) => LawSection.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class LawCategory {
  final String name;
  final List<LawAct> acts;

  const LawCategory({
    required this.name,
    required this.acts,
  });

  factory LawCategory.fromJson(Map<String, dynamic> json) {
    return LawCategory(
      name: json['name'] ?? '',
      acts: (json['acts'] as List?)
              ?.map((e) => LawAct.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class LawSearchResult {
  final LawCategory category;
  final LawAct act;
  final LawSection section;

  const LawSearchResult({
    required this.category,
    required this.act,
    required this.section,
  });
}
