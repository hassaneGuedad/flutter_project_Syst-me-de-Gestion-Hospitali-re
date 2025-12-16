import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../services/presentation/service_providers.dart';
import '../../patients/presentation/patient_providers.dart';
import '../../soins/presentation/soin_providers.dart';
import '../../services/domain/service.dart';
import '../../patients/domain/patient.dart';
import '../../soins/domain/soin.dart';
import '../../../core/localization/app_localizations.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesListProvider);
    final patientsAsync = ref.watch(patientsListProvider);
    final soinsAsync = ref.watch(soinsListProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = ref.watch(languageProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(servicesListProvider);
          ref.invalidate(patientsListProvider);
          ref.invalidate(soinsListProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, ref),
              const SizedBox(height: 24),
              servicesAsync.when(
                data: (services) => patientsAsync.when(
                  data: (patients) => soinsAsync.when(
                    data: (soins) => _buildContent(context, ref, services, patients, soins, isDark),
                    loading: () => _buildLoading(ref),
                    error: (e, _) => _buildError('${ref.tr('error')}: $e'),
                  ),
                  loading: () => _buildLoading(ref),
                  error: (e, _) => _buildError('${ref.tr('error')}: $e'),
                ),
                loading: () => _buildLoading(ref),
                error: (e, _) => _buildError('${ref.tr('error')}: $e'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    final hour = DateTime.now().hour;
    final lang = ref.watch(languageProvider);
    
    String greeting;
    String dateLocale;
    
    if (lang == 'English') {
      greeting = hour < 12 ? 'Good morning' : (hour < 18 ? 'Good afternoon' : 'Good evening');
      dateLocale = 'en';
    } else if (lang == 'العربية') {
      greeting = hour < 12 ? 'صباح الخير' : (hour < 18 ? 'مساء الخير' : 'مساء الخير');
      dateLocale = 'ar';
    } else {
      greeting = hour < 12 ? 'Bonjour' : (hour < 18 ? 'Bon après-midi' : 'Bonsoir');
      dateLocale = 'fr';
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[700]!, Colors.purple[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$greeting 👋',
                style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                DateFormat('EEEE d MMMM yyyy', dateLocale).format(DateTime.now()),
                style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 16),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const FaIcon(FontAwesomeIcons.hospital, color: Colors.white, size: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, List<Service> services, List<Patient> patients, List<Soin> soins, bool isDark) {
    final totalSoins = soins.fold(0.0, (sum, s) => sum + s.cout);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // KPI Cards
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.4,
          children: [
            _buildKPICard(context, ref.tr('patients'), '${patients.length}', FontAwesomeIcons.userInjured, Colors.blue, '+12%', isDark),
            _buildKPICard(context, ref.tr('services'), '${services.length}', FontAwesomeIcons.hospital, Colors.green, ref.tr('active'), isDark),
            _buildKPICard(context, ref.tr('care'), '${soins.length}', FontAwesomeIcons.heartPulse, Colors.orange, '+5%', isDark),
            _buildKPICard(context, ref.tr('monthly_revenue'), NumberFormat.compactCurrency(locale: 'fr', symbol: '€').format(totalSoins), FontAwesomeIcons.euroSign, Colors.purple, '+8%', isDark),
          ],
        ),
        const SizedBox(height: 24),

        // Charts Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: _buildServiceChart(context, ref, services, isDark)),
            const SizedBox(width: 24),
            Expanded(child: _buildRecentSoins(context, ref, soins, isDark)),
          ],
        ),
        const SizedBox(height: 24),

        // Quick Actions
        _buildQuickActions(context, ref, isDark),
      ],
    );
  }

  Widget _buildKPICard(BuildContext context, String title, String value, IconData icon, Color color, String trend, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: FaIcon(icon, color: color, size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(trend, style: const TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.grey[900])),
              Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceChart(BuildContext context, WidgetRef ref, List<Service> services, bool isDark) {
    final lang = ref.watch(languageProvider);
    final budgetLabel = lang == 'English' ? 'Budget' : (lang == 'العربية' ? 'الميزانية' : 'Budget');
    final costLabel = lang == 'English' ? 'Current Cost' : (lang == 'العربية' ? 'التكلفة الحالية' : 'Coût actuel');
    final chartTitle = lang == 'English' ? 'Budget by Service' : (lang == 'العربية' ? 'الميزانية حسب الخدمة' : 'Budget par Service');
    final noService = lang == 'English' ? 'No service' : (lang == 'العربية' ? 'لا توجد خدمة' : 'Aucun service');

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(chartTitle, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.grey[900])),
          const SizedBox(height: 24),
          SizedBox(
            height: 250,
            child: services.isEmpty
                ? Center(child: Text(noService))
                : BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: services.map((s) => s.budgetMensuel).reduce((a, b) => a > b ? a : b) * 1.2,
                      barTouchData: BarTouchData(enabled: true),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() < services.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(services[value.toInt()].nom.length > 5 ? services[value.toInt()].nom.substring(0, 5) : services[value.toInt()].nom, style: TextStyle(color: Colors.grey[600], fontSize: 10)),
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 50,
                            getTitlesWidget: (value, meta) => Text(NumberFormat.compact(locale: 'fr').format(value), style: TextStyle(color: Colors.grey[600], fontSize: 10)),
                          ),
                        ),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1)),
                      borderData: FlBorderData(show: false),
                      barGroups: services.asMap().entries.map((entry) {
                        return BarChartGroupData(
                          x: entry.key,
                          barRods: [
                            BarChartRodData(toY: entry.value.budgetMensuel, color: Colors.blue[400], width: 16, borderRadius: const BorderRadius.vertical(top: Radius.circular(6))),
                            BarChartRodData(toY: entry.value.coutActuel, color: Colors.orange[400], width: 16, borderRadius: const BorderRadius.vertical(top: Radius.circular(6))),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(budgetLabel, Colors.blue[400]!),
              const SizedBox(width: 24),
              _buildLegendItem(costLabel, Colors.orange[400]!),
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
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }

  Widget _buildRecentSoins(BuildContext context, WidgetRef ref, List<Soin> soins, bool isDark) {
    final recentSoins = soins.take(5).toList();
    final lang = ref.watch(languageProvider);
    final title = lang == 'English' ? 'Recent Care' : (lang == 'العربية' ? 'الرعاية الأخيرة' : 'Soins Récents');
    final noData = lang == 'English' ? 'No recent care' : (lang == 'العربية' ? 'لا توجد رعاية حديثة' : 'Aucun soin récent');

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.grey[900])),
          const SizedBox(height: 16),
          if (recentSoins.isEmpty)
            Center(child: Text(noData))
          else
            ...recentSoins.map((soin) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                        child: const FaIcon(FontAwesomeIcons.heartPulse, size: 16, color: Colors.blue),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(soin.typeSoin, style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.grey[900])),
                            Text(DateFormat('dd/MM/yyyy').format(soin.dateSoin), style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                          ],
                        ),
                      ),
                      Text('${soin.cout.toStringAsFixed(0)} €', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                    ],
                  ),
                )),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, WidgetRef ref, bool isDark) {
    final lang = ref.watch(languageProvider);
    final title = lang == 'English' ? 'Quick Actions' : (lang == 'العربية' ? 'إجراءات سريعة' : 'Actions Rapides');
    final newPatient = lang == 'English' ? 'New Patient' : (lang == 'العربية' ? 'مريض جديد' : 'Nouveau Patient');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.grey[900])),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 2.5,
          children: [
            _buildActionButton(context, newPatient, FontAwesomeIcons.userPlus, Colors.blue, () => context.go('/patients/new')),
            _buildActionButton(context, ref.tr('appointments'), FontAwesomeIcons.calendarPlus, Colors.green, () => context.go('/rendez-vous')),
            _buildActionButton(context, ref.tr('reports'), FontAwesomeIcons.fileLines, Colors.purple, () => context.go('/rapports')),
            _buildActionButton(context, ref.tr('finance'), FontAwesomeIcons.euroSign, Colors.orange, () => context.go('/finance')),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, String label, IconData icon, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [color, color.withOpacity(0.8)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 12),
              Flexible(child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoading(WidgetRef ref) {
    return Center(child: Padding(padding: const EdgeInsets.all(50), child: Column(
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 16),
        Text(ref.tr('loading')),
      ],
    )));
  }

  Widget _buildError(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.red[200]!)),
      child: Row(children: [Icon(Icons.error_outline, color: Colors.red[700]), const SizedBox(width: 12), Expanded(child: Text(message, style: TextStyle(color: Colors.red[700])))]),
    );
  }
}

