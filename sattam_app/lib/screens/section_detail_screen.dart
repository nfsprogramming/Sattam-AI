import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/law_models.dart';
import '../theme/app_theme.dart';

class SectionDetailScreen extends StatelessWidget {
  final LawSection section;

  const SectionDetailScreen({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.bgBase,
      appBar: AppBar(
        backgroundColor: context.colors.bgBase,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: context.colors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: context.colors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                section.sectionNumber,
                style: GoogleFonts.plusJakartaSans(
                  color: context.colors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              section.title,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              section.description,
              style: GoogleFonts.plusJakartaSans(
                color: context.colors.textMuted,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),
            const Divider(color: Color(0xFF2C2C2E)),
            const SizedBox(height: 32),
            Text(
              'Complete Explanation',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              section.completeExplanation,
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFFCCCCCC),
                fontSize: 15,
                height: 1.8,
              ),
            ),
            const SizedBox(height: 100), // spacing for FAB
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: context.colors.primary,
        onPressed: () {
          // Send to chat
          Navigator.popUntil(context, (route) => route.isFirst);
          // Assuming MainScreen is root, we could pass it down, but let's just pop to root 
          // and let the user open the chat tab.
        },
        icon: const Icon(Icons.chat_bubble_outline_rounded, color: Colors.white),
        label: Text(
          'Ask Sattam AI',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
