import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/supabase_service.dart';
import 'login_screen.dart';
import 'edit_profile_screen.dart';
import 'lawyer_verification_screen.dart';
import 'evidence_locker/locker_auth_screen.dart';
import 'legal_document_screen.dart';
import 'settings_screen.dart';
import 'help_support_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  Future<void> _signOut(BuildContext context) async {
    await SupabaseService.client.auth.signOut();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Reading currentUser inside build ensures we grab the latest metadata if we refresh
    final user = SupabaseService.client.auth.currentUser;
    final fullName = user?.userMetadata?['full_name'] as String?;
    final avatarUrl = user?.userMetadata?['avatar_url'] as String?;

    return Scaffold(
      backgroundColor: context.colors.bgBase,
      appBar: AppBar(
        backgroundColor: context.colors.bgBase,
        elevation: 0,
        title: Text(
          'Profile',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundColor: context.colors.primary.withValues(alpha: 0.2),
                backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
                child: avatarUrl == null ? Icon(Icons.person_rounded, size: 50, color: context.colors.primary) : null,
              ),
              const SizedBox(height: 24),
              Text(
                fullName ?? user?.email ?? 'Unknown User',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (fullName != null)
                Text(
                  user?.email ?? '',
                  style: GoogleFonts.plusJakartaSans(
                    color: context.colors.textMuted,
                    fontSize: 14,
                  ),
                ),
              Text(
                'Sattam AI Member',
                style: GoogleFonts.plusJakartaSans(
                  color: context.colors.textMuted,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                  );
                  if (result == true) {
                    setState(() {}); // refresh the UI with new name
                  }
                },
                icon: const Icon(Icons.edit_rounded, size: 18),
                label: const Text('Edit Profile'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: context.colors.borderSubtle),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
              const SizedBox(height: 48),
              _buildProfileOption(Icons.settings_rounded, 'Settings', onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
              }),
              _buildProfileOption(Icons.gavel_rounded, 'Verify as Lawyer', onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const LawyerVerificationScreen()));
              }),
              _buildProfileOption(Icons.shield_rounded, 'Evidence Locker', onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const LockerAuthScreen()));
              }),
              _buildProfileOption(Icons.security_rounded, 'Privacy & Security', onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const LegalDocumentScreen(
                  title: 'Privacy Policy', 
                  type: LegalDocumentType.privacy,
                )));
              }),
              _buildProfileOption(Icons.description_rounded, 'Terms & Conditions', onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const LegalDocumentScreen(
                  title: 'Terms & Conditions', 
                  type: LegalDocumentType.terms,
                )));
              }),
              _buildProfileOption(Icons.help_outline_rounded, 'Help & Support', onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpSupportScreen()));
              }),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () => _signOut(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.withValues(alpha: 0.1),
                    foregroundColor: Colors.red,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  icon: const Icon(Icons.logout_rounded),
                  label: Text(
                    'Sign Out',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 80), // spacing for bottom nav bar padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.colors.borderSubtle),
        ),
        child: Row(
          children: [
            Icon(icon, color: context.colors.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  color: context.colors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: context.colors.textMuted),
          ],
        ),
      ),
    );
  }
}
