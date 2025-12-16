import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../domain/rendez_vous.dart';
import 'rendez_vous_providers.dart';
import '../../../core/localization/app_localizations.dart';

class RendezVousScreen extends ConsumerStatefulWidget {
  const RendezVousScreen({super.key});

  @override
  ConsumerState<RendezVousScreen> createState() => _RendezVousScreenState();
}

class _RendezVousScreenState extends ConsumerState<RendezVousScreen> {
  DateTime _selectedDate = DateTime.now();
  String _selectedView = 'day';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final rendezVousAsync = ref.watch(rendezVousListProvider);
    final lang = ref.watch(languageProvider);
    final locale = lang == 'English' ? 'en' : (lang == 'العربية' ? 'ar' : 'fr');

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
                    Text(ref.tr('appointments'), style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(DateFormat('EEEE d MMMM yyyy', locale).format(_selectedDate), style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
                Row(
                  children: [
                    _buildViewSelector(isDark),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: () => _showRendezVousDialog(context, null),
                      icon: const Icon(Icons.add),
                      label: Text(ref.tr('add_appointment')),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Date navigation
            _buildDateNavigation(isDark),
            const SizedBox(height: 24),

            // Content
            Expanded(
              child: Row(
                children: [
                  Expanded(flex: 2, child: _buildRendezVousList(rendezVousAsync, isDark)),
                  const SizedBox(width: 24),
                  Expanded(child: _buildStats(rendezVousAsync, isDark)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewSelector(bool isDark) {
    final views = {
      'day': ref.tr('today'),
      'week': ref.tr('week'),
      'month': ref.tr('month'),
    };
    
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: views.entries.map((entry) {
          final isSelected = _selectedView == entry.key;
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => setState(() => _selectedView = entry.key),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(entry.value, style: TextStyle(color: isSelected ? Colors.white : Colors.grey[700], fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDateNavigation(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => setState(() => _selectedDate = _selectedDate.subtract(const Duration(days: 1))),
          ),
          InkWell(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (date != null) {
                setState(() => _selectedDate = date);
              }
            },
            child: Text(DateFormat('d MMMM yyyy', 'fr').format(_selectedDate), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => setState(() => _selectedDate = _selectedDate.add(const Duration(days: 1))),
          ),
        ],
      ),
    );
  }

  Widget _buildRendezVousList(AsyncValue<List<RendezVous>> rendezVousAsync, bool isDark) {
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
              Text('Rendez-vous du jour', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.grey[900])),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => ref.refresh(rendezVousListProvider),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: rendezVousAsync.when(
              data: (rendezVous) {
                // Filtrer par date sélectionnée
                final filteredRdv = rendezVous.where((r) =>
                  r.dateHeure.year == _selectedDate.year &&
                  r.dateHeure.month == _selectedDate.month &&
                  r.dateHeure.day == _selectedDate.day
                ).toList()
                  ..sort((a, b) => a.dateHeure.compareTo(b.dateHeure));

                if (filteredRdv.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(FontAwesomeIcons.calendarXmark, size: 48, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(ref.tr('no_appointments_for_date'), style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => ref.refresh(rendezVousListProvider.future),
                  child: ListView.separated(
                    itemCount: filteredRdv.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) => _buildRendezVousCard(filteredRdv[index], isDark),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('${ref.tr('error')}: $err', style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.refresh(rendezVousListProvider),
                      child: Text(ref.tr('retry')),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRendezVousCard(RendezVous rdv, bool isDark) {
    Color statusColor;
    String statusText;
    switch (rdv.statut) {
      case 'Confirmé': statusColor = Colors.green; statusText = ref.tr('confirmed'); break;
      case 'En attente': statusColor = Colors.orange; statusText = ref.tr('pending'); break;
      case 'Annulé': statusColor = Colors.red; statusText = ref.tr('cancelled'); break;
      case 'En cours': statusColor = Colors.blue; statusText = ref.tr('in_progress'); break;
      case 'Terminé': statusColor = Colors.grey; statusText = ref.tr('completed'); break;
      default: statusColor = Colors.grey; statusText = rdv.statut;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Text(DateFormat('HH:mm').format(rdv.dateHeure), style: TextStyle(fontWeight: FontWeight.bold, color: statusColor)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(rdv.patientNom, style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.grey[900])),
                Text(rdv.motif, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
              ],
            ),
          ),
          // Statut dropdown
          PopupMenuButton<String>(
            initialValue: rdv.statut,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(rdv.statut, style: TextStyle(color: statusColor, fontWeight: FontWeight.w600, fontSize: 12)),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_drop_down, color: statusColor, size: 18),
                ],
              ),
            ),
            onSelected: (String newStatut) async {
              await ref.read(rendezVousControllerProvider.notifier).updateStatut(rdv.id, newStatut);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${ref.tr('status_updated')}: $newStatut'), backgroundColor: Colors.green),
                );
              }
            },
            itemBuilder: (context) => ['En attente', 'Confirmé', 'En cours', 'Terminé', 'Annulé']
              .map((s) => PopupMenuItem(value: s, child: Text(s)))
              .toList(),
          ),
          const SizedBox(width: 8),
          // Actions
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.grey[400]),
            onSelected: (value) {
              if (value == 'edit') _showRendezVousDialog(context, rdv);
              if (value == 'delete') _confirmDelete(rdv);
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'edit', child: Text(ref.tr('edit'))),
              PopupMenuItem(value: 'delete', child: Text(ref.tr('delete'), style: const TextStyle(color: Colors.red))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStats(AsyncValue<List<RendezVous>> rendezVousAsync, bool isDark) {
    return rendezVousAsync.when(
      data: (rendezVous) {
        final todayRdv = rendezVous.where((r) =>
          r.dateHeure.year == _selectedDate.year &&
          r.dateHeure.month == _selectedDate.month &&
          r.dateHeure.day == _selectedDate.day
        ).toList();

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
              Text(ref.tr('statistics'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.grey[900])),
              const SizedBox(height: 24),
              _buildStatItem(ref.tr('total'), '${todayRdv.length}', FontAwesomeIcons.calendar, Colors.blue, isDark),
              const SizedBox(height: 16),
              _buildStatItem(ref.tr('confirmed'), '${todayRdv.where((r) => r.statut == 'Confirmé').length}', FontAwesomeIcons.check, Colors.green, isDark),
              const SizedBox(height: 16),
              _buildStatItem(ref.tr('pending'), '${todayRdv.where((r) => r.statut == 'En attente').length}', FontAwesomeIcons.clock, Colors.orange, isDark),
              const SizedBox(height: 16),
              _buildStatItem(ref.tr('in_progress'), '${todayRdv.where((r) => r.statut == 'En cours').length}', FontAwesomeIcons.spinner, Colors.blue, isDark),
              const SizedBox(height: 16),
              _buildStatItem(ref.tr('completed'), '${todayRdv.where((r) => r.statut == 'Terminé').length}', FontAwesomeIcons.checkDouble, Colors.grey, isDark),
              const SizedBox(height: 16),
              _buildStatItem(ref.tr('cancelled'), '${todayRdv.where((r) => r.statut == 'Annulé').length}', FontAwesomeIcons.xmark, Colors.red, isDark),
            ],
          ),
        );
      },
      loading: () => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(child: Text(ref.tr('error'))),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          FaIcon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: TextStyle(color: isDark ? Colors.white : Colors.grey[700]))),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: color)),
        ],
      ),
    );
  }

