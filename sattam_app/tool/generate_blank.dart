import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  // Create a 256x256 image with a transparent background
  final image = img.Image(width: 256, height: 256, numChannels: 4);
  
  // Save as PNG
  final pngBytes = img.encodePng(image);
  File('assets/images/transparent_256.png')
    ..createSync(recursive: true)
    ..writeAsBytesSync(pngBytes);
    
  print('Created transparent_256.png successfully.');
}
