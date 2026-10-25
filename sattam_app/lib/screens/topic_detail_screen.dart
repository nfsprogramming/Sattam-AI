import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class TopicDetailScreen extends StatelessWidget {
  final String title;

  const TopicDetailScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: context.colors.bgBase,
        appBar: AppBar(
          backgroundColor: context.colors.bgBase,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: context.colors.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              color: context.colors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 2,
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.share_outlined, color: context.colors.textPrimary),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.bookmark_border_rounded, color: context.colors.textPrimary),
              onPressed: () {},
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: context.colors.borderStrong, width: 1),
                ),
              ),
              child: TabBar(
                isScrollable: true,
                labelColor: context.colors.primary,
                unselectedLabelColor: context.colors.textMuted,
                indicatorColor: context.colors.primary,
                indicatorWeight: 3,
                dividerColor: Colors.transparent,
                labelStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                tabs: const [
                  Tab(text: 'Answer'),
                  Tab(text: 'Your Rights'),
                  Tab(text: 'Documents'),
                  Tab(text: 'Laws'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            const _AnswerTab(),
            Center(child: Text('Your Rights Content', style: TextStyle(color: context.colors.textMuted))),
            Center(child: Text('Documents Content', style: TextStyle(color: context.colors.textMuted))),
            Center(child: Text('Laws Content', style: TextStyle(color: context.colors.textMuted))),
          ],
        ),
      ),
    );
  }
}

class _AnswerTab extends StatelessWidget {
  const _AnswerTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // In Short
          _buildSectionTitle(context, 'In Short'),
          const SizedBox(height: 12),
          Text(
            'You can file a consumer complaint with the District Consumer Commission where the opposite party resides or where the cause of action arose.',
            style: GoogleFonts.plusJakartaSans(
              color: context.colors.textOnSurface,
              fontSize: 15,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
          Divider(color: context.colors.borderSubtle),
          const SizedBox(height: 24),

          // Steps to File
          _buildSectionTitle(context, 'Steps to File'),
          const SizedBox(height: 16),
          _buildStepItem(context, 1, 'Send a legal notice to the opposite party.'),
          const SizedBox(height: 16),
          _buildStepItem(context, 2, 'If no response, file a complaint with the District Consumer Commission.'),
          const SizedBox(height: 16),
          _buildStepItem(context, 3, 'Attach necessary documents and evidence.'),
          const SizedBox(height: 16),
          _buildStepItem(context, 4, 'Pay the required filing fee.'),
          const SizedBox(height: 16),
          _buildStepItem(context, 5, 'Attend the hearing and follow the process.'),
          const SizedBox(height: 24),
          Divider(color: context.colors.borderSubtle),
          const SizedBox(height: 24),

          // Required Documents
          _buildSectionTitle(context, 'Required Documents'),
          const SizedBox(height: 16),
          _buildBulletItem(context, 'Proof of payment / Bill'),
          const SizedBox(height: 12),
          _buildBulletItem(context, 'Identity proof'),
          const SizedBox(height: 12),
          _buildBulletItem(context, 'Address proof'),
          const SizedBox(height: 12),
          _buildBulletItem(context, 'Defective product/service proof'),
          const SizedBox(height: 12),
          _buildBulletItem(context, 'Legal notice copy (if any)'),
          const SizedBox(height: 32),

          // Relevant Law Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.colors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.colors.primary.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: context.colors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.gavel_rounded, color: context.colors.primary, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Relevant Law',
                        style: GoogleFonts.plusJakartaSans(
                          color: context.colors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Consumer Protection Act, 2019',
                        style: GoogleFonts.plusJakartaSans(
                          color: context.colors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: context.colors.textMuted),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: GoogleFonts.plusJakartaSans(
        color: context.colors.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildStepItem(BuildContext context, int step, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          margin: const EdgeInsets.only(top: 2),
          decoration: BoxDecoration(
            color: context.colors.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              step.toString(),
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              color: context.colors.textOnSurface,
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBulletItem(BuildContext context, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8, right: 12),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: context.colors.primary,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              color: context.colors.textOnSurface,
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
