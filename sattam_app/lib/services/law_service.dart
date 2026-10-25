import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/law_models.dart';

class LawService {
  static List<LawCategory>? _cachedCategories;

  static Future<List<LawCategory>> getLawCategories() async {
    if (_cachedCategories != null) {
      return _cachedCategories!;
    }

    try {
      final String response = await rootBundle.loadString('assets/laws_database.json');
      final data = await json.decode(response) as List<dynamic>;
      
      _cachedCategories = data.map((e) => LawCategory.fromJson(e)).toList();
      return _cachedCategories!;
    } catch (e) {

      return [];
    }
  }
  static Future<List<LawSearchResult>> searchLaws(String query) async {
    final categories = await getLawCategories();
    if (query.trim().isEmpty) return [];

    final q = query.toLowerCase().trim();
    final results = <LawSearchResult>[];

    for (var category in categories) {
      for (var act in category.acts) {
        for (var section in act.sections) {
          if (section.title.toLowerCase().contains(q) ||
              section.sectionNumber.toLowerCase().contains(q) ||
              section.description.toLowerCase().contains(q) ||
              section.completeExplanation.toLowerCase().contains(q)) {
            results.add(
              LawSearchResult(
                category: category,
                act: act,
                section: section,
              ),
            );
          }
        }
      }
    }
    return results;
  }
}
