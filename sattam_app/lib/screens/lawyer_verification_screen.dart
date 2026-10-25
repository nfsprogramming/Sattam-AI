import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/supabase_service.dart';

class LawyerVerificationScreen extends StatefulWidget {
  const LawyerVerificationScreen({super.key});

  @override
  State<LawyerVerificationScreen> createState() => _LawyerVerificationScreenState();
}

class _LawyerVerificationScreenState extends State<LawyerVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  final _barCouncilIdController = TextEditingController();
  final _specController = TextEditingController();
  final _expController = TextEditingController();
  final _locController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _barCouncilIdController.dispose();
    _specController.dispose();
    _expController.dispose();
    _locController.dispose();
    super.dispose();
  }

  Future<void> _submitApplication() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isSubmitting = true);
    
    try {
      await SupabaseService.applyForLawyerVerification(
        name: _nameController.text.trim(),
        barCouncilId: _barCouncilIdController.text.trim(),
        specialization: _specController.text.trim(),
        experience: _expController.text.trim(),
        location: _locController.text.trim(),
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Application submitted successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit application: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Widget _buildTextField(String label, TextEditingController controller, {String? hint, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        validator: validator ?? (value) => value == null || value.isEmpty ? 'Required field' : null,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: TextStyle(color: context.colors.textMuted),
          hintStyle: TextStyle(color: context.colors.textMuted),
          filled: true,
          fillColor: context.colors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: context.colors.primary),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.bgBase,
      appBar: AppBar(
        backgroundColor: context.colors.bgBase,
        title: Text('Lawyer Verification', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Join Sattam AI',
                  style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Submit your credentials to be listed in our verified lawyers directory and connect with citizens.',
                  style: GoogleFonts.plusJakartaSans(color: context.colors.textMuted, fontSize: 14),
                ),
                const SizedBox(height: 32),
                
                _buildTextField('Full Name (as per records)', _nameController),
                _buildTextField('Bar Council ID', _barCouncilIdController, hint: 'e.g., MS/1234/2015'),
                _buildTextField('Primary Specialization', _specController, hint: 'e.g., Criminal Law, Family Law'),
                _buildTextField('Years of Experience', _expController, hint: 'e.g., 8 Years'),
                _buildTextField('Location / Court', _locController, hint: 'e.g., Madras High Court, Chennai'),
                
                const SizedBox(height: 32),
                
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitApplication,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: _isSubmitting 
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text(
                          'Submit for Verification',
                          style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
