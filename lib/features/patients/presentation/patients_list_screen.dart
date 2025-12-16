import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../domain/patient.dart';
import 'patient_providers.dart';
import '../../../core/localization/app_localizations.dart';

class PatientsListScreen extends ConsumerStatefulWidget {
  const PatientsListScreen({super.key});

  @override
  ConsumerState<PatientsListScreen> createState() => _PatientsListScreenState();
}

class _PatientsListScreenState extends ConsumerState<PatientsListScreen> {
  String _searchQuery = '';
  final currencyFormat = NumberFormat.currency(locale: 'fr_FR', symbol: '€');
  final dateFormat = DateFormat('dd/MM/yyyy', 'fr');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final patientsAsync = ref.watch(patientsListProvider);

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
                    Text(ref.tr('patients'), style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(ref.tr('patient_list'), style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => _showPatientDialog(context, null),
                  icon: const Icon(Icons.add),
                  label: Text(ref.tr('add_patient')),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Search bar and stats
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
                        hintText: ref.tr('search_patient'),
                        border: InputBorder.none,
                        icon: Icon(Icons.search, color: Colors.grey[400]),
                      ),
                      onChanged: (value) => setState(() => _searchQuery = value),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                _buildStatsCard(patientsAsync, isDark),
              ],
            ),
            const SizedBox(height: 24),

            // Patients list
            Expanded(
              child: patientsAsync.when(
                data: (patients) {
                  final filteredPatients = patients.where((p) =>
                    p.nom.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                    p.prenom.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                    p.numeroSecuriteSociale.contains(_searchQuery)
                  ).toList();

                  if (filteredPatients.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(FontAwesomeIcons.userInjured, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(ref.tr('no_data'), style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => _showPatientDialog(context, null),
                            icon: const Icon(Icons.add),
                            label: Text(ref.tr('add_patient')),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => ref.refresh(patientsListProvider.future),
                    child: ListView.separated(
                      itemCount: filteredPatients.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) => _buildPatientCard(filteredPatients[index], isDark),
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
                        onPressed: () => ref.refresh(patientsListProvider),
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

  Widget _buildStatsCard(AsyncValue<List<Patient>> patientsAsync, bool isDark) {
    return patientsAsync.when(
      data: (patients) {
        final totalCout = patients.fold<double>(0, (sum, p) => sum + p.coutTotal);
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: const FaIcon(FontAwesomeIcons.users, color: Colors.blue, size: 20),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${patients.length} ${ref.tr('patients')}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text('${ref.tr('total')}: ${currencyFormat.format(totalCout)}', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox(width: 150, height: 60, child: Center(child: CircularProgressIndicator())),
      error: (_, __) => const SizedBox(),
    );
  }

  Widget _buildPatientCard(Patient patient, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blue.withOpacity(0.1),
            child: Text(
              '${patient.prenom[0]}${patient.nom[0]}'.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue),
            ),
          ),
          const SizedBox(width: 20),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${patient.prenom} ${patient.nom}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : Colors.grey[900]),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 14, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(dateFormat.format(patient.dateNaissance), style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                    const SizedBox(width: 16),
                    Icon(Icons.badge, size: 14, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(patient.numeroSecuriteSociale, style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
          // Coût total
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(currencyFormat.format(patient.coutTotal), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
              Text(ref.tr('total_cost'), style: TextStyle(color: Colors.grey[500], fontSize: 12)),
            ],
          ),
          const SizedBox(width: 16),
          // Actions
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                color: Colors.blue,
                onPressed: () => _showPatientDialog(context, patient),
                tooltip: ref.tr('edit'),
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 20),
                color: Colors.red,
                onPressed: () => _confirmDelete(patient),
                tooltip: ref.tr('delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showPatientDialog(BuildContext context, Patient? patient) {
    final isEditing = patient != null;
    final nomController = TextEditingController(text: patient?.nom ?? '');
    final prenomController = TextEditingController(text: patient?.prenom ?? '');
    final secuController = TextEditingController(text: patient?.numeroSecuriteSociale ?? '');
    DateTime selectedDate = patient?.dateNaissance ?? DateTime.now().subtract(const Duration(days: 365 * 30));

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEditing ? ref.tr('modify_patient') : ref.tr('new_patient_title')),
          content: SizedBox(
            width: 450,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nomController,
                  decoration: InputDecoration(labelText: ref.tr('name'), border: const OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: prenomController,
                  decoration: InputDecoration(labelText: ref.tr('first_name'), border: const OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setDialogState(() => selectedDate = date);
                    }
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(labelText: ref.tr('birth_date'), border: const OutlineInputBorder()),
                    child: Text(dateFormat.format(selectedDate)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: secuController,
                  decoration: InputDecoration(labelText: ref.tr('social_security'), border: const OutlineInputBorder()),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text(ref.tr('cancel'))),
            ElevatedButton(
              onPressed: () async {
                if (nomController.text.isEmpty || prenomController.text.isEmpty || secuController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(ref.tr('fill_required_fields')), backgroundColor: Colors.red),
                  );
                  return;
                }

                try {
                  if (isEditing) {
                    final updatedPatient = Patient(
                      id: patient.id,
                      nom: nomController.text,
                      prenom: prenomController.text,
                      dateNaissance: selectedDate,
                      numeroSecuriteSociale: secuController.text,
                      coutTotal: patient.coutTotal,
                      soinIds: patient.soinIds,
                    );
                    await ref.read(patientControllerProvider.notifier).updatePatient(updatedPatient);
                  } else {
                    final newPatient = Patient(
                      id: '',
                      nom: nomController.text,
                      prenom: prenomController.text,
                      dateNaissance: selectedDate,
                      numeroSecuriteSociale: secuController.text,
                    );
                    await ref.read(patientControllerProvider.notifier).createPatient(newPatient);
                  }
                  if (context.mounted) Navigator.pop(context);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(isEditing ? ref.tr('patient_updated') : ref.tr('patient_added')), backgroundColor: Colors.green),
                    );
                  }
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

  void _confirmDelete(Patient patient) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(ref.tr('confirm_delete')),
        content: Text('${ref.tr('confirm_delete_patient')} "${patient.prenom} ${patient.nom}"'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(ref.tr('cancel'))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              try {
                await ref.read(patientControllerProvider.notifier).deletePatient(patient.id);
                if (context.mounted) Navigator.pop(context);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(ref.tr('patient_deleted')), backgroundColor: Colors.orange),
                  );
                }
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
