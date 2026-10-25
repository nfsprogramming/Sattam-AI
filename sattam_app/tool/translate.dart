import 'dart:io';

void main() {
  final file = File('assets/laws_database.json');
  var str = file.readAsStringSync();
  
  final translations = {
    '"Criminal Law"': '"குற்றவியல் சட்டம்"',
    '"Traffic & Motor"': '"போக்குவரத்து & மோட்டார்"',
    '"Consumer Law"': '"நுகர்வோர் சட்டம்"',
    '"Labour Law"': '"தொழிலாளர் சட்டம்"',
    '"Family Law"': '"குடும்ப சட்டம்"',
    '"Cyber Law"': '"சைபர் சட்டம்"'
  };
  
  translations.forEach((en, ta) {
    str = str.replaceAll(en, ta);
  });
  
  file.writeAsStringSync(str);
  print('Translated categories in JSON!');
}
