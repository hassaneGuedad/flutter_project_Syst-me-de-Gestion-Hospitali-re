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

/**
 * DASHBOARD MODERNE ET ESTHÉTIQUE
 * Version améliorée avec :
 * - Glassmorphism (effet de verre)
 * - Animations fluides
 * - Design moderne avec gradients
 * - Intégration des fonctionnalités financières
 * - Meilleure organisation visuelle
 */

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    Colors.grey[900]!,
                    Colors.grey[850]!,
                    Colors.grey[900]!,
                  ]
                : [
                    Colors.blue[50]!,
                    Colors.purple[50]!,
                    Colors.white,
                  ],
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(servicesListProvider);
              ref.invalidate(patientsListProvider);
              ref.invalidate(soinsListProvider);
            },
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Header moderne avec glassmorphism
                SliverAppBar(
                  expandedHeight: 180,
                  floating: false,
                  pinned: true,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: FlexibleSpaceBar(
                    title: FadeTransition(
                      opacity: _fadeAnimation,
                      child: const Text(
                        'Tableau de Bord',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                    ),
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.blue[600]!,
                            Colors.purple[600]!,
                            Colors.blue[800]!,
                          ],
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Effet de particules animées
                          Positioned.fill(
                            child: CustomPaint(
                              painter: _ParticlePainter(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, bottom: 20, right: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: Text(
                                    _getGreeting(),
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.95),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: Text(
                                    DateFormat('EEEE d MMMM yyyy', 'fr_FR').format(DateTime.now()),
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.85),
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    Container(
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.logout, color: Colors.white),
                        onPressed: () {
                          ref.read(authRepositoryProvider).logout();
                          context.go('/login');
                        },
                      ),
                    ),
                  ],
                ),

                // Contenu principal
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // KPIs Principaux avec glassmorphism
                            servicesAsync.when(
                              data: (services) => patientsAsync.when(
                                data: (patients) => soinsAsync.when(
                                  data: (soins) => _buildModernKPIs(
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

                            // Graphiques
                            servicesAsync.when(
                              data: (services) => patientsAsync.when(
                                data: (patients) => soinsAsync.when(
                                  data: (soins) => Column(
                                    children: [
                                      _buildModernServiceCostsChart(context, services),
                                      const SizedBox(height: 20),
                                      _buildModernBudgetChart(context, services),
                                      const SizedBox(height: 20),
                                      _buildModernSoinsTimeline(context, soins),
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
                            _buildModernQuickActions(context),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Bonjour 👋';
    if (hour < 18) return 'Bon après-midi ☀️';
    return 'Bonsoir 🌙';
  }

  Widget _buildLoadingKPIs() {
    return Row(
      children: List.generate(4, (index) => Expanded(
        child: Container(
          margin: EdgeInsets.only(right: index < 3 ? 12 : 0),
          height: 140,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          child: const Center(child: CircularProgressIndicator()),
        ),
      )),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: Colors.red[700], fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernKPIs(
    BuildContext context,
    List<Service> services,
    List<Patient> patients,
    List<Soin> soins,
  ) {
    final totalBudget = services.fold<double>(0, (sum, s) => sum + (s.budgetMensuel ?? 0));
    final totalCost = services.fold<double>(0, (sum, s) => sum + (s.coutActuel ?? 0));
    final budgetRestant = totalBudget - totalCost;
    final tauxUtilisation = totalBudget > 0 ? (totalCost / totalBudget * 100) : 0;
    final totalSoins = soins.length;
    final totalPatients = patients.length;
    final coutTotalSoins = soins.fold<double>(0, (sum, s) => sum + (s.cout ?? 0));

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildGlassmorphicCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blue[400]!, Colors.blue[600]!],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const FaIcon(
                            FontAwesomeIcons.euroSign,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.trending_up, color: Colors.green[700], size: 14),
                              const SizedBox(width: 4),
                              Text(
                                '+12%',
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Budget Total',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      NumberFormat.currency(locale: 'fr_FR', symbol: '€', decimalDigits: 0)
                          .format(totalBudget),
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildGlassmorphicCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.orange[400]!, Colors.orange[600]!],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const FaIcon(
                            FontAwesomeIcons.chartLine,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Coût Actuel',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      NumberFormat.currency(locale: 'fr_FR', symbol: '€', decimalDigits: 0)
                          .format(totalCost),
                      style: TextStyle(
                        color: Colors.orange[700],
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildGlassmorphicCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: budgetRestant > 0
                                  ? [Colors.green[400]!, Colors.green[600]!]
                                  : [Colors.red[400]!, Colors.red[600]!],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: (budgetRestant > 0 ? Colors.green : Colors.red)
                                    .withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: FaIcon(
                            FontAwesomeIcons.piggyBank,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Budget Restant',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      NumberFormat.currency(locale: 'fr_FR', symbol: '€', decimalDigits: 0)
                          .format(budgetRestant),
                      style: TextStyle(
                        color: budgetRestant > 0 ? Colors.green[700] : Colors.red[700],
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildGlassmorphicCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: tauxUtilisation > 90
                                  ? [Colors.red[400]!, Colors.red[600]!]
                                  : [Colors.purple[400]!, Colors.purple[600]!],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: (tauxUtilisation > 90 ? Colors.red : Colors.purple)
                                    .withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: FaIcon(
                            FontAwesomeIcons.chartPie,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: tauxUtilisation > 90
                                ? Colors.red.withOpacity(0.2)
                                : Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            tauxUtilisation > 90 ? Icons.warning : Icons.check_circle,
                            color: tauxUtilisation > 90 ? Colors.red[700] : Colors.green[700],
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Taux Utilisation',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${tauxUtilisation.toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: tauxUtilisation > 90 ? Colors.red[700] : Colors.purple[700],
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGlassmorphicCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
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
    final coutTotalSoins = soins.fold<double>(0, (sum, s) => sum + (s.cout ?? 0));
    final soinsCeMois = soins.where((s) {
      final now = DateTime.now();
      return s.dateSoin.year == now.year && s.dateSoin.month == now.month;
    }).length;
    final moyenneCoutSoin = totalSoins > 0 ? coutTotalSoins / totalSoins : 0.0;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildStatCard(
            context,
            'Total Patients',
            totalPatients.toString(),
            FontAwesomeIcons.userInjured,
            Colors.blue,
            Icons.arrow_upward,
          ),
          const SizedBox(width: 16),
          _buildStatCard(
            context,
            'Total Soins',
            totalSoins.toString(),
            FontAwesomeIcons.heartPulse,
            Colors.pink,
            Icons.arrow_upward,
          ),
          const SizedBox(width: 16),
          _buildStatCard(
            context,
            'Soins ce Mois',
            soinsCeMois.toString(),
            FontAwesomeIcons.calendar,
            Colors.purple,
            null,
          ),
          const SizedBox(width: 16),
          _buildStatCard(
            context,
            'Coût Moyen',
            NumberFormat.currency(locale: 'fr_FR', symbol: '€', decimalDigits: 0)
                .format(moyenneCoutSoin),
            FontAwesomeIcons.coins,
            Colors.amber,
            null,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
    IconData? trendIcon,
  ) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FaIcon(icon, color: color, size: 18),
              ),
              if (trendIcon != null)
                Icon(trendIcon, color: color, size: 16),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernServiceCostsChart(BuildContext context, List<Service> services) {
    if (services.isEmpty) return const SizedBox();

    final totalCost = services.fold<double>(0, (sum, s) => sum + (s.coutActuel ?? 0));
    final colors = [
      Colors.blue,
      Colors.orange,
      Colors.green,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.indigo,
    ];

    return _buildGlassmorphicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Répartition des Coûts',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[400]!, Colors.blue[600]!],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${services.length} services',
                  style: const TextStyle(
                    color: Colors.white,
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
                            ? (entry.value.coutActuel ?? 0) / totalCost * 100
                            : 0.0;
                        return PieChartSectionData(
                          value: entry.value.coutActuel ?? 0,
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
                      sectionsSpace: 4,
                      centerSpaceRadius: 70,
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
                        ? ((entry.value.coutActuel ?? 0) / totalCost * 100)
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
                              boxShadow: [
                                BoxShadow(
                                  color: colors[entry.key % colors.length].withOpacity(0.5),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
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
                                    decimalDigits: 0,
                                  ).format(entry.value.coutActuel ?? 0),
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
                              fontSize: 13,
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
    );
  }

  Widget _buildModernBudgetChart(BuildContext context, List<Service> services) {
    if (services.isEmpty) return const SizedBox();

    return _buildGlassmorphicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Budget vs Coût Actuel',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 320,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: services
                        .map((s) => [
                              s.budgetMensuel ?? 0,
                              s.coutActuel ?? 0,
                            ])
                        .expand((e) => e)
                        .reduce((a, b) => a > b ? a : b) *
                    1.2,
                barGroups: services.asMap().entries.map((entry) {
                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value.budgetMensuel ?? 0,
                        color: Colors.blue[400]!,
                        width: 22,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                      ),
                      BarChartRodData(
                        toY: entry.value.coutActuel ?? 0,
                        color: Colors.orange[400]!,
                        width: 22,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                      ),
                    ],
                    barsSpace: 10,
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
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey[200]!,
                      strokeWidth: 1,
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(Colors.blue[400]!, 'Budget'),
              const SizedBox(width: 32),
              _buildLegendItem(Colors.orange[400]!, 'Coût Actuel'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModernSoinsTimeline(BuildContext context, List<Soin> soins) {
    if (soins.isEmpty) return const SizedBox();

    final soinsParMois = <String, int>{};
    for (var soin in soins) {
      final mois = DateFormat('MMM yyyy', 'fr_FR').format(soin.dateSoin);
      soinsParMois[mois] = (soinsParMois[mois] ?? 0) + 1;
    }

    final sortedMonths = soinsParMois.keys.toList()..sort();
    final maxSoins = soinsParMois.values.isEmpty
        ? 1
        : soinsParMois.values.reduce((a, b) => a > b ? a : b);

    return _buildGlassmorphicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Évolution des Soins',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey[200]!,
                      strokeWidth: 1,
                    );
                  },
                ),
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
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[300]!),
                    left: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: sortedMonths.asMap().entries.map((entry) {
                      return FlSpot(
                        entry.key.toDouble(),
                        soinsParMois[entry.value]!.toDouble(),
                      );
                    }).toList(),
                    isCurved: true,
                    color: Colors.purple[400]!,
                    barWidth: 4,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 5,
                          color: Colors.purple[400]!,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.purple.withOpacity(0.3),
                          Colors.purple.withOpacity(0.05),
                        ],
                      ),
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
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.5),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildModernQuickActions(BuildContext context) {
    return _buildGlassmorphicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Actions Rapides',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
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
                [Colors.blue[400]!, Colors.blue[600]!],
                () => context.go('/patients'),
              ),
              _buildModernActionButton(
                context,
                'Services',
                FontAwesomeIcons.hospital,
                [Colors.green[400]!, Colors.green[600]!],
                () => context.go('/services'),
              ),
              _buildModernActionButton(
                context,
                'Soins',
                FontAwesomeIcons.heartPulse,
                [Colors.orange[400]!, Colors.orange[600]!],
                () => context.go('/soins'),
              ),
              _buildModernActionButton(
                context,
                'Finance',
                FontAwesomeIcons.chartLine,
                [Colors.purple[400]!, Colors.purple[600]!],
                () => context.go('/finance'),
              ),
            ],
          ),
        ],
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: gradientColors[0].withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 10),
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
      ),
    );
  }
}

// Peintre pour les particules animées dans le header
class _ParticlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Dessiner des cercles animés
    for (int i = 0; i < 20; i++) {
      final x = (i * 50.0) % size.width;
      final y = (i * 30.0) % size.height;
      canvas.drawCircle(Offset(x, y), 3, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

