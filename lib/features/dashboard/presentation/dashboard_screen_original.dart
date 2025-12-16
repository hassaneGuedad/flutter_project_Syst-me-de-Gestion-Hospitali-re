/*
 * VERSION ORIGINALE DU DASHBOARD (BASIQUE)
 * Sauvegardée le 13/12/2024
 * 
 * Pour revenir à cette version, renommez ce fichier en dashboard_screen.dart
 * et renommez le nouveau fichier en dashboard_screen_improved.dart
 */

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../services/presentation/service_providers.dart';
import '../../patients/presentation/patient_providers.dart';
import '../../soins/presentation/soin_providers.dart';
import '../../auth/presentation/auth_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesListProvider);
    final patientsAsync = ref.watch(patientsListProvider);
    final soinsAsync = ref.watch(soinsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de Bord Financier'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authRepositoryProvider).logout();
              context.go('/login');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(servicesListProvider);
          ref.invalidate(patientsListProvider);
          ref.invalidate(soinsListProvider);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // KPIs Row
              servicesAsync.when(
                data: (services) => patientsAsync.when(
                  data: (patients) => soinsAsync.when(
                    data: (soins) => _buildKPIs(context, services, patients, soins),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Text('Erreur: $e'),
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text('Erreur: $e'),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Erreur: $e'),
              ),
              const SizedBox(height: 24),
              
              // Charts Section
              Text(
                'Analyse Financière',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              
              servicesAsync.when(
                data: (services) => Column(
                  children: [
                    _buildServiceCostsChart(context, services),
                    const SizedBox(height: 24),
                    _buildBudgetComparisonChart(context, services),
                  ],
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Erreur: $e'),
              ),
              
              const SizedBox(height: 24),
              
              // Quick Actions
              _buildQuickActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKPIs(BuildContext context, List services, List patients, List soins) {
    final totalBudget = services.fold<double>(0, (sum, s) => sum + s.budgetMensuel);
    final totalCost = services.fold<double>(0, (sum, s) => sum + s.coutActuel);
    final budgetRestant = totalBudget - totalCost;
    final tauxUtilisation = (totalCost / totalBudget * 100);

    return Row(
      children: [
        Expanded(
          child: _buildKPICard(
            context,
            'Budget Total',
            NumberFormat.currency(locale: 'fr_FR', symbol: '€').format(totalBudget),
            FontAwesomeIcons.euroSign,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildKPICard(
            context,
            'Coût Actuel',
            NumberFormat.currency(locale: 'fr_FR', symbol: '€').format(totalCost),
            FontAwesomeIcons.chartLine,
            Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildKPICard(
            context,
            'Budget Restant',
            NumberFormat.currency(locale: 'fr_FR', symbol: '€').format(budgetRestant),
            FontAwesomeIcons.piggyBank,
            budgetRestant > 0 ? Colors.green : Colors.red,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildKPICard(
            context,
            'Taux Utilisation',
            '${tauxUtilisation.toStringAsFixed(1)}%',
            FontAwesomeIcons.chartPie,
            tauxUtilisation > 90 ? Colors.red : Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildKPICard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FaIcon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCostsChart(BuildContext context, List services) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Coûts par Service',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: PieChart(
                PieChartData(
                  sections: services.asMap().entries.map((entry) {
                    final colors = [Colors.blue, Colors.orange, Colors.green, Colors.purple, Colors.red];
                    return PieChartSectionData(
                      value: entry.value.coutActuel,
                      title: '${(entry.value.coutActuel / services.fold<double>(0, (sum, s) => sum + s.coutActuel) * 100).toStringAsFixed(1)}%',
                      color: colors[entry.key % colors.length],
                      radius: 100,
                    );
                  }).toList(),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: services.asMap().entries.map((entry) {
                final colors = [Colors.blue, Colors.orange, Colors.green, Colors.purple, Colors.red];
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      color: colors[entry.key % colors.length],
                    ),
                    const SizedBox(width: 4),
                    Text(entry.value.nom),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetComparisonChart(BuildContext context, List services) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Budget vs Coût Actuel',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barGroups: services.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.budgetMensuel,
                          color: Colors.blue,
                          width: 15,
                        ),
                        BarChartRodData(
                          toY: entry.value.coutActuel,
                          color: Colors.orange,
                          width: 15,
                        ),
                      ],
                    );
                  }).toList(),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() < services.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                services[value.toInt()].nom,
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 16, height: 16, color: Colors.blue),
                const SizedBox(width: 4),
                const Text('Budget'),
                const SizedBox(width: 16),
                Container(width: 16, height: 16, color: Colors.orange),
                const SizedBox(width: 4),
                const Text('Coût Actuel'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Actions Rapides',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildActionButton(
                  context,
                  'Patients',
                  FontAwesomeIcons.userInjured,
                  Colors.blue,
                  () => context.go('/patients'),
                ),
                _buildActionButton(
                  context,
                  'Services',
                  FontAwesomeIcons.hospital,
                  Colors.green,
                  () => context.go('/services'),
                ),
                _buildActionButton(
                  context,
                  'Soins',
                  FontAwesomeIcons.heartPulse,
                  Colors.orange,
                  () => context.go('/soins'),
                ),
                _buildActionButton(
                  context,
                  'Rapports',
                  FontAwesomeIcons.fileLines,
                  Colors.purple,
                  () => context.go('/rapports'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, String label, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

