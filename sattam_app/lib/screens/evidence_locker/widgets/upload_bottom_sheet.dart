import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sattam_app/theme/app_theme.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../../../services/evidence_service.dart';

class UploadBottomSheet extends StatelessWidget {
  const UploadBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.bgBase,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: context.colors.borderSubtle,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Upload Evidence',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildOptionRow(
              context,
              [
                _UploadOption(Icons.camera_alt_rounded, 'Take Photo', Colors.blue, () => _pickImage(context, ImageSource.camera)),
                _UploadOption(Icons.videocam_rounded, 'Record Video', Colors.purple, () => _pickVideo(context)),
              ],
            ),
            const SizedBox(height: 16),
            _buildOptionRow(
              context,
              [
                _UploadOption(Icons.photo_library_rounded, 'Gallery', Colors.teal, () => _pickImage(context, ImageSource.gallery)),
                _UploadOption(Icons.folder_rounded, 'Choose Files', context.colors.primary, () => _pickFiles(context)),
                _UploadOption(Icons.document_scanner_rounded, 'Scan Doc', Colors.red, () => _showNotImplemented(context, 'Document Scanning')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showNotImplemented(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature coming soon!'), behavior: SnackBarBehavior.floating),
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final messenger = ScaffoldMessenger.of(context);
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      await _uploadSelectedFile(messenger, File(image.path), image.name, 'image');
    }
  }

  Future<void> _pickVideo(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final ImagePicker picker = ImagePicker();
    final XFile? video = await picker.pickVideo(source: ImageSource.camera);
    if (video != null) {
      await _uploadSelectedFile(messenger, File(video.path), video.name, 'video');
    }
  }

  Future<void> _pickFiles(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      for (var platformFile in result.files) {
        if (platformFile.path != null) {
          await _uploadSelectedFile(messenger, File(platformFile.path!), platformFile.name, 'document');
        }
      }
    }
  }

  Future<void> _uploadSelectedFile(ScaffoldMessengerState messenger, File file, String fileName, String type) async {
    messenger.showSnackBar(
      SnackBar(content: Text('Uploading $fileName...'), behavior: SnackBarBehavior.floating),
    );

    try {
      final result = await EvidenceService.uploadFile(
        file: file,
        fileName: fileName,
        fileType: type,
      );

      if (result != null) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Uploaded successfully!'), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating),
        );
      }
    } catch (e) {
      String errorMsg = e.toString();
      if (errorMsg.contains('Bucket not found') || errorMsg.contains('relation "public.evidence" does not exist')) {
        errorMsg = "Database/Storage not configured! Please run the SQL script in your Supabase Dashboard.";
      }
      messenger.showSnackBar(
        SnackBar(
          content: Text('Failed: $errorMsg', maxLines: 3), 
          backgroundColor: Colors.red, 
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  Widget _buildOptionRow(BuildContext context, List<_UploadOption> options) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: options.map((option) {
        return Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
              option.onTap();
            },
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: option.color.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: option.color.withValues(alpha: 0.3)),
                  ),
                  child: Icon(option.icon, color: option.color, size: 28),
                ),
                const SizedBox(height: 8),
                Text(
                  option.label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    color: context.colors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _UploadOption {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  _UploadOption(this.icon, this.label, this.color, this.onTap);
}
