import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/supabase_service.dart';
import 'main_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  DateTime? _selectedDob;
  bool _isLoading = false;
  bool _obscurePassword = true;
  
  bool _confirmAge = false;
  bool _agreeToTos = false;
  bool _agreeToPrivacy = false;

  Future<void> _pickDob() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: context.colors.primary,
              onPrimary: Colors.white,
              surface: Color(0xFF1C1C1E),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDob = picked;
      });
    }
  }

  bool _is18OrOlder() {
    if (_selectedDob == null) return false;
    final today = DateTime.now();
    int age = today.year - _selectedDob!.year;
    if (today.month < _selectedDob!.month || 
        (today.month == _selectedDob!.month && today.day < _selectedDob!.day)) {
      age--;
    }
    return age >= 18;
  }

  Future<void> _signUp() async {
    setState(() => _isLoading = true);
    try {
      final name = _nameController.text.trim();
      final phone = _phoneController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      
      if (name.isEmpty) throw Exception('Please enter your full name.');
      if (email.isEmpty) throw Exception('Please enter your email.');
      if (password.isEmpty) throw Exception('Please enter your password.');
      if (_selectedDob == null) throw Exception('Please select your Date of Birth.');
      if (!_is18OrOlder()) throw Exception('You must be 18 years or older to use this app.');
      if (!_confirmAge || !_agreeToTos || !_agreeToPrivacy) {
        throw Exception('Please agree to all checkboxes to continue.');
      }
      
      await SupabaseService.client.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': name,
          'phone': phone,
          'dob': _selectedDob!.toIso8601String(),
        }
      );
      
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        String msg = e.toString();
        if (e is AuthException) msg = e.message;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg, style: const TextStyle(color: Colors.white)), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      await SupabaseService.signInWithGoogle();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}', style: const TextStyle(color: Colors.white)), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.bgBase,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create Account',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Join Sattam AI to securely manage your legal cases and documents.',
                style: GoogleFonts.plusJakartaSans(
                  color: context.colors.textMuted,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 32),
              
              _buildTextField('Full Name', Icons.person_outline, _nameController),
              const SizedBox(height: 16),
              
              _buildTextField('Mobile Number', Icons.phone_android_rounded, _phoneController, isNumeric: true),
              const SizedBox(height: 16),
              
              _buildTextField('Email Address', Icons.email_outlined, _emailController),
              const SizedBox(height: 16),
              
              _buildDobField(),
              const SizedBox(height: 16),
              
              _buildPasswordField(),
              const SizedBox(height: 24),
              
              _buildCheckbox(
                'I confirm that I am at least 18 years old.',
                _confirmAge,
                (v) => setState(() => _confirmAge = v ?? false)
              ),
              _buildCheckbox(
                'I agree to the Terms of Service.',
                _agreeToTos,
                (v) => setState(() => _agreeToTos = v ?? false)
              ),
              _buildCheckbox(
                'I agree to the Privacy Policy.',
                _agreeToPrivacy,
                (v) => setState(() => _agreeToPrivacy = v ?? false)
              ),
              
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Create Account',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              
              const SizedBox(height: 24),
              Row(
                children: [
                  const Expanded(child: Divider(color: Color(0xFF2C2C2E))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('OR', style: GoogleFonts.plusJakartaSans(color: context.colors.textMuted)),
                  ),
                  const Expanded(child: Divider(color: Color(0xFF2C2C2E))),
                ],
              ),
              const SizedBox(height: 24),
              
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: _isLoading ? null : _signInWithGoogle,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF2C2C2E)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  icon: Image.asset(
                    'assets/images/google_logo.png',
                    height: 24,
                  ),
                  label: Text(
                    'Continue with Google',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: GoogleFonts.plusJakartaSans(color: context.colors.textMuted),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      'Sign In',
                      style: GoogleFonts.plusJakartaSans(
                        color: context.colors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, IconData icon, TextEditingController controller, {bool isNumeric = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2C2C2E)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: isNumeric ? TextInputType.phone : TextInputType.text,
        style: GoogleFonts.plusJakartaSans(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: GoogleFonts.plusJakartaSans(color: context.colors.textMuted),
          icon: Icon(icon, color: context.colors.textMuted),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2C2C2E)),
      ),
      child: TextField(
        controller: _passwordController,
        obscureText: _obscurePassword,
        style: GoogleFonts.plusJakartaSans(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Password',
          hintStyle: GoogleFonts.plusJakartaSans(color: context.colors.textMuted),
          icon: Icon(Icons.lock_outline, color: context.colors.textMuted),
          suffixIcon: IconButton(
            icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: context.colors.textMuted),
            onPressed: () {
              setState(() => _obscurePassword = !_obscurePassword);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDobField() {
    return GestureDetector(
      onTap: _pickDob,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2C2C2E)),
        ),
        child: Row(
          children: [
            Icon(Icons.cake_outlined, color: context.colors.textMuted),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedDob == null
                        ? 'Date of Birth'
                        : '${_selectedDob!.day}/${_selectedDob!.month}/${_selectedDob!.year}',
                    style: GoogleFonts.plusJakartaSans(
                      color: _selectedDob == null ? context.colors.textMuted : Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  if (_selectedDob == null) ...[
                    const SizedBox(height: 4),
                    Text(
                      '(Must be 18 years or older)',
                      style: GoogleFonts.plusJakartaSans(color: context.colors.textMuted, fontSize: 12),
                    )
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckbox(String title, bool value, Function(bool?) onChanged) {
    return Theme(
      data: ThemeData(unselectedWidgetColor: context.colors.textMuted),
      child: CheckboxListTile(
        title: Text(
          title,
          style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 14),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: context.colors.primary,
        checkColor: Colors.white,
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.zero,
        dense: true,
      ),
    );
  }
}
