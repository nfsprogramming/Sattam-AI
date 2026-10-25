import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.bgBase,
      appBar: AppBar(
        backgroundColor: context.colors.bgBase,
        elevation: 0,
        title: Text(
          'Help & Support',
          style: GoogleFonts.playfairDisplay(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              'Frequently Asked Questions',
              style: GoogleFonts.playfairDisplay(
                color: context.colors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildFaqItem(
              context,
              question: 'Is SattamAI a replacement for a real lawyer?',
              answer: 'No. SattamAI provides AI-generated legal summaries and information based on Indian law. It is designed to empower you with knowledge, but it does NOT provide professional legal advice. Always consult a verified lawyer for your case.',
            ),
            _buildFaqItem(
              context,
              question: 'Who can see my Evidence Locker files?',
              answer: 'Your Evidence Locker files are strictly private and encrypted. Only you can view them unless you explicitly share them with a verified lawyer on our platform.',
            ),
            _buildFaqItem(
              context,
              question: 'How do you verify the lawyers on the platform?',
              answer: 'All lawyers must submit their Bar Council ID and credentials during registration. We independently verify these details before approving their profile on SattamAI.',
            ),
            _buildFaqItem(
              context,
              question: 'Does the AI understand Tamil?',
              answer: 'Yes! SattamAI is fully bilingual. You can ask legal questions or describe your situation in Tamil, and the AI will respond in clear, easy-to-understand Tamil.',
            ),
            const SizedBox(height: 32),
            Text(
              'Contact Us',
              style: GoogleFonts.playfairDisplay(
                color: context.colors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildContactCard(
              context,
              icon: Icons.email_rounded,
              title: 'Email Support',
              subtitle: 'support@sattam.ai',
            ),
            const SizedBox(height: 12),
            _buildContactCard(
              context,
              icon: Icons.phone_in_talk_rounded,
              title: 'Toll-Free Helpline',
              subtitle: '1800-123-4567',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(BuildContext context, {required String question, required String answer}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.borderSubtle),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: GoogleFonts.plusJakartaSans(
            color: context.colors.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconColor: context.colors.primary,
        collapsedIconColor: context.colors.textMuted,
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Text(
            answer,
            style: GoogleFonts.plusJakartaSans(
              color: context.colors.textMuted,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(BuildContext context, {required IconData icon, required String title, required String subtitle}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.borderSubtle),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.colors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: context.colors.primary),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  color: context.colors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.plusJakartaSans(
                  color: context.colors.textMuted,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
