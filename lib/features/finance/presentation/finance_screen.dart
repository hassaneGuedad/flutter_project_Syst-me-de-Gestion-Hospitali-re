import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/export_service.dart';
import '../../../core/localization/app_localizations.dart';

class FinanceScreen extends ConsumerStatefulWidget {
  const FinanceScreen({super.key});

  @override
  ConsumerState<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends ConsumerState<FinanceScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'month';
  final currencyFormat = NumberFormat.currency(locale: 'fr_FR', symbol: '€');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SingleChildScrollView(
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
                    Text(ref.tr('finance'), style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(ref.tr('finance_overview'), style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
                Row(
                  children: [
                    _buildPeriodSelector(isDark),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: _exportFinances,
                      icon: const Icon(Icons.download),
                      label: Text(ref.tr('export')),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // KPIs
            _buildKPICards(isDark),
            const SizedBox(height: 24),

            // Tabs
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue.withOpacity(0.1),
                ),
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey[600],
                tabs: [
                  Tab(text: ref.tr('overview')),
                  Tab(text: ref.tr('revenue')),
                  Tab(text: ref.tr('expenses')),
                  Tab(text: ref.tr('budget')),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Tab Content - Fixed height container
            SizedBox(
              height: 600,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(isDark),
                  _buildRevenueTab(isDark),
                  _buildExpensesTab(isDark),
                  _buildBudgetTab(isDark),
                ],
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

  Widget _buildKPICards(bool isDark) {
    return Row(
      children: [
        Expanded(child: _buildKPICard(ref.tr('total_revenue'), 156780, '+12.5%', FontAwesomeIcons.arrowTrendUp, Colors.green, isDark)),
        const SizedBox(width: 16),
        Expanded(child: _buildKPICard(ref.tr('total_expenses'), 98450, '+3.2%', FontAwesomeIcons.arrowTrendDown, Colors.red, isDark)),
        const SizedBox(width: 16),
        Expanded(child: _buildKPICard(ref.tr('net_profit'), 58330, '+25.8%', FontAwesomeIcons.chartLine, Colors.blue, isDark)),
        const SizedBox(width: 16),
        Expanded(child: _buildKPICard(ref.tr('budget'), 45670, '68%', FontAwesomeIcons.wallet, Colors.purple, isDark)),
      ],
    );
  }

  Widget _buildKPICard(String title, double value, String change, IconData icon, Color color, bool isDark) {
    final isPercentage = change.endsWith('%') && !change.startsWith('+') && !change.startsWith('-');
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
                  color: (isPercentage ? Colors.blue : (isPositive ? Colors.green : Colors.red)).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  change,
                  style: TextStyle(
                    color: isPercentage ? Colors.blue : (isPositive ? Colors.green : Colors.red),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(currencyFormat.format(value), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.grey[900])),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(bool isDark) {
    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: _buildRevenueExpenseChart(isDark)),
          const SizedBox(width: 24),
          Expanded(child: _buildRecentTransactions(isDark)),
        ],
      ),
    );
  }

  Widget _buildRevenueExpenseChart(bool isDark) {
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
              Text(ref.tr('revenue_vs_expenses'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.grey[900])),
              Row(
                children: [
                  _buildLegendItem(ref.tr('revenue'), Colors.blue[400]!),
                  const SizedBox(width: 16),
                  _buildLegendItem(ref.tr('expenses'), Colors.orange[400]!),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 250,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 50,
                barGroups: List.generate(6, (index) {
                  final revenues = [35.0, 40.0, 32.0, 45.0, 38.0, 42.0];
                  final expenses = [20.0, 25.0, 22.0, 28.0, 24.0, 26.0];
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(toY: revenues[index], color: Colors.blue[400], width: 14, borderRadius: const BorderRadius.vertical(top: Radius.circular(6))),
                      BarChartRodData(toY: expenses[index], color: Colors.orange[400], width: 14, borderRadius: const BorderRadius.vertical(top: Radius.circular(6))),
                    ],
                  );
                }),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40, getTitlesWidget: (value, meta) => Text('${value.toInt()}k', style: TextStyle(color: Colors.grey[600], fontSize: 11)))),
                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, meta) {
                    final months = [ref.tr('month_jan'), ref.tr('month_feb'), ref.tr('month_mar'), ref.tr('month_apr'), ref.tr('month_may'), ref.tr('month_jun')];
                    return Padding(padding: const EdgeInsets.only(top: 8), child: Text(months[value.toInt()], style: TextStyle(color: Colors.grey[600], fontSize: 11)));
                  })),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1)),
                borderData: FlBorderData(show: false),
              ),
            ),
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
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }

  Widget _buildRecentTransactions(bool isDark) {
    final transactions = [
      {'desc': 'Consultation cardiologie', 'amount': 150.0, 'type': 'income'},
      {'desc': 'Fournitures médicales', 'amount': -450.0, 'type': 'expense'},
      {'desc': 'Analyse laboratoire', 'amount': 85.0, 'type': 'income'},
      {'desc': 'Maintenance équipements', 'amount': -1200.0, 'type': 'expense'},
      {'desc': 'Chirurgie ambulatoire', 'amount': 2500.0, 'type': 'income'},
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
          Text(ref.tr('recent_transactions'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.grey[900])),
          const SizedBox(height: 16),
          ...transactions.map((t) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (t['type'] == 'income' ? Colors.green : Colors.red).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: FaIcon(
                    t['type'] == 'income' ? FontAwesomeIcons.arrowUp : FontAwesomeIcons.arrowDown,
                    size: 14,
                    color: t['type'] == 'income' ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(t['desc'] as String, style: TextStyle(color: isDark ? Colors.white : Colors.grey[900], fontSize: 13))),
                Text(
                  currencyFormat.format(t['amount']),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: (t['amount'] as double) > 0 ? Colors.green : Colors.red,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildRevenueTab(bool isDark) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(flex: 2, child: _buildRevenueSourcesChart(isDark)),
              const SizedBox(width: 24),
              Expanded(child: _buildTopRevenueServices(isDark)),
            ],
          ),
          const SizedBox(height: 24),
          _buildRevenueTable(isDark),
        ],
      ),
    );
  }

  Widget _buildRevenueSourcesChart(bool isDark) {
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
          Text(ref.tr('revenue_sources'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.grey[900])),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: Row(
              children: [
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(value: 40, color: Colors.blue, title: '40%', radius: 50, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                        PieChartSectionData(value: 30, color: Colors.green, title: '30%', radius: 50, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                        PieChartSectionData(value: 20, color: Colors.orange, title: '20%', radius: 50, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                        PieChartSectionData(value: 10, color: Colors.purple, title: '10%', radius: 50, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                      centerSpaceRadius: 30,
                      sectionsSpace: 2,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPieLegend(ref.tr('consultations'), Colors.blue, '40%'),
                    _buildPieLegend(ref.tr('surgeries'), Colors.green, '30%'),
                    _buildPieLegend(ref.tr('analyses'), Colors.orange, '20%'),
                    _buildPieLegend(ref.tr('other'), Colors.purple, '10%'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieLegend(String label, Color color, String percentage) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: Colors.grey[600])),
          const SizedBox(width: 8),
          Text(percentage, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTopRevenueServices(bool isDark) {
    final services = [
      {'name': 'Cardiologie', 'revenue': 45000, 'growth': '+15%'},
      {'name': 'Chirurgie', 'revenue': 38000, 'growth': '+8%'},
      {'name': 'Pédiatrie', 'revenue': 28000, 'growth': '+12%'},
      {'name': 'Radiologie', 'revenue': 22000, 'growth': '+5%'},
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
          Text(ref.tr('top_services'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.grey[900])),
          const SizedBox(height: 16),
          ...services.map((s) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Expanded(child: Text(s['name'] as String, style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.grey[900]))),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(currencyFormat.format(s['revenue']), style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(s['growth'] as String, style: const TextStyle(color: Colors.green, fontSize: 12)),
                  ],
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildRevenueTable(bool isDark) {
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
              Text(ref.tr('revenue_details'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.grey[900])),
              ElevatedButton.icon(onPressed: _exportFinances, icon: const Icon(Icons.download, size: 16), label: Text(ref.tr('export'))),
            ],
          ),
          const SizedBox(height: 16),
          DataTable(
            columns: const [
              DataColumn(label: Text('Date')),
              DataColumn(label: Text('Description')),
              DataColumn(label: Text('Service')),
              DataColumn(label: Text('Montant')),
            ],
            rows: [
              _buildDataRow('14/12/2024', 'Consultation', 'Cardiologie', 150.0, isDark),
              _buildDataRow('14/12/2024', 'Chirurgie', 'Chirurgie', 2500.0, isDark),
              _buildDataRow('13/12/2024', 'Analyse', 'Laboratoire', 85.0, isDark),
              _buildDataRow('13/12/2024', 'Radiographie', 'Radiologie', 120.0, isDark),
              _buildDataRow('12/12/2024', 'Consultation', 'Pédiatrie', 80.0, isDark),
            ],
          ),
        ],
      ),
    );
  }

  DataRow _buildDataRow(String date, String desc, String service, double amount, bool isDark) {
    return DataRow(cells: [
      DataCell(Text(date)),
      DataCell(Text(desc)),
      DataCell(Text(service)),
      DataCell(Text(currencyFormat.format(amount), style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
    ]);
  }

  Widget _buildExpensesTab(bool isDark) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildExpensesByCategory(isDark)),
              const SizedBox(width: 24),
              Expanded(child: _buildExpensesTrend(isDark)),
            ],
          ),
          const SizedBox(height: 24),
          _buildExpensesTable(isDark),
        ],
      ),
    );
  }

  Widget _buildExpensesByCategory(bool isDark) {
    final categories = [
      {'name': 'Salaires', 'amount': 45000, 'percent': 45},
      {'name': 'Fournitures', 'amount': 25000, 'percent': 25},
      {'name': 'Maintenance', 'amount': 15000, 'percent': 15},
      {'name': 'Énergie', 'amount': 10000, 'percent': 10},
      {'name': 'Autres', 'amount': 5000, 'percent': 5},
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
          Text(ref.tr('expenses_by_category'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.grey[900])),
          const SizedBox(height: 20),
          ...categories.map((c) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(c['name'] as String, style: TextStyle(color: isDark ? Colors.white : Colors.grey[900])),
                    Text(currencyFormat.format(c['amount']), style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (c['percent'] as int) / 100,
                  backgroundColor: Colors.grey.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation(Colors.primaries[(categories.indexOf(c) * 3) % Colors.primaries.length]),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildExpensesTrend(bool isDark) {
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
          Text(ref.tr('expenses_trend'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.grey[900])),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true, drawVerticalLine: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, meta) {
                    final months = ['J', 'F', 'M', 'A', 'M', 'J'];
                    return Text(value.toInt() < months.length ? months[value.toInt()] : '', style: TextStyle(color: Colors.grey[600], fontSize: 11));
                  })),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [FlSpot(0, 15), FlSpot(1, 18), FlSpot(2, 16), FlSpot(3, 20), FlSpot(4, 22), FlSpot(5, 19)],
                    isCurved: true,
                    color: Colors.red,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(show: true, color: Colors.red.withOpacity(0.1)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpensesTable(bool isDark) {
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
          Text(ref.tr('recent_expenses'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.grey[900])),
          const SizedBox(height: 16),
          DataTable(
            columns: const [
              DataColumn(label: Text('Date')),
              DataColumn(label: Text('Description')),
              DataColumn(label: Text('Catégorie')),
              DataColumn(label: Text('Montant')),
            ],
            rows: [
              _buildExpenseRow('14/12/2024', 'Salaires Décembre', 'Salaires', 45000.0, isDark),
              _buildExpenseRow('13/12/2024', 'Consommables médicaux', 'Fournitures', 3500.0, isDark),
              _buildExpenseRow('12/12/2024', 'Réparation scanner', 'Maintenance', 1200.0, isDark),
              _buildExpenseRow('11/12/2024', 'Facture électricité', 'Énergie', 2800.0, isDark),
            ],
          ),
        ],
      ),
    );
  }

  DataRow _buildExpenseRow(String date, String desc, String category, double amount, bool isDark) {
    return DataRow(cells: [
      DataCell(Text(date)),
      DataCell(Text(desc)),
      DataCell(Text(category)),
      DataCell(Text('-${currencyFormat.format(amount)}', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
    ]);
  }

  Widget _buildBudgetTab(bool isDark) {
    final budgets = [
      {'service': 'Cardiologie', 'budget': 150000, 'used': 125340, 'percent': 84},
      {'service': 'Urgences', 'budget': 200000, 'used': 187650, 'percent': 94},
      {'service': 'Chirurgie', 'budget': 180000, 'used': 165890, 'percent': 92},
      {'service': 'Pédiatrie', 'budget': 120000, 'used': 98450, 'percent': 82},
      {'service': 'Radiologie', 'budget': 100000, 'used': 89230, 'percent': 89},
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          // Budget Overview Cards
          Row(
            children: [
              Expanded(child: _buildBudgetOverviewCard(ref.tr('total_budget'), 750000, Colors.blue, isDark)),
              const SizedBox(width: 16),
              Expanded(child: _buildBudgetOverviewCard(ref.tr('used'), 666560, Colors.orange, isDark)),
              const SizedBox(width: 16),
              Expanded(child: _buildBudgetOverviewCard(ref.tr('remaining'), 83440, Colors.green, isDark)),
              const SizedBox(width: 16),
              Expanded(child: _buildBudgetOverviewCard(ref.tr('usage_rate'), 0, Colors.purple, isDark, isPercent: true, percentValue: 89)),
            ],
          ),
          const SizedBox(height: 24),
          // Budget by Service
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ref.tr('budget_by_service'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.grey[900])),
                const SizedBox(height: 20),
                ...budgets.map((b) => _buildBudgetServiceRow(b, isDark)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetOverviewCard(String title, double value, Color color, bool isDark, {bool isPercent = false, int percentValue = 0}) {
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: FaIcon(FontAwesomeIcons.chartPie, color: color, size: 18),
          ),
          const SizedBox(height: 12),
          Text(
            isPercent ? '$percentValue%' : currencyFormat.format(value),
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.grey[900]),
          ),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildBudgetServiceRow(Map<String, dynamic> budget, bool isDark) {
    final percent = budget['percent'] as int;
    Color barColor = Colors.green;
    if (percent > 90) barColor = Colors.red;
    else if (percent > 75) barColor = Colors.orange;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(budget['service'] as String, style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.grey[900])),
              Text('${currencyFormat.format(budget['used'])} / ${currencyFormat.format(budget['budget'])}', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: percent / 100,
                    minHeight: 10,
                    backgroundColor: Colors.grey.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation(barColor),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text('$percent%', style: TextStyle(fontWeight: FontWeight.bold, color: barColor)),
            ],
          ),
        ],
      ),
    );
  }

  void _exportFinances() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(children: [const Icon(Icons.download, color: Colors.blue), const SizedBox(width: 8), Text(ref.tr('export_finances'))]),
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
      await ExportService.downloadFinancePDF();
      _showExportSuccess('PDF');
    } catch (e) {
      _showExportError('PDF');
    }
  }

  void _exportExcel() {
    try {
      ExportService.downloadFinanceExcel();
      _showExportSuccess('Excel');
    } catch (e) {
      _showExportError('Excel');
    }
  }

  void _exportCSV() {
    try {
      ExportService.downloadFinanceCSV();
      _showExportSuccess('CSV');
    } catch (e) {
      _showExportError('CSV');
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
}
