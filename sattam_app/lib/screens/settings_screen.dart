import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = true; // SattamAI is strictly dark mode by design, but we can show it as an option

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.bgBase,
      appBar: AppBar(
        backgroundColor: context.colors.bgBase,
        elevation: 0,
        title: Text(
          'Settings',
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
            _buildSectionHeader('Preferences'),
            const SizedBox(height: 16),
            _buildSwitchTile(
              title: 'Push Notifications',
              subtitle: 'Receive updates on your case',
              icon: Icons.notifications_active_rounded,
              value: _notificationsEnabled,
              onChanged: (val) => setState(() => _notificationsEnabled = val),
            ),
            const SizedBox(height: 12),
            _buildSwitchTile(
              title: 'Dark Mode',
              subtitle: 'Recommended for AMOLED screens',
              icon: Icons.dark_mode_rounded,
              value: _darkModeEnabled,
              onChanged: (val) {
                // SattamAI is hardcoded to Dark Theme for premium look,
                // but we simulate the toggle state for UX completeness
                setState(() => _darkModeEnabled = true);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('SattamAI is exclusively designed for Dark Mode.')),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildActionTile(
              title: 'Language',
              subtitle: _getLanguageName(appLocale.value.languageCode),
              icon: Icons.language_rounded,
              onTap: () => _showLanguagePicker(context),
            ),
            
            const SizedBox(height: 40),
            _buildSectionHeader('Account Management'),
            const SizedBox(height: 16),
            _buildActionTile(
              title: 'Change Password',
              subtitle: 'Update your account security',
              icon: Icons.lock_reset_rounded,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password reset link sent to your email')),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildActionTile(
              title: 'Delete Account',
              subtitle: 'Permanently delete all your data',
              icon: Icons.delete_forever_rounded,
              isDestructive: true,
              onTap: () => _showDeleteConfirmation(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.playfairDisplay(
        color: context.colors.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.borderSubtle),
      ),
      child: Row(
        children: [
          Icon(icon, color: context.colors.primary, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    color: context.colors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    color: context.colors.textMuted,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: context.colors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? context.colors.sosRed : context.colors.primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDestructive ? context.colors.sosRed.withValues(alpha: 0.3) : context.colors.borderSubtle,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      color: isDestructive ? context.colors.sosRed : context.colors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      color: context.colors.textMuted,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: context.colors.textMuted),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.colors.surface,
        title: Text('Delete Account?', style: GoogleFonts.playfairDisplay(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text(
          'Are you sure you want to permanently delete your account? All your encrypted evidence will be lost forever. This action cannot be undone.',
          style: GoogleFonts.plusJakartaSans(color: context.colors.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.plusJakartaSans(color: context.colors.textPrimary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account deletion requested. Please contact support.')),
              );
            },
            child: Text('Delete', style: GoogleFonts.plusJakartaSans(color: context.colors.sosRed, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'en': return 'English';
      case 'ta': return 'தமிழ் (Tamil)';
      case 'hi': return 'हिन्दी (Hindi)';
      case 'bn': return 'বাংলা (Bengali)';
      case 'te': return 'తెలుగు (Telugu)';
      case 'mr': return 'मराठी (Marathi)';
      default: return 'English';
    }
  }

  void _showLanguagePicker(BuildContext context) {
    final languages = [
      {'code': 'en', 'name': 'English'},
      {'code': 'ta', 'name': 'தமிழ் (Tamil)'},
      {'code': 'hi', 'name': 'हिन्दी (Hindi)'},
      {'code': 'bn', 'name': 'বাংলা (Bengali)'},
      {'code': 'te', 'name': 'తెలుగు (Telugu)'},
      {'code': 'mr', 'name': 'मराठी (Marathi)'},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: context.colors.bgBase,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
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
                  'Select Language',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ...languages.map((lang) {
                  final isSelected = appLocale.value.languageCode == lang['code'];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      lang['name']!,
                      style: GoogleFonts.plusJakartaSans(
                        color: isSelected ? context.colors.primary : context.colors.textPrimary,
                        fontSize: 16,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check_circle_rounded, color: context.colors.primary)
                        : null,
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString('languageCode', lang['code']!);
                      appLocale.value = Locale(lang['code']!, '');
                      setState(() {});
                      if (context.mounted) Navigator.pop(context);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
