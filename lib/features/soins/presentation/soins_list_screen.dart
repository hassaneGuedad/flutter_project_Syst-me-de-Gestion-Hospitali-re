import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'soin_providers.dart';
import '../domain/soin.dart';
import '../../../core/localization/app_localizations.dart';

class SoinsListScreen extends ConsumerStatefulWidget {
  const SoinsListScreen({super.key});

  @override
  ConsumerState<SoinsListScreen> createState() => _SoinsListScreenState();
}

class _SoinsListScreenState extends ConsumerState<SoinsListScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'all';
  final currencyFormat = NumberFormat.currency(locale: 'fr_FR', symbol: '€');
  final dateFormat = DateFormat('dd/MM/yyyy HH:mm', 'fr');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final soinsAsync = ref.watch(soinsListProvider);

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
                    Text(ref.tr('care'), style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(ref.tr('care_list'), style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => _showSoinDialog(context, null),
                  icon: const Icon(Icons.add),
                  label: Text(ref.tr('add_care')),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Search and filter
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: ref.tr('search_care'),
                        border: InputBorder.none,
                        icon: Icon(Icons.search, color: Colors.grey[400]),
                      ),
                      onChanged: (value) => setState(() => _searchQuery = value),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                  ),
                  child: DropdownButton<String>(
                    value: _selectedFilter,
                    underline: const SizedBox(),
                    items: [
                      DropdownMenuItem(value: 'all', child: Text(ref.tr('all'))),
                      DropdownMenuItem(value: 'Consultation', child: Text(ref.tr('consultation'))),
                      DropdownMenuItem(value: 'Chirurgie', child: Text(ref.tr('surgery'))),
                      DropdownMenuItem(value: 'Analyse', child: Text(ref.tr('analysis'))),
                      DropdownMenuItem(value: 'Radiologie', child: Text(ref.tr('radiology'))),
                      DropdownMenuItem(value: 'Urgence', child: Text(ref.tr('emergency'))),
                    ],
                    onChanged: (value) => setState(() => _selectedFilter = value!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Stats row
            _buildStatsRow(soinsAsync, isDark),
            const SizedBox(height: 24),

            // Soins list
            Expanded(
              child: soinsAsync.when(
                data: (soins) {
                  var filteredSoins = soins.where((s) => 
                    s.typeSoin.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                    (s.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false)
                  ).toList();

                  if (_selectedFilter != 'Tous') {
                    filteredSoins = filteredSoins.where((s) => s.typeSoin == _selectedFilter).toList();
                  }

                  if (filteredSoins.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(FontAwesomeIcons.briefcaseMedical, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(ref.tr('no_care_found'), style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => ref.refresh(soinsListProvider.future),
                    child: ListView.separated(
                      itemCount: filteredSoins.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) => _buildSoinCard(filteredSoins[index], isDark),
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('${ref.tr('error')}: $err', style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.refresh(soinsListProvider),
                        child: Text(ref.tr('retry')),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(AsyncValue<List<Soin>> soinsAsync, bool isDark) {
    return soinsAsync.when(
      data: (soins) {
        final totalSoins = soins.length;
        final totalCout = soins.fold<double>(0, (sum, s) => sum + s.cout);
        final avgCout = totalSoins > 0 ? totalCout / totalSoins : 0;

        return Row(
          children: [
            Expanded(child: _buildStatCard(ref.tr('total'), '$totalSoins', FontAwesomeIcons.briefcaseMedical, Colors.blue, isDark)),
            const SizedBox(width: 16),
            Expanded(child: _buildStatCard(ref.tr('total_cost'), currencyFormat.format(totalCout), FontAwesomeIcons.euroSign, Colors.green, isDark)),
            const SizedBox(width: 16),
            Expanded(child: _buildStatCard(ref.tr('average'), currencyFormat.format(avgCout), FontAwesomeIcons.chartLine, Colors.purple, isDark)),
          ],
        );
      },
      loading: () => const SizedBox(height: 100),
      error: (_, __) => const SizedBox(height: 100),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: FaIcon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
              const SizedBox(height: 4),
              Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.grey[900])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSoinCard(Soin soin, bool isDark) {
    Color typeColor;
    IconData typeIcon;
    switch (soin.typeSoin) {
      case 'Consultation': typeColor = Colors.blue; typeIcon = FontAwesomeIcons.stethoscope; break;
      case 'Chirurgie': typeColor = Colors.red; typeIcon = FontAwesomeIcons.kitMedical; break;
      case 'Analyse': typeColor = Colors.green; typeIcon = FontAwesomeIcons.flask; break;
      case 'Radiologie': typeColor = Colors.purple; typeIcon = FontAwesomeIcons.xRay; break;
      case 'Urgence': typeColor = Colors.orange; typeIcon = FontAwesomeIcons.truckMedical; break;
      default: typeColor = Colors.grey; typeIcon = FontAwesomeIcons.hospitalUser;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: typeColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: FaIcon(typeIcon, color: typeColor, size: 24),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: typeColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                      child: Text(soin.typeSoin, style: TextStyle(color: typeColor, fontWeight: FontWeight.w600, fontSize: 12)),
                    ),
                    const Spacer(),
                    Text(dateFormat.format(soin.dateSoin), style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                  ],
                ),
                if (soin.description != null) ...[
                  const SizedBox(height: 8),
                  Text(soin.description!, style: TextStyle(color: isDark ? Colors.white : Colors.grey[800], fontSize: 15)),
                ],
                const SizedBox(height: 8),
                Text('Patient ID: ${soin.patientId}', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(currencyFormat.format(soin.cout), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: typeColor)),
              const SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    color: Colors.blue,
                    onPressed: () => _showSoinDialog(context, soin),
                    tooltip: ref.tr('edit'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20),
                    color: Colors.red,
                    onPressed: () => _confirmDelete(soin),
                    tooltip: ref.tr('delete'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showSoinDialog(BuildContext context, Soin? soin) {
    final isEditing = soin != null;
    final typeController = TextEditingController(text: soin?.typeSoin ?? 'Consultation');
    final descController = TextEditingController(text: soin?.description ?? '');
    final coutController = TextEditingController(text: soin?.cout.toString() ?? '');
    final patientIdController = TextEditingController(text: soin?.patientId ?? '');
    DateTime selectedDate = soin?.dateSoin ?? DateTime.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEditing ? ref.tr('modify_care') : ref.tr('new_care')),
          content: SizedBox(
            width: 450,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: typeController.text,
                  decoration: InputDecoration(labelText: ref.tr('care_type'), border: const OutlineInputBorder()),
                  items: ['Consultation', 'Chirurgie', 'Analyse', 'Radiologie', 'Urgence']
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (value) => typeController.text = value ?? 'Consultation',
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descController,
                  decoration: InputDecoration(labelText: ref.tr('description'), border: const OutlineInputBorder()),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: coutController,
                  decoration: InputDecoration(labelText: ref.tr('cost_euro'), border: const OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: patientIdController,
                  decoration: InputDecoration(labelText: ref.tr('patient_id'), border: const OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(selectedDate),
                      );
                      if (time != null) {
                        setDialogState(() {
                          selectedDate = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                        });
                      }
                    }
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(labelText: ref.tr('care_date'), border: const OutlineInputBorder()),
                    child: Text(dateFormat.format(selectedDate)),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text(ref.tr('cancel'))),
            ElevatedButton(
              onPressed: () async {
                if (coutController.text.isEmpty || patientIdController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(ref.tr('fill_required_fields')), backgroundColor: Colors.red),
                  );
                  return;
                }

                final cout = double.tryParse(coutController.text) ?? 0;
                
                try {
                  if (isEditing) {
                    final updatedSoin = Soin(
                      id: soin.id,
                      patientId: patientIdController.text,
                      serviceId: soin.serviceId ?? '1',
                      typeSoin: typeController.text,
                      dateSoin: selectedDate,
                      cout: cout,
                      description: descController.text.isNotEmpty ? descController.text : null,
                    );
                    await ref.read(soinControllerProvider.notifier).updateSoin(updatedSoin);
                  } else {
                    final newSoin = Soin(
                      id: '',
                      patientId: patientIdController.text,
                      serviceId: '1',
                      typeSoin: typeController.text,
                      dateSoin: selectedDate,
                      cout: cout,
                      description: descController.text.isNotEmpty ? descController.text : null,
                    );
                    await ref.read(soinControllerProvider.notifier).createSoin(newSoin);
                  }
                  if (context.mounted) Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(isEditing ? ref.tr('care_updated') : ref.tr('care_added')), backgroundColor: Colors.green),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${ref.tr('error')}: $e'), backgroundColor: Colors.red),
                  );
                }
              },
              child: Text(isEditing ? ref.tr('edit') : ref.tr('create')),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(Soin soin) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(ref.tr('confirm_delete')),
        content: Text('${ref.tr('confirm_delete_care')} "${soin.typeSoin}"'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(ref.tr('cancel'))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              try {
                await ref.read(soinControllerProvider.notifier).deleteSoin(soin.id);
                if (context.mounted) Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(ref.tr('care_deleted')), backgroundColor: Colors.orange),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${ref.tr('error')}: $e'), backgroundColor: Colors.red),
                );
              }
            },
            child: Text(ref.tr('delete')),
          ),
        ],
      ),
    );
  }
}
