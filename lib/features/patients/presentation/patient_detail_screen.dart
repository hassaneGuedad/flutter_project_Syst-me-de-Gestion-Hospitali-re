import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'patient_providers.dart';
import '../../soins/presentation/soin_providers.dart';
import '../../../core/localization/app_localizations.dart';

class PatientDetailScreen extends ConsumerWidget {
  final String id;

  const PatientDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patientAsync = ref.watch(patientDetailProvider(id));
    final soinsAsync = ref.watch(soinsByPatientProvider(id));

    return Scaffold(
      appBar: AppBar(
        title: Text(ref.tr('patient_details')),
      ),
      body: patientAsync.when(
        data: (patient) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${patient.prenom} ${patient.nom}',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(ref.tr('birth_date'), DateFormat('dd/MM/yyyy').format(patient.dateNaissance)),
                      _buildInfoRow(ref.tr('social_security'), patient.numeroSecuriteSociale),
                      _buildInfoRow(
                        ref.tr('total_cost'),
                        NumberFormat.currency(locale: 'fr_FR', symbol: '€').format(patient.coutTotal),
                      ),
                      _buildInfoRow(ref.tr('care_count'), '${patient.soinIds.length}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                ref.tr('care_list'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              soinsAsync.when(
                data: (soins) => soins.isEmpty
                    ? Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(ref.tr('no_care_found')),
                        ),
                      )
                    : Column(
                        children: soins.map((soin) => Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            title: Text(soin.typeSoin),
                            subtitle: Text(
                              DateFormat('dd/MM/yyyy HH:mm').format(soin.dateSoin),
                            ),
                            trailing: Text(
                              NumberFormat.currency(locale: 'fr_FR', symbol: '€').format(soin.cout),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        )).toList(),
                      ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Text('${ref.tr('error')}: $err'),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('${ref.tr('error')}: $err')),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
