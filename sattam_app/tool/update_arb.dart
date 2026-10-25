import 'dart:convert';
import 'dart:io';

void main() {
  final Map<String, String> enAdditions = {
    "searchLegalTopics": "Search legal topics, acts, cases...",
    "quickActions": "Quick Actions",
    "askAiSubtitle": "Get instant legal answers",
    "generateDocumentSubtitle": "Create legal docs easily",
    "generateLegalDocuments": "Generate Legal Documents",
    "generateLegalDocumentsSubtitle": "Auto-generate RTIs & Legal Notices",
    "seeMore": "See more",
    "lawyersNearYou": "Lawyers Near You",
    "searchLawyers": "Search by name, practice area...",
    "allFilters": "All"
  };

  final Map<String, String> taAdditions = {
    "searchLegalTopics": "சட்ட தலைப்புகள், சட்டங்கள், வழக்குகளை தேடுக...",
    "quickActions": "விரைவு செயல்பாடுகள்",
    "askAiSubtitle": "உடனடி சட்ட பதில்கள்",
    "generateDocumentSubtitle": "எளிதாக ஆவணங்களை உருவாக்குங்கள்",
    "generateLegalDocuments": "சட்ட ஆவணங்களை உருவாக்குங்கள்",
    "generateLegalDocumentsSubtitle": "RTI மற்றும் சட்ட அறிவிப்புகளை தானாக உருவாக்குங்கள்",
    "seeMore": "மேலும் காண்க",
    "lawyersNearYou": "அருகிலுள்ள வழக்கறிஞர்கள்",
    "searchLawyers": "பெயர், பயிற்சி துறை மூலம் தேடுக...",
    "allFilters": "அனைத்தும்"
  };

  void updateArb(String path, Map<String, String> additions) {
    final file = File(path);
    final str = file.readAsStringSync();
    final Map<String, dynamic> data = json.decode(str);
    
    for (final entry in additions.entries) {
      data[entry.key] = entry.value;
    }
    
    file.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(data));
  }

  updateArb('lib/l10n/app_en.arb', enAdditions);
  updateArb('lib/l10n/app_ta.arb', taAdditions);
  print('ARB files updated.');
}
