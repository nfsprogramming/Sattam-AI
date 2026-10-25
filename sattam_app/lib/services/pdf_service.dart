import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

class PdfService {
  static Future<void> saveAndOpenPdf(pw.Document pdf, String fileName) async {
    final output = await getApplicationDocumentsDirectory();
    final file = File('${output.path}/$fileName');
    await file.writeAsBytes(await pdf.save());
    await OpenFilex.open(file.path);
  }

  static Future<void> generateRtiApplication(Map<String, dynamic> data) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  'APPLICATION UNDER RIGHT TO INFORMATION ACT, 2005',
                  style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.SizedBox(height: 30),
              pw.Text('To,'),
              pw.Text('The Public Information Officer (PIO)'),
              pw.Text(data['authorityName'] ?? '[Authority Name]'),
              pw.Text(data['authorityAddress'] ?? '[Authority Address]'),
              pw.SizedBox(height: 20),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('1. Name of the Applicant: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Expanded(child: pw.Text(data['applicantName'] ?? '[Applicant Name]')),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('2. Address: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Expanded(child: pw.Text(data['applicantAddress'] ?? '[Applicant Address]')),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('3. Subject Matter of Information: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Expanded(child: pw.Text(data['subject'] ?? '[Subject]')),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Text('4. The period to which the information relates: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text(data['period'] ?? '[Period]'),
              pw.SizedBox(height: 10),
              pw.Text('5. Description of the Information required: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 5),
              pw.Text(data['description'] ?? '[Description of Information]'),
              pw.SizedBox(height: 40),
              pw.Text('I state that the information sought does not fall within the restrictions contained in Section 8 and 9 of the Act and to the best of my knowledge it pertains to your office.'),
              pw.SizedBox(height: 30),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('Signature of Applicant'),
                    pw.SizedBox(height: 20),
                    pw.Text(data['applicantName'] ?? '[Applicant Name]'),
                  ],
                ),
              ),
              pw.Text('Place: ${data['place'] ?? '[Place]'}'),
              pw.Text('Date: ${data['date'] ?? '[Date]'}'),
            ],
          );
        },
      ),
    );

    await saveAndOpenPdf(pdf, 'RTI_Application_${DateTime.now().millisecondsSinceEpoch}.pdf');
  }

  static Future<void> generateLegalNotice(Map<String, dynamic> data) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  'LEGAL NOTICE',
                  style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, decoration: pw.TextDecoration.underline),
                ),
              ),
              pw.SizedBox(height: 30),
              pw.Text('Date: ${data['date'] ?? '[Date]'}'),
              pw.SizedBox(height: 20),
              pw.Text('To,'),
              pw.Text(data['recipientName'] ?? '[Recipient Name]', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text(data['recipientAddress'] ?? '[Recipient Address]'),
              pw.SizedBox(height: 20),
              pw.Text('Subject: ${data['subject'] ?? '[Subject]'}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text('Sir/Madam,'),
              pw.SizedBox(height: 10),
              pw.Text('Under the instructions from and on behalf of my client ${data['clientName'] ?? '[Client Name]'}, resident of ${data['clientAddress'] ?? '[Client Address]'}, I hereby serve you with the following legal notice:'),
              pw.SizedBox(height: 20),
              pw.Text(data['body'] ?? '[Notice Body]'),
              pw.SizedBox(height: 20),
              pw.Text('I therefore call upon you through this Legal Notice to ${data['demand'] ?? '[Demand Action]'} within a period of ${data['period'] ?? '15'} days from the date of receipt of this notice, failing which my client has given me clear instructions to institute civil as well as criminal proceedings against you in the competent court of law and in that event you shall be fully responsible for all costs, risks and responsibilities.'),
              pw.SizedBox(height: 40),
              pw.Text('Yours faithfully,'),
              pw.SizedBox(height: 40),
              pw.Text('[Advocate Signature / Client Signature]'),
              pw.Text('Name: ${data['senderName'] ?? '[Sender Name]'}'),
            ],
          );
        },
      ),
    );

    await saveAndOpenPdf(pdf, 'Legal_Notice_${DateTime.now().millisecondsSinceEpoch}.pdf');
  }
}
