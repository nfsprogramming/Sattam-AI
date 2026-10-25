import 'dart:convert';
import 'dart:io';

void main() {
  final file = File('assets/laws_database.json');
  final String jsonStr = file.readAsStringSync();
  final List<dynamic> data = json.decode(jsonStr);

  // Helper to generate mock sections
  List<Map<String, dynamic>> generateMockSections(String actPrefix, int count) {
    return List.generate(count, (index) {
      final sectionNum = index + 1;
      return {
        "sectionNumber": "Section $sectionNum",
        "title": "$actPrefix Category $sectionNum",
        "description": "Details regarding provision $sectionNum under $actPrefix.",
        "completeExplanation": "This is the complete legal text and explanation for Section $sectionNum of the $actPrefix. It outlines the specific elements, exceptions, and interpretations relevant to this provision."
      };
    });
  }

  // Find Criminal Law category
  final criminalLawCat = data.firstWhere((cat) => cat['name'] == 'Criminal Law', orElse: () => null);
  
  if (criminalLawCat != null) {
    final List<dynamic> acts = criminalLawCat['acts'];
    
    // Add BSA
    acts.add({
      "title": "Bharatiya Sakshya Adhiniyam (BSA)",
      "shortDescription": "The new evidence code of India replacing the IEA.",
      "year": "2023",
      "sections": generateMockSections("BSA", 100)
    });

    // Add IPC
    acts.add({
      "title": "Indian Penal Code (IPC)",
      "shortDescription": "The historical criminal code of India (legacy).",
      "year": "1860",
      "sections": generateMockSections("IPC", 511)
    });

    // Add CrPC
    acts.add({
      "title": "Code of Criminal Procedure (CrPC)",
      "shortDescription": "The historical procedural law for criminal cases in India (legacy).",
      "year": "1973",
      "sections": generateMockSections("CrPC", 484)
    });

    // Add IEA
    acts.add({
      "title": "Indian Evidence Act (IEA)",
      "shortDescription": "The historical evidence code of India (legacy).",
      "year": "1872",
      "sections": generateMockSections("IEA", 167)
    });
  }

  file.writeAsStringSync(json.encode(data));
  print('Successfully added BSA, IPC, CrPC, and IEA to the database.');
}
