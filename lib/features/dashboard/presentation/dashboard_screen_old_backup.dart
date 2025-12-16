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
import '../../services/domain/service.dart';
import '../../patients/domain/patient.dart';
import '../../soins/domain/soin.dart';

/*
 * VERSION ORIGINALE (BASIQUE) - SAUVEGARDÉE
 * Cette version améliorée remplace la version basique avec :
 * - Design moderne avec gradients et animations
 * - Plus de métriques (patients, soins, tendances)
 * - Graphiques améliorés (ligne de temps, tendances)
 * - Layout responsive en grille
 * - Indicateurs de performance
 * - Sections mieux organisées
 */

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final servicesAsync = ref.watch(servicesListProvider);
    final patientsAsync = ref.watch(patientsListProvider);
    final soinsAsync = ref.watch(soinsListProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(servicesListProvider);
          ref.invalidate(patientsListProvider);
          ref.invalidate(soinsListProvider);
        },
        child: CustomScrollView(
          slivers: [
            // AppBar avec header amélioré
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              backgroundColor: theme.colorScheme.primary,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Tableau de Bord',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.primary.withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getGreeting(),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('EEEE d MMMM yyyy', 'fr_FR').format(DateTime.now()),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  onPressed: () {
                    ref.read(authRepositoryProvider).logout();
                    context.go('/login');
                  },
                ),
              ],
            ),

            // Contenu principal
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // KPIs Principaux
                    servicesAsync.when(
                      data: (services) => patientsAsync.when(
                        data: (patients) => soinsAsync.when(
                          data: (soins) => _buildMainKPIs(
                            context,
                            services,
                            patients,
                            soins,
                          ),
                          loading: () => _buildLoadingKPIs(),
                          error: (e, _) => _buildErrorWidget('Erreur: $e'),
                        ),
                        loading: () => _buildLoadingKPIs(),
                        error: (e, _) => _buildErrorWidget('Erreur: $e'),
                      ),
                      loading: () => _buildLoadingKPIs(),
                      error: (e, _) => _buildErrorWidget('Erreur: $e'),
                    ),

                    const SizedBox(height: 24),

                    // Statistiques secondaires
                    servicesAsync.when(
                      data: (services) => patientsAsync.when(
                        data: (patients) => soinsAsync.when(
                          data: (soins) => _buildSecondaryStats(
                            context,
                            services,
                            patients,
                            soins,
                          ),
                          loading: () => const SizedBox(),
                          error: (_, __) => const SizedBox(),
                        ),
                        loading: () => const SizedBox(),
                        error: (_, __) => const SizedBox(),
                      ),
                      loading: () => const SizedBox(),
                      error: (_, __) => const SizedBox(),
                    ),

                    const SizedBox(height: 24),

                    // Section Graphiques
                    Text(
                      'Analyse Financière',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    servicesAsync.when(
                      data: (services) => patientsAsync.when(
                        data: (patients) => soinsAsync.when(
                          data: (soins) => Column(
                            children: [
                              _buildServiceCostsChart(context, services),
                              const SizedBox(height: 24),
                              _buildBudgetComparisonChart(context, services),
                              const SizedBox(height: 24),
                              _buildSoinsTimelineChart(context, soins),
                            ],
                          ),
                          loading: () => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          error: (e, _) => _buildErrorWidget('Erreur: $e'),
                        ),
                        loading: () => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        error: (e, _) => _buildErrorWidget('Erreur: $e'),
                      ),
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      error: (e, _) => _buildErrorWidget('Erreur: $e'),
                    ),

                    const SizedBox(height: 24),

                    // Actions Rapides
                    _buildQuickActions(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Bonjour';
    if (hour < 18) return 'Bon après-midi';
    return 'Bonsoir';
  }

  Widget _buildLoadingKPIs() {
    return Row(
      children: List.generate(4, (index) => Expanded(
        child: Card(
          child: Container(
            height: 120,
            padding: const EdgeInsets.all(16),
            child: const Center(child: CircularProgressIndicator()),
          ),
        ),
      )),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Card(
      color: Colors.red[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red[700]),
            const SizedBox(width: 8),
            Expanded(child: Text(message, style: TextStyle(color: Colors.red[700]))),
          ],
        ),
      ),
    );
  }

  Widget _buildMainKPIs(
    BuildContext context,
    List<Service> services,
    List<Patient> patients,
    List<Soin> soins,
  ) {
    final totalBudget = services.fold<double>(0, (sum, s) => sum + s.budgetMensuel);
    final totalCost = services.fold<double>(0, (sum, s) => sum + s.coutActuel);
    final budgetRestant = totalBudget - totalCost;
    final tauxUtilisation = totalBudget > 0 ? (totalCost / totalBudget * 100) : 0;
    final totalSoins = soins.length;
    final totalPatients = patients.length;
    final coutTotalSoins = soins.fold<double>(0, (sum, s) => sum + s.cout);

    return FadeTransition(
      opacity: _animationController,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildModernKPICard(
                  context,
                  'Budget Total',
                  NumberFormat.currency(locale: 'fr_FR', symbol: '€').format(totalBudget),
                  FontAwesomeIcons.euroSign,
                  [Colors.blue, Colors.blueAccent],
                  Icons.trending_up,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildModernKPICard(
                  context,
                  'Coût Actuel',
                  NumberFormat.currency(locale: 'fr_FR', symbol: '€').format(totalCost),
                  FontAwesomeIcons.chartLine,
                  [Colors.orange, Colors.deepOrange],
                  Icons.trending_up,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildModernKPICard(
                  context,
                  'Budget Restant',
                  NumberFormat.currency(locale: 'fr_FR', symbol: '€').format(budgetRestant),
                  FontAwesomeIcons.piggyBank,
                  budgetRestant > 0
                      ? [Colors.green, Colors.greenAccent]
                      : [Colors.red, Colors.redAccent],
                  budgetRestant > 0 ? Icons.trending_down : Icons.warning,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildModernKPICard(
                  context,
                  'Taux Utilisation',
                  '${tauxUtilisation.toStringAsFixed(1)}%',
                  FontAwesomeIcons.chartPie,
                  tauxUtilisation > 90
                      ? [Colors.red, Colors.redAccent]
                      : [Colors.green, Colors.greenAccent],
                  tauxUtilisation > 90 ? Icons.warning : Icons.check_circle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModernKPICard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    List<Color> gradientColors,
    IconData? trendIcon,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: FaIcon(icon, color: Colors.white, size: 20),
                ),
                if (trendIcon != null)
                  Icon(trendIcon, color: Colors.white.withOpacity(0.8), size: 18),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryStats(
    BuildContext context,
    List<Service> services,
    List<Patient> patients,
    List<Soin> soins,
  ) {
    final totalSoins = soins.length;
    final totalPatients = patients.length;
    final coutTotalSoins = soins.fold<double>(0, (sum, s) => sum + s.cout);
    final soinsCeMois = soins.where((s) {
      final now = DateTime.now();
      return s.dateSoin.year == now.year && s.dateSoin.month == now.month;
    }).length;
    final moyenneCoutSoin = totalSoins > 0 ? coutTotalSoins / totalSoins : 0.0;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            'Total Patients',
            totalPatients.toString(),
            FontAwesomeIcons.userInjured,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            'Total Soins',
            totalSoins.toString(),
            FontAwesomeIcons.heartPulse,
            Colors.pink,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            'Soins ce Mois',
            soinsCeMois.toString(),
            FontAwesomeIcons.calendar,
            Colors.purple,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            'Coût Moyen',
            NumberFormat.currency(locale: 'fr_FR', symbol: '€').format(moyenneCoutSoin),
            FontAwesomeIcons.coins,
            Colors.amber,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: FaIcon(icon, color: color, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 4),
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

  Widget _buildServiceCostsChart(BuildContext context, List<Service> services) {
    if (services.isEmpty) return const SizedBox();

    final totalCost = services.fold<double>(0, (sum, s) => sum + s.coutActuel);
    final colors = [
      Colors.blue,
      Colors.orange,
      Colors.green,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.indigo,
    ];

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Répartition des Coûts par Service',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${services.length} services',
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 280,
                    child: PieChart(
                      PieChartData(
                        sections: services.asMap().entries.map((entry) {
                          final percentage = totalCost > 0
                              ? (entry.value.coutActuel / totalCost * 100)
                              : 0.0;
                          return PieChartSectionData(
                            value: entry.value.coutActuel,
                            title: '${percentage.toStringAsFixed(1)}%',
                            color: colors[entry.key % colors.length],
                            radius: 110,
                            titleStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        }).toList(),
                        sectionsSpace: 3,
                        centerSpaceRadius: 60,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: services.asMap().entries.map((entry) {
                      final percentage = totalCost > 0
                          ? (entry.value.coutActuel / totalCost * 100)
                          : 0.0;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: colors[entry.key % colors.length],
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    entry.value.nom,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    NumberFormat.currency(
                                      locale: 'fr_FR',
                                      symbol: '€',
                                    ).format(entry.value.coutActuel),
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${percentage.toStringAsFixed(0)}%',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: colors[entry.key % colors.length],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetComparisonChart(BuildContext context, List<Service> services) {
    if (services.isEmpty) return const SizedBox();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Budget vs Coût Actuel par Service',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 320,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: services
                          .map((s) => [s.budgetMensuel, s.coutActuel])
                          .expand((e) => e)
                          .reduce((a, b) => a > b ? a : b) *
                      1.2,
                  barGroups: services.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.budgetMensuel,
                          color: Colors.blue,
                          width: 20,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                        ),
                        BarChartRodData(
                          toY: entry.value.coutActuel,
                          color: Colors.orange,
                          width: 20,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                        ),
                      ],
                      barsSpace: 8,
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
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }
                          return const Text('');
                        },
                        reservedSize: 50,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            NumberFormat.compactCurrency(
                              locale: 'fr_FR',
                              symbol: '€',
                            ).format(value),
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: services
                            .map((s) => [s.budgetMensuel, s.coutActuel])
                            .expand((e) => e)
                            .reduce((a, b) => a > b ? a : b) /
                        5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(Colors.blue, 'Budget'),
                const SizedBox(width: 24),
                _buildLegendItem(Colors.orange, 'Coût Actuel'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSoinsTimelineChart(BuildContext context, List<Soin> soins) {
    if (soins.isEmpty) return const SizedBox();

    // Grouper les soins par mois
    final soinsParMois = <String, int>{};
    for (var soin in soins) {
      final mois = DateFormat('MMM yyyy', 'fr_FR').format(soin.dateSoin);
      soinsParMois[mois] = (soinsParMois[mois] ?? 0) + 1;
    }

    final sortedMonths = soinsParMois.keys.toList()..sort();
    final maxSoins = soinsParMois.values.reduce((a, b) => a > b ? a : b);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Évolution des Soins',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true, drawVerticalLine: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() < sortedMonths.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                sortedMonths[value.toInt()],
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: sortedMonths.asMap().entries.map((entry) {
                        return FlSpot(
                          entry.key.toDouble(),
                          soinsParMois[entry.value]!.toDouble(),
                        );
                      }).toList(),
                      isCurved: true,
                      color: Colors.purple,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.purple.withOpacity(0.1),
                      ),
                    ),
                  ],
                  minY: 0,
                  maxY: maxSoins * 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Actions Rapides',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 2.5,
              children: [
                _buildModernActionButton(
                  context,
                  'Patients',
                  FontAwesomeIcons.userInjured,
                  [Colors.blue, Colors.blueAccent],
                  () => context.go('/patients'),
                ),
                _buildModernActionButton(
                  context,
                  'Services',
                  FontAwesomeIcons.hospital,
                  [Colors.green, Colors.greenAccent],
                  () => context.go('/services'),
                ),
                _buildModernActionButton(
                  context,
                  'Soins',
                  FontAwesomeIcons.heartPulse,
                  [Colors.orange, Colors.deepOrange],
                  () => context.go('/soins'),
                ),
                _buildModernActionButton(
                  context,
                  'Rapports',
                  FontAwesomeIcons.fileLines,
                  [Colors.purple, Colors.purpleAccent],
                  () => context.go('/rapports'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernActionButton(
    BuildContext context,
    String label,
    IconData icon,
    List<Color> gradientColors,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
