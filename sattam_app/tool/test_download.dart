import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final httpClient = HttpClient();
  
  Future<void> downloadAndPrint(String name, String url) async {
    print('Downloading $name...');
    try {
      final request = await httpClient.getUrl(Uri.parse(url));
      final response = await request.close();
      final stringData = await response.transform(utf8.decoder).join();
      final data = json.decode(stringData);
      print('$name Structure: ${data.runtimeType}');
      if (data is List && data.isNotEmpty) {
        print('First item: ${data[0]}');
      } else if (data is Map) {
        print('Keys: ${data.keys.toList()}');
        print('First key value: ${data[data.keys.first]}');
      }
    } catch (e) {
      print('Failed to download $name: $e');
    }
  }

  await downloadAndPrint('IPC', 'https://raw.githubusercontent.com/civictech-India/Indian-Law-Penal-Code-Json/main/ipc.json');
  await downloadAndPrint('CrPC', 'https://raw.githubusercontent.com/civictech-India/Indian-Law-Penal-Code-Json/main/crpc.json');
  await downloadAndPrint('IEA', 'https://raw.githubusercontent.com/civictech-India/Indian-Law-Penal-Code-Json/main/iea.json');

  httpClient.close();
}
