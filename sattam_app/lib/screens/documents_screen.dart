import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/pdf_service.dart';
import 'package:sattam_app/l10n/app_localizations.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  int _selectedTypeIndex = 0; // 0 = RTI, 1 = Legal Notice

  // RTI Controllers
  final _rtiAuthorityController = TextEditingController();
  final _rtiAddressController = TextEditingController();
  final _rtiApplicantNameController = TextEditingController();
  final _rtiApplicantAddressController = TextEditingController();
  final _rtiSubjectController = TextEditingController();
  final _rtiPeriodController = TextEditingController();
  final _rtiDescController = TextEditingController();
  final _rtiPlaceController = TextEditingController();

  // Legal Notice Controllers
  final _lnRecipientController = TextEditingController();
  final _lnRecipientAddrController = TextEditingController();
  final _lnSubjectController = TextEditingController();
  final _lnClientNameController = TextEditingController();
  final _lnClientAddrController = TextEditingController();
  final _lnBodyController = TextEditingController();
  final _lnDemandController = TextEditingController();
  final _lnSenderController = TextEditingController();

  bool _isGenerating = false;

  @override
  void dispose() {
    _rtiAuthorityController.dispose();
    _rtiAddressController.dispose();
    _rtiApplicantNameController.dispose();
    _rtiApplicantAddressController.dispose();
    _rtiSubjectController.dispose();
    _rtiPeriodController.dispose();
    _rtiDescController.dispose();
    _rtiPlaceController.dispose();
    
    _lnRecipientController.dispose();
    _lnRecipientAddrController.dispose();
    _lnSubjectController.dispose();
    _lnClientNameController.dispose();
    _lnClientAddrController.dispose();
    _lnBodyController.dispose();
    _lnDemandController.dispose();
    _lnSenderController.dispose();
    super.dispose();
  }

  Future<void> _generatePdf() async {
    setState(() => _isGenerating = true);
    
    try {
      if (_selectedTypeIndex == 0) {
        // Generate RTI
        await PdfService.generateRtiApplication({
          'authorityName': _rtiAuthorityController.text.trim(),
          'authorityAddress': _rtiAddressController.text.trim(),
          'applicantName': _rtiApplicantNameController.text.trim(),
          'applicantAddress': _rtiApplicantAddressController.text.trim(),
          'subject': _rtiSubjectController.text.trim(),
          'period': _rtiPeriodController.text.trim(),
          'description': _rtiDescController.text.trim(),
          'place': _rtiPlaceController.text.trim(),
          'date': '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
        });
      } else {
        // Generate Legal Notice
        await PdfService.generateLegalNotice({
          'recipientName': _lnRecipientController.text.trim(),
          'recipientAddress': _lnRecipientAddrController.text.trim(),
          'subject': _lnSubjectController.text.trim(),
          'clientName': _lnClientNameController.text.trim(),
          'clientAddress': _lnClientAddrController.text.trim(),
          'body': _lnBodyController.text.trim(),
          'demand': _lnDemandController.text.trim(),
          'senderName': _lnSenderController.text.trim(),
          'date': '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
        });
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Document generated and opened successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to generate document: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: context.colors.textMuted),
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

  Widget _buildRtiForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField('Authority Name (e.g., PIO, Municipal Corp)', _rtiAuthorityController),
        _buildTextField('Authority Address', _rtiAddressController, maxLines: 2),
        _buildTextField('Your Full Name', _rtiApplicantNameController),
        _buildTextField('Your Address', _rtiApplicantAddressController, maxLines: 2),
        _buildTextField('Subject of Request', _rtiSubjectController),
        _buildTextField('Time Period of Information (e.g., 2021-2023)', _rtiPeriodController),
        _buildTextField('Detailed Description of Information Required', _rtiDescController, maxLines: 4),
        _buildTextField('Place (City/Town)', _rtiPlaceController),
      ],
    );
  }

  Widget _buildLegalNoticeForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField('Recipient Name (Who are you sending this to?)', _lnRecipientController),
        _buildTextField('Recipient Address', _lnRecipientAddrController, maxLines: 2),
        _buildTextField('Subject of Notice', _lnSubjectController),
        _buildTextField('Your Name (Client)', _lnClientNameController),
        _buildTextField('Your Address', _lnClientAddrController, maxLines: 2),
        _buildTextField('Details of Dispute / Notice Body', _lnBodyController, maxLines: 5),
        _buildTextField('Demand Action (e.g., pay Rs. 50,000)', _lnDemandController),
        _buildTextField('Sender Name (Advocate/Self)', _lnSenderController),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: context.colors.bgBase,
      appBar: AppBar(
        backgroundColor: context.colors.bgBase,
        title: Text(l10n.documents, style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedTypeIndex = 0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _selectedTypeIndex == 0 ? context.colors.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'RTI Application',
                            style: GoogleFonts.plusJakartaSans(
                              color: _selectedTypeIndex == 0 ? Colors.white : context.colors.textMuted,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedTypeIndex = 1),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _selectedTypeIndex == 1 ? context.colors.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Legal Notice',
                            style: GoogleFonts.plusJakartaSans(
                              color: _selectedTypeIndex == 1 ? Colors.white : context.colors.textMuted,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: _selectedTypeIndex == 0 ? _buildRtiForm() : _buildLegalNoticeForm(),
              ),
            ),
            
            // Generate Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _isGenerating ? null : _generatePdf,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  icon: _isGenerating 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.picture_as_pdf_rounded, color: Colors.white),
                  label: Text(
                    _selectedTypeIndex == 0 ? l10n.generateRti : l10n.generateNotice,
                    style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 80), // Padding for bottom nav
          ],
        ),
      ),
    );
  }
}
