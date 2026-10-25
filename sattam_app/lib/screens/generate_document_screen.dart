import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'dart:convert';
import 'dart:io';
import '../theme/app_theme.dart';
import 'package:sattam_app/l10n/app_localizations.dart';

class GenerateDocumentScreen extends StatefulWidget {
  const GenerateDocumentScreen({super.key});

  @override
  State<GenerateDocumentScreen> createState() => _GenerateDocumentScreenState();
}

class _GenerateDocumentScreenState extends State<GenerateDocumentScreen> {
  int _selectedType = 0;
  bool _isGenerating = false;

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _addressCtrl = TextEditingController();
  final TextEditingController _againstCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    final List<Map<String, dynamic>> docTypes = [
      {'title': l10n.docComplaintLetter, 'icon': Icons.description_outlined, 'color': const Color(0xFF64D2FF)},
      {'title': l10n.docLegalNotice, 'icon': Icons.gavel_rounded, 'color': const Color(0xFFBF5AF2)},
      {'title': l10n.docRtiApplication, 'icon': Icons.assignment_outlined, 'color': const Color(0xFFFF453A)},
      {'title': l10n.docRepresentationLetter, 'icon': Icons.article_outlined, 'color': const Color(0xFF32D74B)},
      {'title': l10n.docAffidavit, 'icon': Icons.edit_document, 'color': const Color(0xFFFF9F0A)},
      {'title': l10n.docOtherDocument, 'icon': Icons.folder_open_rounded, 'color': const Color(0xFF0A84FF)},
    ];

    return Scaffold(
      backgroundColor: context.colors.bgBase,
      appBar: AppBar(
        backgroundColor: context.colors.bgBase,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: context.colors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Generate Document',
          style: GoogleFonts.plusJakartaSans(
            color: context.colors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Choose Document Type'),
                const SizedBox(height: 16),
                _buildTypeGrid(docTypes),
                const SizedBox(height: 32),
                _buildSectionTitle('Provide Details'),
                const SizedBox(height: 16),
                _buildTextField('Your Name', 'e.g. Nifras S S', _nameCtrl),
                const SizedBox(height: 16),
                _buildTextField('Address', 'e.g. Coimbatore, Tamil Nadu', _addressCtrl),
                const SizedBox(height: 16),
                _buildTextField('Against (Name/Department/Organization)', 'e.g. XYZ Company', _againstCtrl),
                const SizedBox(height: 16),
                _buildTextField('Brief Description', 'Describe your issue here...', _descCtrl, maxLines: 4),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: context.colors.bgBase.withValues(alpha: 0.9),
                border: Border(
                  top: BorderSide(color: context.colors.borderStrong),
                ),
              ),
              child: SafeArea(
                child: GestureDetector(
                  onTap: _isGenerating ? null : () async {
                    HapticFeedback.mediumImpact();
                    if (_nameCtrl.text.isEmpty || _descCtrl.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill all details.')),
                      );
                      return;
                    }
                    
                    setState(() => _isGenerating = true);
                    try {
                      final requestBody = jsonEncode({
                        'name': _nameCtrl.text.trim(),
                        'address': _addressCtrl.text.trim(),
                        'against': _againstCtrl.text.trim(),
                        'description': _descCtrl.text.trim(),
                      });

                      // Assuming backend runs on 10.0.2.2 for Android emulator
                      final response = await http.post(
                        Uri.parse('https://sattam-ai-qr4d.onrender.com/generate_document'),
                        headers: {'Content-Type': 'application/json'},
                        body: requestBody,
                      );

                      if (response.statusCode == 200) {
                        final dir = await getTemporaryDirectory();
                        final filePath = '${dir.path}/SattamAI_Legal_Document.pdf';
                        final file = File(filePath);
                        await file.writeAsBytes(response.bodyBytes);
                        
                        await OpenFilex.open(filePath);
                      } else {
                        throw Exception('Server error: ${response.statusCode}');
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error generating document: $e')),
                        );
                      }
                    } finally {
                      setState(() => _isGenerating = false);
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 56,
                    decoration: BoxDecoration(
                      color: _isGenerating ? context.colors.surfaceContainerHigh : context.colors.primary,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: _isGenerating ? Colors.transparent : context.colors.primary.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_isGenerating)
                          SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: context.colors.primary, strokeWidth: 2))
                        else ...[
                          const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Generate Document',
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.plusJakartaSans(
        color: context.colors.textPrimary,
        fontSize: 15,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildTypeGrid(List<Map<String, dynamic>> docTypes) {
    return GridView.builder(
      itemCount: docTypes.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemBuilder: (context, index) {
        final data = docTypes[index];
        final isSelected = _selectedType == index;
        final baseColor = data['color'] as Color;

        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            setState(() => _selectedType = index);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected 
                  ? context.colors.primary.withValues(alpha: 0.1) 
                  : context.colors.surfaceContainer,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected 
                    ? context.colors.primary 
                    : context.colors.borderSubtle,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  data['icon'], 
                  color: isSelected ? context.colors.primary : baseColor, 
                  size: 26
                ),
                const SizedBox(height: 8),
                Text(
                  data['title'],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    color: isSelected ? context.colors.primary : context.colors.textPrimary,
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            color: context.colors.textMuted,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.colors.borderSubtle),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            style: GoogleFonts.plusJakartaSans(
              color: context.colors.textPrimary,
              fontSize: 15,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.plusJakartaSans(
                color: context.colors.textDisabled,
                fontSize: 15,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }
}
