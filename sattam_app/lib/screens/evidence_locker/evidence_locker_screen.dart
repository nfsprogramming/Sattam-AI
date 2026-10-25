import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sattam_app/theme/app_theme.dart';
import 'widgets/upload_bottom_sheet.dart';
import '../../services/evidence_service.dart';
import 'widgets/file_grid_card.dart';
import 'file_detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'locker_auth_screen.dart';

class EvidenceLockerScreen extends StatefulWidget {
  const EvidenceLockerScreen({super.key});

  @override
  State<EvidenceLockerScreen> createState() => _EvidenceLockerScreenState();
}

class _EvidenceLockerScreenState extends State<EvidenceLockerScreen> {
  final List<String> _filters = [
    'All', 'Images', 'Videos', 'Audio', 'PDF', 'Documents', 'Receipts', 'Screenshots'
  ];
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.bgBase,
      appBar: AppBar(
        backgroundColor: context.colors.bgBase,
        elevation: 0,
        title: Text(
          'Evidence Locker',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded, color: Colors.white),
            onPressed: _showSettings,
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildSummaryCards()),
            SliverToBoxAdapter(child: _buildSearchBar()),
            SliverToBoxAdapter(child: _buildFilterChips()),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              sliver: _buildFilesGrid(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showUploadBottomSheet,
        backgroundColor: context.colors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          'Upload Evidence',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: context.colors.bgBase,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Locker Settings', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              ListTile(
                leading: Icon(Icons.password_rounded, color: context.colors.primary),
                title: Text('Reset PIN', style: GoogleFonts.plusJakartaSans(color: Colors.white)),
                subtitle: Text('Remove your current PIN to set a new one', style: GoogleFonts.plusJakartaSans(color: context.colors.textMuted, fontSize: 12)),
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('locker_pin');
                  if (context.mounted) {
                    Navigator.pop(context); // Close sheet
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LockerAuthScreen()));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: Text(
        'Securely manage your legal documents and files.',
        style: GoogleFonts.plusJakartaSans(
          color: context.colors.textMuted,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(child: _buildSummaryCard('Total Files', '0', Icons.folder_rounded)),
          const SizedBox(width: 12),
          Expanded(child: _buildSummaryCard('Storage', '0 MB', Icons.cloud_done_rounded)),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  color: context.colors.textMuted,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(icon, size: 16, color: context.colors.primary),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.colors.borderSubtle),
        ),
        child: Row(
          children: [
            Icon(Icons.search_rounded, color: context.colors.textMuted, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                style: GoogleFonts.plusJakartaSans(color: context.colors.textPrimary, fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'Search files, OCR text, or tags...',
                  hintStyle: GoogleFonts.plusJakartaSans(color: context.colors.textMuted, fontSize: 15),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: _filters.map((filter) {
          final isSelected = filter == _selectedFilter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(
                filter,
                style: GoogleFonts.plusJakartaSans(
                  color: isSelected ? Colors.white : context.colors.textMuted,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() => _selectedFilter = filter);
                }
              },
              backgroundColor: context.colors.surface,
              selectedColor: context.colors.primary.withValues(alpha: 0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? context.colors.primary : context.colors.borderSubtle,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFilesGrid() {
    return FutureBuilder<List<EvidenceFile>>(
      future: EvidenceService.getUserEvidence(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text(
                'Error loading files: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        final files = snapshot.data ?? [];
        
        if (files.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: _buildEmptyState(),
          );
        }

        return SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.85,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final file = files[index];
              return FileGridCard(
                fileName: file.fileName,
                fileType: file.fileType,
                date: DateFormat('MMM d, yyyy').format(file.createdAt),
                size: '${(file.size / (1024 * 1024)).toStringAsFixed(2)} MB',
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FileDetailScreen(evidenceFile: file),
                    ),
                  );
                  if (result == true) {
                    setState(() {}); // Refresh grid if file was deleted
                  }
                },
              );
            },
            childCount: files.length,
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: context.colors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.folder_open_rounded,
                size: 64,
                color: context.colors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Evidence Yet',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Upload documents, images, videos or recordings related to your legal matters to keep everything organized in one secure place.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                color: context.colors.textMuted,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _showUploadBottomSheet,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Upload First File',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(height: 80), // Padding for FAB
          ],
        ),
      ),
    );
  }

  void _showUploadBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const UploadBottomSheet(),
    ).then((_) {
      // Refresh the grid when bottom sheet closes
      setState(() {});
    });
  }
}
