import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/export_service.dart';
import '../../../core/localization/app_localizations.dart';

class RapportsScreen extends ConsumerStatefulWidget {
  const RapportsScreen({super.key});

  @override
  ConsumerState<RapportsScreen> createState() => _RapportsScreenState();
}

class _RapportsScreenState extends ConsumerState<RapportsScreen> {
  String _selectedPeriod = 'month';
  String _selectedType = 'all';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ref.tr('reports'), style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(ref.tr('reports_title'), style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
                Row(
                  children: [
                    _buildPeriodSelector(isDark),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: _generateReport,
                      icon: const Icon(Icons.download),
                      label: Text(ref.tr('export')),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Filter tabs
            _buildFilterTabs(isDark),
            const SizedBox(height: 24),

            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // KPI Cards
                    _buildKPIRow(isDark),
                    const SizedBox(height: 24),

                    // Charts row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 2, child: _buildMainChart(isDark)),
                        const SizedBox(width: 24),
                        Expanded(child: _buildDistributionChart(isDark)),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Reports list
                    _buildReportsList(isDark),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector(bool isDark) {
    final periods = {
      'week': ref.tr('week'),
      'month': ref.tr('month'),
      'year': ref.tr('year'),
    };
    
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: periods.entries.map((entry) {
          final isSelected = _selectedPeriod == entry.key;
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => setState(() => _selectedPeriod = entry.key),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  entry.value,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[700],
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFilterTabs(bool isDark) {
    final types = {
      'all': ref.tr('all'),
      'patients': ref.tr('patients'),
      'finance': ref.tr('finance'),
      'services': ref.tr('services'),
      'care': ref.tr('care'),
    };
    
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Row(
        children: types.entries.map((entry) {
          final isSelected = _selectedType == entry.key;
          return Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => setState(() => _selectedType = entry.key),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: isSelected ? Border.all(color: Colors.blue.withOpacity(0.5)) : null,
                  ),
                  child: Text(
                    entry.value,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected ? Colors.blue : Colors.grey[600],
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildKPIRow(bool isDark) {
    return Row(
      children: [
        Expanded(child: _buildKPICard(ref.tr('patients_treated'), '1,234', '+12%', FontAwesomeIcons.userGroup, Colors.blue, isDark)),
        const SizedBox(width: 16),
        Expanded(child: _buildKPICard(ref.tr('revenue_label'), '56,780 €', '+8%', FontAwesomeIcons.euroSign, Colors.green, isDark)),
        const SizedBox(width: 16),
        Expanded(child: _buildKPICard(ref.tr('consultations_label'), '856', '+15%', FontAwesomeIcons.stethoscope, Colors.purple, isDark)),
        const SizedBox(width: 16),
        Expanded(child: _buildKPICard(ref.tr('occupation_rate'), '78%', '+5%', FontAwesomeIcons.bed, Colors.orange, isDark)),
      ],
    );
  }

  Widget _buildKPICard(String title, String value, String change, IconData icon, Color color, bool isDark) {
    final isPositive = change.startsWith('+');
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: FaIcon(icon, color: color, size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (isPositive ? Colors.green : Colors.red).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(change, style: TextStyle(color: isPositive ? Colors.green : Colors.red, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.grey[900])),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildMainChart(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(ref.tr('monthly_evolution'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.grey[900])),
          const SizedBox(height: 24),
          SizedBox(
            height: 300,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true, horizontalInterval: 20, verticalInterval: 1, getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1)),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40, getTitlesWidget: (value, meta) => Text('${value.toInt()}', style: TextStyle(color: Colors.grey[600], fontSize: 12)))),
                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30, getTitlesWidget: (value, meta) {
                    final months = [ref.tr('month_jan'), ref.tr('month_feb'), ref.tr('month_mar'), ref.tr('month_apr'), ref.tr('month_may'), ref.tr('month_jun')];
                    return Text(value.toInt() < months.length ? months[value.toInt()] : '', style: TextStyle(color: Colors.grey[600], fontSize: 12));
                  })),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [FlSpot(0, 40), FlSpot(1, 55), FlSpot(2, 45), FlSpot(3, 70), FlSpot(4, 65), FlSpot(5, 85)],
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.1)),
                  ),
                  LineChartBarData(
                    spots: const [FlSpot(0, 30), FlSpot(1, 45), FlSpot(2, 35), FlSpot(3, 50), FlSpot(4, 55), FlSpot(5, 60)],
                    isCurved: true,
                    color: Colors.green,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(show: true, color: Colors.green.withOpacity(0.1)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(ref.tr('patients_chart'), Colors.blue),
              const SizedBox(width: 24),
              _buildLegendItem(ref.tr('revenue_chart'), Colors.green),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildDistributionChart(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(ref.tr('distribution_by_service'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.grey[900])),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(value: 35, color: Colors.blue, title: '35%', titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                  PieChartSectionData(value: 25, color: Colors.green, title: '25%', titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                  PieChartSectionData(value: 20, color: Colors.orange, title: '20%', titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                  PieChartSectionData(value: 20, color: Colors.purple, title: '20%', titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                ],
                centerSpaceRadius: 40,
                sectionsSpace: 2,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildPieChartLegend(ref.tr('cardiology'), Colors.blue),
          _buildPieChartLegend(ref.tr('pediatrics'), Colors.green),
          _buildPieChartLegend(ref.tr('emergency'), Colors.orange),
          _buildPieChartLegend(ref.tr('other'), Colors.purple),
        ],
      ),
    );
  }

  Widget _buildPieChartLegend(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildReportsList(bool isDark) {
    final reports = [
      {'title': 'Rapport mensuel - Juin 2024', 'type': 'Général', 'date': '01/07/2024', 'icon': FontAwesomeIcons.fileLines},
      {'title': 'Analyse financière Q2', 'type': 'Finances', 'date': '28/06/2024', 'icon': FontAwesomeIcons.chartPie},
      {'title': 'Statistiques patients', 'type': 'Patients', 'date': '25/06/2024', 'icon': FontAwesomeIcons.userGroup},
      {'title': 'Performance services', 'type': 'Services', 'date': '20/06/2024', 'icon': FontAwesomeIcons.hospital},
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(ref.tr('recent_reports'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.grey[900])),
              TextButton(onPressed: () {}, child: Text(ref.tr('see_all'))),
            ],
          ),
          const SizedBox(height: 16),
          ...reports.map((report) => _buildReportItem(report, isDark)),
        ],
      ),
    );
  }

  Widget _buildReportItem(Map<String, dynamic> report, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: FaIcon(report['icon'] as IconData, color: Colors.blue, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(report['title'] as String, style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.grey[900])),
                const SizedBox(height: 4),
                Text('${report['type']} • ${report['date']}', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
              ],
            ),
          ),
          IconButton(icon: const Icon(Icons.download, color: Colors.blue), onPressed: () => _downloadReport(report['title'] as String)),
          IconButton(icon: const Icon(Icons.visibility, color: Colors.grey), onPressed: () => _viewReport(report['title'] as String, isDark)),
        ],
      ),
    );
  }

  void _generateReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(children: [const Icon(Icons.download, color: Colors.blue), const SizedBox(width: 8), Text(ref.tr('export_reports'))]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
              title: Text(ref.tr('export_pdf')),
              subtitle: Text(ref.tr('complete_report_with_charts')),
              onTap: () { Navigator.pop(context); _exportPDF(); },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart, color: Colors.green),
              title: Text(ref.tr('export_excel')),
              subtitle: Text(ref.tr('detailed_data_table')),
              onTap: () { Navigator.pop(context); _exportExcel(); },
            ),
            ListTile(
              leading: const Icon(Icons.code, color: Colors.blue),
              title: Text(ref.tr('export_csv')),
              subtitle: Text(ref.tr('compatible_format')),
              onTap: () { Navigator.pop(context); _exportCSV(); },
            ),
            ListTile(
              leading: const Icon(Icons.print, color: Colors.purple),
              title: Text(ref.tr('print_report')),
              subtitle: Text(ref.tr('print_directly')),
              onTap: () { Navigator.pop(context); _printReport(); },
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(ref.tr('cancel'))),
        ],
      ),
    );
  }

  void _exportPDF() async {
    try {
      await ExportService.downloadRapportPDF('Rapport Général - Hôpital');
      _showExportSuccess('PDF');
    } catch (e) {
      _showExportError('PDF');
    }
  }

  void _exportExcel() {
    try {
      ExportService.downloadRapportCSV('Rapport Général');
      _showExportSuccess('Excel');
    } catch (e) {
      _showExportError('Excel');
    }
  }

  void _exportCSV() {
    try {
      ExportService.downloadRapportCSV('Rapport Général');
      _showExportSuccess('CSV');
    } catch (e) {
      _showExportError('CSV');
    }
  }

  void _printReport() async {
    try {
      await ExportService.downloadRapportPDF('Rapport à imprimer');
      _showExportSuccess('Impression');
    } catch (e) {
      _showExportError('Impression');
    }
  }

  void _showExportSuccess(String format) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text(ref.tr('export_downloaded_success').replaceAll('{format}', format)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showExportError(String format) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 12),
            Text(ref.tr('export_error_format').replaceAll('{format}', format)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _downloadReport(String reportTitle) async {
    try {
      await ExportService.downloadRapportPDF(reportTitle);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Text(ref.tr('report_downloaded').replaceAll('{title}', reportTitle)),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 12),
              Text(ref.tr('report_download_error').replaceAll('{title}', reportTitle)),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _viewReport(String reportTitle, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: 800,
          height: 600,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(reportTitle, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const Divider(),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildReportSection(ref.tr('executive_summary'), ref.tr('executive_summary_text')),
                      const SizedBox(height: 24),
                      _buildReportSection(ref.tr('main_statistics'), ref.tr('main_statistics_text')),
                      const SizedBox(height: 24),
                      _buildReportSection(ref.tr('financial_performance'), ref.tr('financial_performance_text')),
                      const SizedBox(height: 24),
                      _buildReportSection(ref.tr('recommendations'), ref.tr('recommendations_text')),
                    ],
                  ),
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.pop(context), child: Text(ref.tr('close'))),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () { Navigator.pop(context); _downloadReport(reportTitle); },
                    icon: const Icon(Icons.download),
                    label: Text(ref.tr('download')),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
        const SizedBox(height: 8),
        Text(content, style: TextStyle(color: Colors.grey[700], height: 1.6)),
      ],
    );
  }
}
