import 'dart:convert';
import 'dart:io';

void main() {
  final data = json.decode(File('assets/laws_database.json').readAsStringSync()) as List;
  for (var cat in data) {
    print('Category: ${cat['name']}');
    for (var act in cat['acts']) {
      print('  - ${act['title']} (${act['sections'].length} sections)');
    }
  }
}
