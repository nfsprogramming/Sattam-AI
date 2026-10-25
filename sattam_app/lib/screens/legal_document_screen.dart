import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

enum LegalDocumentType { privacy, terms }

class LegalDocumentScreen extends StatelessWidget {
  final String title;
  final LegalDocumentType type;

  const LegalDocumentScreen({
    super.key,
    required this.title,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final content = type == LegalDocumentType.privacy 
        ? _getPrivacyPolicy() 
        : _getTermsAndConditions();

    return Scaffold(
      backgroundColor: context.colors.bgBase,
      appBar: AppBar(
        backgroundColor: context.colors.bgBase,
        elevation: 0,
        title: Text(
          title,
          style: GoogleFonts.playfairDisplay(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Text(
            content,
            style: GoogleFonts.playfairDisplay(
              color: context.colors.textOnSurface,
              fontSize: 16,
              height: 1.6,
            ),
          ),
        ),
      ),
    );
  }

  String _getPrivacyPolicy() {
    return '''Privacy Policy

Last Updated: July 2026

1. Information We Collect
We collect information you provide directly to us, such as when you create or modify your account, request legal services, contact customer support, or otherwise communicate with us. This information may include: name, email, phone number, encrypted legal documents, and voice recordings for AI processing.

2. How We Use Your Information
We use the information we collect about you to:
• Provide, maintain, and improve SattamAI services.
• Process and securely store your legal evidence.
• Connect you with verified legal professionals in Tamil Nadu.
• Send you technical notices, updates, security alerts, and support messages.

3. Data Security and Evidence Locker
Your data stored in the Evidence Locker is heavily encrypted using industry-standard AES-256 encryption. We utilize Row Level Security (RLS) to ensure that only you have access to your private documents. SattamAI does not have direct access to read your encrypted private evidence.

4. AI Processing
SattamAI utilizes advanced AI to analyze and summarize legal queries in Tamil and English. We do not use your private Evidence Locker documents to train our core foundational AI models without your explicit, opt-in consent.

5. Contact Us
If you have any questions about this Privacy Policy, please contact us at support@sattam.ai.
''';
  }

  String _getTermsAndConditions() {
    return '''Terms and Conditions

Last Updated: July 2026

1. Acceptance of Terms
By accessing and using SattamAI ("the App"), you accept and agree to be bound by the terms and provision of this agreement.

2. Description of Service
SattamAI is an AI-powered legal platform designed to bridge the gap between citizens and the legal system in Tamil Nadu. We provide informational legal AI summaries and tools for storing personal evidence. 

3. No Legal Advice
The content provided by the SattamAI chatbot is for informational purposes only and does NOT constitute professional legal advice. Always consult a verified, licensed attorney for legal counsel. SattamAI is not liable for any actions taken based on AI-generated information.

4. User Conduct
You agree to use the Evidence Locker and platform only for lawful purposes. Uploading illegal, defamatory, or malicious content is strictly prohibited and will result in immediate account termination.

5. Lawyer Verification
Lawyers registered on the platform are independently verified against Bar Council records. However, SattamAI does not guarantee the outcome of any legal representation resulting from connections made on this platform.

6. Modifications
SattamAI reserves the right to modify these terms at any time. Your continued use of the App following any changes indicates your acceptance of the new terms.
''';
  }
}
