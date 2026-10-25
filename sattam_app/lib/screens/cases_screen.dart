import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/supabase_service.dart';
import 'package:sattam_app/l10n/app_localizations.dart';

class CasesScreen extends StatefulWidget {
  const CasesScreen({super.key});

  @override
  State<CasesScreen> createState() => _CasesScreenState();
}

class _CasesScreenState extends State<CasesScreen> {
  List<Map<String, dynamic>> _cases = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCases();
  }

  Future<void> _loadCases() async {
    setState(() => _isLoading = true);
    try {
      final cases = await SupabaseService.getCases();
      if (mounted) {
        setState(() {
          _cases = cases;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load cases: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _showAddCaseModal() async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final l10n = AppLocalizations.of(context)!;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1C1C1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.addNewCase,
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: l10n.caseTitle,
                  labelStyle: TextStyle(color: context.colors.textMuted),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: context.colors.textMuted)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: l10n.descriptionOptional,
                  labelStyle: TextStyle(color: context.colors.textMuted),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: context.colors.textMuted)),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: context.colors.primary),
                  onPressed: () async {
                    if (titleController.text.trim().isEmpty) return;
                    Navigator.pop(context);
                    
                    try {
                      await SupabaseService.createCase(
                        title: titleController.text.trim(),
                        description: descriptionController.text.trim(),
                      );
                      _loadCases();
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error adding case: $e'), backgroundColor: Colors.red),
                        );
                      }
                    }
                  },
                  child: Text(l10n.saveCase, style: const TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: context.colors.bgBase,
      appBar: AppBar(
        backgroundColor: context.colors.bgBase,
        title: Text(l10n.myCases, style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.add_rounded, color: context.colors.primary),
            onPressed: _showAddCaseModal,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: context.colors.primary))
          : _cases.isEmpty
              ? _buildEmptyState(l10n)
              : _buildCasesList(),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open_rounded, size: 64, color: context.colors.textMuted),
          const SizedBox(height: 16),
          Text(
            l10n.noActiveCases,
            style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.keepTrackHere,
            style: GoogleFonts.plusJakartaSans(color: context.colors.textMuted, fontSize: 14),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _showAddCaseModal,
            icon: const Icon(Icons.add),
            label: Text(l10n.addCase),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.primary,
              foregroundColor: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCasesList() {
    return ListView.builder(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 100),
      itemCount: _cases.length,
      itemBuilder: (context, index) {
        final caseData = _cases[index];
        return Card(
          color: const Color(0xFF1C1C1E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: context.colors.primary.withValues(alpha: 0.2),
              child: Icon(Icons.gavel_rounded, color: context.colors.primary),
            ),
            title: Text(
              caseData['title'],
              style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  'Status: ${caseData['status']}',
                  style: GoogleFonts.plusJakartaSans(color: context.colors.primary, fontWeight: FontWeight.w500),
                ),
                if (caseData['description'] != null && caseData['description'].toString().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    caseData['description'],
                    style: GoogleFonts.plusJakartaSans(color: context.colors.textMuted),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ]
              ],
            ),
          ),
        );
      },
    );
  }
}
