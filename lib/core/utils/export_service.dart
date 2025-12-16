import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/html.dart' as html;

class ExportService {
  // Télécharger un fichier CSV
  static void downloadCSV(String filename, List<List<String>> data) {
    final csvContent = data.map((row) => row.map((cell) => '"$cell"').join(',')).join('\n');
    final bytes = utf8.encode('\uFEFF$csvContent'); // BOM for Excel UTF-8
    _triggerDownload(filename, bytes, 'text/csv;charset=utf-8');
  }

  // Télécharger un fichier PDF
  static Future<void> downloadPDF(String filename, String title, List<Map<String, dynamic>> sections) async {
    final pdf = pw.Document();
    
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text(title, style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          ),
          pw.SizedBox(height: 20),
          pw.Text('Date: ${DateTime.now().toString().substring(0, 10)}', style: const pw.TextStyle(fontSize: 12)),
          pw.SizedBox(height: 30),
          ...sections.map((section) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(section['title'] as String, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.blue)),
              pw.SizedBox(height: 10),
              pw.Text(section['content'] as String, style: const pw.TextStyle(fontSize: 12)),
              pw.SizedBox(height: 20),
            ],
          )),
        ],
      ),
    );
    
    final bytes = await pdf.save();
    _triggerDownload(filename, bytes, 'application/pdf');
  }

  // Télécharger données financières en CSV
  static void downloadFinanceCSV() {
    final data = [
      ['Catégorie', 'Montant (€)', 'Variation', 'Date'],
      ['Revenus Totaux', '56780', '+12%', '${DateTime.now().toString().substring(0, 10)}'],
      ['Dépenses Totales', '42300', '+5%', '${DateTime.now().toString().substring(0, 10)}'],
      ['Bénéfice Net', '14480', '+8%', '${DateTime.now().toString().substring(0, 10)}'],
      ['Consultations', '25000', '+15%', '${DateTime.now().toString().substring(0, 10)}'],
      ['Hospitalisations', '18000', '+10%', '${DateTime.now().toString().substring(0, 10)}'],
      ['Laboratoire', '8500', '+7%', '${DateTime.now().toString().substring(0, 10)}'],
      ['Pharmacie', '5280', '+3%', '${DateTime.now().toString().substring(0, 10)}'],
    ];
    downloadCSV('finances_${DateTime.now().millisecondsSinceEpoch}.csv', data);
  }

  // Télécharger données financières en PDF
  static Future<void> downloadFinancePDF() async {
    await downloadPDF(
      'rapport_finances_${DateTime.now().millisecondsSinceEpoch}.pdf',
      'Rapport Financier - Hôpital',
      [
        {'title': 'Résumé Financier', 'content': 'Ce rapport présente les données financières de l\'établissement hospitalier pour la période en cours.'},
        {'title': 'Revenus', 'content': '• Revenus Totaux: 56,780 €\n• Consultations: 25,000 €\n• Hospitalisations: 18,000 €\n• Laboratoire: 8,500 €\n• Pharmacie: 5,280 €'},
        {'title': 'Dépenses', 'content': '• Dépenses Totales: 42,300 €\n• Salaires: 28,000 €\n• Fournitures: 8,500 €\n• Maintenance: 3,200 €\n• Autres: 2,600 €'},
        {'title': 'Bilan', 'content': '• Bénéfice Net: 14,480 €\n• Marge Bénéficiaire: 25.5%\n• Croissance vs période précédente: +8%'},
      ],
    );
  }

  // Télécharger données financières en Excel (CSV compatible)
  static void downloadFinanceExcel() {
    final data = [
      ['Rapport Financier - Hôpital'],
      ['Date', DateTime.now().toString().substring(0, 10)],
      [''],
      ['REVENUS'],
      ['Catégorie', 'Montant (€)', 'Variation'],
      ['Consultations', '25000', '+15%'],
      ['Hospitalisations', '18000', '+10%'],
      ['Laboratoire', '8500', '+7%'],
      ['Pharmacie', '5280', '+3%'],
      ['Total Revenus', '56780', '+12%'],
      [''],
      ['DÉPENSES'],
      ['Catégorie', 'Montant (€)', 'Variation'],
      ['Salaires', '28000', '+5%'],
      ['Fournitures', '8500', '+8%'],
      ['Maintenance', '3200', '+2%'],
      ['Autres', '2600', '+4%'],
      ['Total Dépenses', '42300', '+5%'],
      [''],
      ['BILAN'],
      ['Bénéfice Net', '14480', '+8%'],
      ['Marge', '25.5%', ''],
    ];
    downloadCSV('finances_excel_${DateTime.now().millisecondsSinceEpoch}.csv', data);
  }

  // Télécharger rapport en CSV
  static void downloadRapportCSV(String reportTitle) {
    final data = [
      ['Rapport', reportTitle],
      ['Date', DateTime.now().toString().substring(0, 10)],
      [''],
      ['STATISTIQUES PRINCIPALES'],
      ['Indicateur', 'Valeur'],
      ['Patients traités', '1234'],
      ['Taux d\'occupation', '78%'],
      ['Durée moyenne de séjour', '4.2 jours'],
      ['Taux de satisfaction', '92%'],
      [''],
      ['PERFORMANCES FINANCIÈRES'],
      ['Revenus totaux', '56780 €'],
      ['Coûts opérationnels', '42300 €'],
      ['Marge bénéficiaire', '25.5%'],
      ['Croissance', '+8%'],
    ];
    downloadCSV('rapport_${DateTime.now().millisecondsSinceEpoch}.csv', data);
  }

  // Télécharger rapport en PDF
  static Future<void> downloadRapportPDF(String reportTitle) async {
    await downloadPDF(
      'rapport_${DateTime.now().millisecondsSinceEpoch}.pdf',
      reportTitle,
      [
        {'title': 'Résumé Exécutif', 'content': 'Ce rapport présente une analyse complète des activités hospitalières pour la période sélectionnée. Les indicateurs clés montrent une amélioration de 12% des performances globales.'},
        {'title': 'Statistiques Principales', 'content': '• Nombre de patients traités: 1,234\n• Taux d\'occupation: 78%\n• Durée moyenne de séjour: 4.2 jours\n• Taux de satisfaction: 92%'},
        {'title': 'Performances Financières', 'content': '• Revenus totaux: 56,780 €\n• Coûts opérationnels: 42,300 €\n• Marge bénéficiaire: 25.5%\n• Croissance vs période précédente: +8%'},
        {'title': 'Recommandations', 'content': '1. Optimiser le taux d\'occupation des lits\n2. Réduire les temps d\'attente aux urgences\n3. Améliorer le suivi post-consultation\n4. Investir dans les équipements de diagnostic'},
      ],
    );
  }

  // Méthode pour déclencher le téléchargement (Web uniquement)
  static void _triggerDownload(String filename, List<int> bytes, String mimeType) {
    if (kIsWeb) {
      try {
        // Créer le blob
        final blob = html.Blob([Uint8List.fromList(bytes)], mimeType);
        
        // Créer l'URL du blob
        final url = html.Url.createObjectUrlFromBlob(blob);
        
        // Créer un élément anchor pour le téléchargement
        final anchor = html.AnchorElement()
          ..href = url
          ..download = filename
          ..style.display = 'none';
        
        // Ajouter au document, cliquer et supprimer
        html.document.body?.append(anchor);
        anchor.click();
        
        // Nettoyer après un court délai
        Future.delayed(const Duration(milliseconds: 100), () {
          anchor.remove();
          html.Url.revokeObjectUrl(url);
        });
      } catch (e) {
        debugPrint('Erreur téléchargement: $e');
        rethrow;
      }
    }
  }
}
