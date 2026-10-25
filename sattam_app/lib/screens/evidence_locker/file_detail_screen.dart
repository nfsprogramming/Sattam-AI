import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sattam_app/theme/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/evidence_service.dart';

class FileDetailScreen extends StatelessWidget {
  final EvidenceFile evidenceFile;

  const FileDetailScreen({super.key, required this.evidenceFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.bgBase,
      appBar: AppBar(
        backgroundColor: context.colors.bgBase,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'File Details',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
            onPressed: () => _confirmDelete(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFilePreview(context),
              _buildMetadataSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilePreview(BuildContext context) {
    final isImage = evidenceFile.fileType == 'image';
    
    return Container(
      width: double.infinity,
      height: 300,
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: context.colors.borderSubtle),
      ),
      clipBehavior: Clip.antiAlias,
      child: isImage
          ? Image.network(
              evidenceFile.fileUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _buildPlaceholderIcon(context),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
            )
          : _buildPlaceholderIcon(context),
    );
  }

  Widget _buildPlaceholderIcon(BuildContext context) {
    IconData icon;
    Color color;

    switch (evidenceFile.fileType.toLowerCase()) {
      case 'image':
        icon = Icons.image_rounded;
        color = Colors.blue;
        break;
      case 'video':
        icon = Icons.videocam_rounded;
        color = Colors.purple;
        break;
      case 'audio':
        icon = Icons.audiotrack_rounded;
        color = Colors.orange;
        break;
      case 'document':
      case 'pdf':
        icon = Icons.picture_as_pdf_rounded;
        color = Colors.red;
        break;
      default:
        icon = Icons.insert_drive_file_rounded;
        color = context.colors.primary;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 64, color: color),
        ),
        const SizedBox(height: 16),
        Text(
          'Preview not available',
          style: GoogleFonts.plusJakartaSans(
            color: context.colors.textMuted,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildMetadataSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            evidenceFile.fileName,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Information',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.colors.borderSubtle),
            ),
            child: Column(
              children: [
                _buildMetadataRow(context, 'Type', evidenceFile.fileType.toUpperCase(), Icons.category_rounded),
                const Divider(height: 24, color: Colors.white10),
                _buildMetadataRow(context, 'Size', '${(evidenceFile.size / (1024 * 1024)).toStringAsFixed(2)} MB', Icons.data_usage_rounded),
                const Divider(height: 24, color: Colors.white10),
                _buildMetadataRow(context, 'Uploaded', DateFormat('MMMM d, yyyy • h:mm a').format(evidenceFile.createdAt), Icons.calendar_today_rounded),
                const Divider(height: 24, color: Colors.white10),
                _buildMetadataRow(context, 'Category', evidenceFile.category, Icons.folder_special_rounded),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      final url = Uri.parse(evidenceFile.fileUrl);
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Could not open file.')),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.open_in_new_rounded),
                  label: Text(
                    'Open File',
                    style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      final url = Uri.parse(evidenceFile.fileUrl);
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Could not download file.')),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.download_rounded),
                  label: Text(
                    'Download',
                    style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.surfaceContainerHigh,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataRow(BuildContext context, String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: context.colors.textMuted),
        const SizedBox(width: 12),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            color: context.colors.textMuted,
            fontSize: 14,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.colors.surface,
        title: Text('Delete File?', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text(
          'Are you sure you want to delete "${evidenceFile.fileName}"? This cannot be undone.',
          style: GoogleFonts.plusJakartaSans(color: context.colors.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.plusJakartaSans(color: context.colors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              
              // Show loading
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Deleting file...')),
              );

              final success = await EvidenceService.deleteFile(evidenceFile);
              
              if (context.mounted) {
                if (success) {
                  Navigator.pop(context, true); // Pop details screen and return true to refresh
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('File deleted'), backgroundColor: Colors.green),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to delete file'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: Text('Delete', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
