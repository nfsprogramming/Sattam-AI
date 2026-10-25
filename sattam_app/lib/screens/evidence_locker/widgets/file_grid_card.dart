import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sattam_app/theme/app_theme.dart';

class FileGridCard extends StatefulWidget {
  final String fileName;
  final String fileType;
  final String date;
  final String size;
  final bool isPinned;
  final VoidCallback onTap;

  const FileGridCard({
    super.key,
    required this.fileName,
    required this.fileType,
    required this.date,
    required this.size,
    this.isPinned = false,
    required this.onTap,
  });

  @override
  State<FileGridCard> createState() => _FileGridCardState();
}

class _FileGridCardState extends State<FileGridCard> {
  bool _isHovered = false;

  IconData _getFileIcon() {
    switch (widget.fileType.toLowerCase()) {
      case 'image': return Icons.image_rounded;
      case 'video': return Icons.videocam_rounded;
      case 'audio': return Icons.audiotrack_rounded;
      case 'pdf': return Icons.picture_as_pdf_rounded;
      default: return Icons.insert_drive_file_rounded;
    }
  }

  Color _getFileColor(BuildContext context) {
    switch (widget.fileType.toLowerCase()) {
      case 'image': return Colors.blue;
      case 'video': return Colors.purple;
      case 'audio': return Colors.orange;
      case 'pdf': return Colors.red;
      default: return context.colors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final fileColor = _getFileColor(context);
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.translationValues(0, _isHovered ? -4 : 0, 0),
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _isHovered ? context.colors.primary.withValues(alpha: 0.5) : context.colors.borderSubtle,
            ),
            boxShadow: _isHovered ? [
              BoxShadow(
                color: context.colors.primary.withValues(alpha: 0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              )
            ] : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail area
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: fileColor.withValues(alpha: 0.1),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Icon(
                          _getFileIcon(),
                          size: 40,
                          color: fileColor.withValues(alpha: 0.8),
                        ),
                      ),
                      if (widget.isPinned)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Icon(Icons.push_pin_rounded, size: 16, color: context.colors.primary),
                        ),
                    ],
                  ),
                ),
              ),
              // Details area
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.fileName,
                            style: GoogleFonts.plusJakartaSans(
                              color: context.colors.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(Icons.more_vert_rounded, size: 16, color: context.colors.textMuted),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.date} • ${widget.size}',
                      style: GoogleFonts.plusJakartaSans(
                        color: context.colors.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
