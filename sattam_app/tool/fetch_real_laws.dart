import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final httpClient = HttpClient();
  
  // Download and parse external JSON
  Future<List<Map<String, dynamic>>> fetchLawData(String url) async {
    print('Downloading data from $url...');
    try {
      final request = await httpClient.getUrl(Uri.parse(url));
      final response = await request.close();
      final stringData = await response.transform(utf8.decoder).join();
      final List<dynamic> data = json.decode(stringData);
      
      // Map to our format
      return data.map((item) {
        // Some datasets use "Section" (capitalized), some use "section"
        final secNum = item['Section'] ?? item['section'] ?? '';
        final title = item['section_title'] ?? '';
        final desc = item['section_desc'] ?? '';
        
        return {
          "sectionNumber": "Section $secNum",
          "title": title.toString(),
          "description": desc.toString().split('\n').first, // First line as short desc
          "completeExplanation": desc.toString(),
        };
      }).toList();
    } catch (e) {
      print('Failed to download from $url: $e');
      return [];
    }
  }

  // Fetch real datasets
  final ipcSections = await fetchLawData('https://raw.githubusercontent.com/civictech-India/Indian-Law-Penal-Code-Json/main/ipc.json');
  final crpcSections = await fetchLawData('https://raw.githubusercontent.com/civictech-India/Indian-Law-Penal-Code-Json/main/crpc.json');
  final ieaSections = await fetchLawData('https://raw.githubusercontent.com/civictech-India/Indian-Law-Penal-Code-Json/main/iea.json');

  httpClient.close();

  // Now, update our local database
  final dbFile = File('assets/laws_database.json');
  final String jsonStr = dbFile.readAsStringSync();
  final List<dynamic> data = json.decode(jsonStr);

  final criminalLawCat = data.firstWhere((cat) => cat['name'] == 'Criminal Law', orElse: () => null);
  
  if (criminalLawCat != null) {
    final List<dynamic> acts = criminalLawCat['acts'];
    
    for (var act in acts) {
      if (act['title'] == 'Indian Penal Code (IPC)' && ipcSections.isNotEmpty) {
        act['sections'] = ipcSections;
        print('Updated IPC with ${ipcSections.length} real sections.');
      } else if (act['title'] == 'Code of Criminal Procedure (CrPC)' && crpcSections.isNotEmpty) {
        act['sections'] = crpcSections;
        print('Updated CrPC with ${crpcSections.length} real sections.');
      } else if (act['title'] == 'Indian Evidence Act (IEA)' && ieaSections.isNotEmpty) {
        act['sections'] = ieaSections;
        print('Updated IEA with ${ieaSections.length} real sections.');
      }
    }
  }

  dbFile.writeAsStringSync(json.encode(data));
  print('Successfully populated database with real law data!');
}
