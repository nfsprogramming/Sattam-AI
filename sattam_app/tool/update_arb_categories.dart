import 'dart:convert';
import 'dart:io';

void main() {
  final Map<String, String> enAdditions = {
    "catCriminalLaw": "Criminal Law",
    "catTrafficMotor": "Traffic & Motor",
    "catConsumerLaw": "Consumer Law",
    "catLabourLaw": "Labour Law",
    "catFamilyLaw": "Family Law",
    "catCyberLaw": "Cyber Law"
  };

  final Map<String, String> taAdditions = {
    "catCriminalLaw": "குற்றவியல் சட்டம்",
    "catTrafficMotor": "போக்குவரத்து & மோட்டார்",
    "catConsumerLaw": "நுகர்வோர் சட்டம்",
    "catLabourLaw": "தொழிலாளர் சட்டம்",
    "catFamilyLaw": "குடும்ப சட்டம்",
    "catCyberLaw": "சைபர் சட்டம்"
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
  print('ARB category files updated.');
}
