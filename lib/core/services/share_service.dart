import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ShareService {
  static const String baseUrl = 'https://scoutme.co.uk';
  static const String appName = 'ScoutMe';

  /// Copy profile link to clipboard
  static Future<bool> copyProfileLink({
    required String playerName,
    String playerId = '1',
  }) async {
    final slug = playerName.toLowerCase().replaceAll(' ', '-');
    final url = '$baseUrl/player/$slug';
    await Clipboard.setData(ClipboardData(text: url));
    return true;
  }

  /// Open native share sheet
  static Future<void> shareProfile({
    required String playerName,
    required String position,
    required String club,
    String playerId = '1',
  }) async {
    final slug = playerName.toLowerCase().replaceAll(' ', '-');
    final url = '$baseUrl/player/$slug';
    final text = '''
🏆 Check out this football profile on ScoutMe!

$playerName
$position • $club

View full profile: $url
''';
    await SharePlus.instance.share(ShareParams(text: text));
  }

  /// Open email client with pre-filled details
  static Future<void> emailProfile({
    required String playerName,
    required String position,
    required String step,
  }) async {
    final slug = playerName.toLowerCase().replaceAll(' ', '-');
    final url = '$baseUrl/player/$slug';
    final subject = Uri.encodeComponent('$appName Player Profile');
    final body = Uri.encodeComponent('''Hi,

I'd like to share this football profile with you.

Player: $playerName
Position: $position
Current Step: $step

View Profile: $url

Sent via ScoutMe
''');
    final mailto = Uri.parse('mailto:?subject=$subject&body=$body');
    if (await canLaunchUrl(mailto)) {
      await launchUrl(mailto);
    }
  }

  /// Generate and download/save professional PDF
  static Future<void> downloadCV({
    required String playerName,
    required String age,
    required String position,
    required String preferredFoot,
    required String currentClub,
    required String currentStep,
    required String height,
    required String weight,
    required String county,
    required String availability,
    required List<String> achievements,
    required List<Map<String, String>> clubHistory,
    required Map<String, String> stats,
    required String email,
    required String phone,
  }) async {
    final pdf = pw.Document();
    final slug = playerName.toLowerCase().replaceAll(' ', '-');
    final url = '$baseUrl/player/$slug';

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => [
          // Header
          pw.Container(
            padding: const pw.EdgeInsets.only(bottom: 20),
            decoration: pw.BoxDecoration(
              border: pw.Border(bottom: pw.BorderSide(color: PdfColors.orange, width: 3)),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(playerName, style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 4),
                    pw.Text('$position • $currentClub • $currentStep', style: pw.TextStyle(fontSize: 14, color: PdfColors.grey700)),
                    pw.SizedBox(height: 4),
                    pw.Text('$age years • $preferredFoot foot • $height • $weight', style: pw.TextStyle(fontSize: 11, color: PdfColors.grey500)),
                  ],
                ),
                pw.Container(
                  width: 100, height: 100,
                  decoration: pw.BoxDecoration(
                    color: PdfColors.orange100,
                    borderRadius: pw.BorderRadius.circular(50),
                  ),
                  child: pw.Center(
                    child: pw.Text(
                      playerName.split(' ').map((e) => e[0]).join(),
                      style: pw.TextStyle(fontSize: 36, color: PdfColors.orange, fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 24),

          // Football CV
          pw.Text('Football CV', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 12),
          _pdfRow('Position', position),
          _pdfRow('Preferred Foot', preferredFoot),
          _pdfRow('Current Club', currentClub),
          _pdfRow('Current Step', currentStep),
          _pdfRow('County', county),
          _pdfRow('Availability', availability),
          pw.SizedBox(height: 24),

          // Club History
          pw.Text('Club History', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 12),
          ...clubHistory.map((c) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 8),
            child: pw.Row(
              children: [
                pw.Container(width: 8, height: 8, decoration: const pw.BoxDecoration(color: PdfColors.orange, shape: pw.BoxShape.circle)),
                pw.SizedBox(width: 8),
                pw.Text('${c['club']} — ${c['years']} (${c['step']})', style: pw.TextStyle(fontSize: 12)),
              ],
            ),
          )),
          pw.SizedBox(height: 24),

          // Statistics
          pw.Text('Season Statistics (2025/26)', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 12),
          pw.Wrap(
            spacing: 16,
            runSpacing: 8,
            children: stats.entries.map((e) => pw.SizedBox(
              width: 140,
              child: pw.Row(
                children: [
                  pw.Text('${e.key}: ', style: pw.TextStyle(fontSize: 12, color: PdfColors.grey600)),
                  pw.Text(e.value, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                ],
              ),
            )).toList(),
          ),
          pw.SizedBox(height: 24),

          // Achievements
          pw.Text('Achievements', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 12),
          ...achievements.map((a) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 6),
            child: pw.Row(
              children: [
                pw.Text('🏆 ', style: const pw.TextStyle(fontSize: 14)),
                pw.Text(a, style: pw.TextStyle(fontSize: 12)),
              ],
            ),
          )),
          pw.SizedBox(height: 24),

          // Contact
          pw.Text('Contact', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 12),
          pw.Text('Email: $email', style: pw.TextStyle(fontSize: 12)),
          pw.Text('Phone: $phone', style: pw.TextStyle(fontSize: 12)),
          pw.Text('Profile: $url', style: pw.TextStyle(fontSize: 12, color: PdfColors.orange)),
          pw.SizedBox(height: 24),

          // Footer
          pw.Divider(),
          pw.SizedBox(height: 8),
          pw.Text('Generated by ScoutMe • $url', style: pw.TextStyle(fontSize: 9, color: PdfColors.grey400)),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (_) => pdf.save(),
      name: '${playerName.replaceAll(' ', '_')}_ScoutMe_CV.pdf',
    );
  }

  static pw.Widget _pdfRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 120,
            child: pw.Text(label, style: pw.TextStyle(fontSize: 12, color: PdfColors.grey600)),
          ),
          pw.Text(value, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );
  }
}