  void _showRendezVousDialog(BuildContext context, RendezVous? rdv) {
    final isEditing = rdv != null;
    final patientNomController = TextEditingController(text: rdv?.patientNom ?? '');
    final patientIdController = TextEditingController(text: rdv?.patientId ?? '');
    final motifController = TextEditingController(text: rdv?.motif ?? '');
    final notesController = TextEditingController(text: rdv?.notes ?? '');
    String selectedStatut = rdv?.statut ?? 'En attente';
    DateTime selectedDate = rdv?.dateHeure ?? DateTime.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEditing ? ref.tr('modify_appointment') : ref.tr('new_appointment')),
          content: SizedBox(
            width: 450,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: patientNomController,
                    decoration: InputDecoration(labelText: ref.tr('name'), border: const OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: patientIdController,
                    decoration: InputDecoration(labelText: ref.tr('patient_id'), border: const OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: motifController,
                    decoration: InputDecoration(labelText: ref.tr('reason'), border: const OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedStatut,
                    decoration: InputDecoration(labelText: ref.tr('status'), border: const OutlineInputBorder()),
                    items: ['En attente', 'Confirmé', 'En cours', 'Terminé', 'Annulé']
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (value) => setDialogState(() => selectedStatut = value ?? 'En attente'),
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
                      decoration: InputDecoration(labelText: ref.tr('date'), border: const OutlineInputBorder()),
                      child: Text(DateFormat('dd/MM/yyyy HH:mm', 'fr').format(selectedDate)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: notesController,
                    decoration: InputDecoration(labelText: ref.tr('notes_optional'), border: const OutlineInputBorder()),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text(ref.tr('cancel'))),
            ElevatedButton(
              onPressed: () async {
                if (patientNomController.text.isEmpty || motifController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(ref.tr('fill_required_fields')), backgroundColor: Colors.red),
                  );
                  return;
                }

                try {
                  if (isEditing) {
                    final updatedRdv = RendezVous(
                      id: rdv.id,
                      patientId: patientIdController.text.isNotEmpty ? patientIdController.text : rdv.patientId,
                      patientNom: patientNomController.text,
                      dateHeure: selectedDate,
                      motif: motifController.text,
                      statut: selectedStatut,
                      notes: notesController.text.isNotEmpty ? notesController.text : null,
                    );
                    await ref.read(rendezVousControllerProvider.notifier).updateRendezVous(updatedRdv);
                  } else {
                    final newRdv = RendezVous(
                      id: '',
                      patientId: patientIdController.text.isNotEmpty ? patientIdController.text : 'new',
                      patientNom: patientNomController.text,
                      dateHeure: selectedDate,
                      motif: motifController.text,
                      statut: selectedStatut,
                      notes: notesController.text.isNotEmpty ? notesController.text : null,
                    );
                    await ref.read(rendezVousControllerProvider.notifier).createRendezVous(newRdv);
                  }
                  if (context.mounted) Navigator.pop(context);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(isEditing ? ref.tr('appointment_updated') : ref.tr('appointment_added')), backgroundColor: Colors.green),
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

  void _confirmDelete(RendezVous rdv) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(ref.tr('confirm_delete')),
        content: Text('${ref.tr('confirm_delete_appointment')} "${rdv.patientNom}"'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(ref.tr('cancel'))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              try {
                await ref.read(rendezVousControllerProvider.notifier).deleteRendezVous(rdv.id);
                if (context.mounted) Navigator.pop(context);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(ref.tr('appointment_deleted')), backgroundColor: Colors.orange),
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
