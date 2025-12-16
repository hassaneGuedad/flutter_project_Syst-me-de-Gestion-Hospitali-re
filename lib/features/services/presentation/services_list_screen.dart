import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'service_providers.dart';
import '../domain/service.dart';
import '../../../core/localization/app_localizations.dart';

class ServicesListScreen extends ConsumerStatefulWidget {
  const ServicesListScreen({super.key});

  @override
  ConsumerState<ServicesListScreen> createState() => _ServicesListScreenState();
}

class _ServicesListScreenState extends ConsumerState<ServicesListScreen> {
  String _searchQuery = '';
  final currencyFormat = NumberFormat.currency(locale: 'fr_FR', symbol: '€');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final servicesAsync = ref.watch(servicesListProvider);

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
                    Text(ref.tr('services'), style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(ref.tr('service_list'), style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => _showServiceDialog(context, null),
                  icon: const Icon(Icons.add),
                  label: Text(ref.tr('add_service')),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Search bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: ref.tr('search_service'),
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Colors.grey[400]),
                ),
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
            ),
            const SizedBox(height: 24),

            // Services grid
            Expanded(
              child: servicesAsync.when(
                data: (services) {
                  final filteredServices = services.where((s) => 
                    s.nom.toLowerCase().contains(_searchQuery.toLowerCase())
                  ).toList();

                  if (filteredServices.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(FontAwesomeIcons.hospitalUser, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(ref.tr('no_service_found'), style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => ref.refresh(servicesListProvider.future),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 1.3,
                      ),
                      itemCount: filteredServices.length,
                      itemBuilder: (context, index) => _buildServiceCard(filteredServices[index], isDark),
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
                        onPressed: () => ref.refresh(servicesListProvider),
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

  Widget _buildServiceCard(Service service, bool isDark) {
    final budgetRestant = service.budgetMensuel - service.coutActuel;
    final tauxUtilisation = service.budgetMensuel > 0 
        ? (service.coutActuel / service.budgetMensuel * 100)
        : 0.0;
    final isOverBudget = budgetRestant < 0;
    final isWarning = tauxUtilisation > 80;

    Color statusColor = Colors.green;
    if (isOverBudget) {
      statusColor = Colors.red;
    } else if (isWarning) {
      statusColor = Colors.orange;
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        border: isOverBudget ? Border.all(color: Colors.red.withOpacity(0.5), width: 2) : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showServiceDialog(context, service),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: FaIcon(FontAwesomeIcons.hospital, color: statusColor, size: 20),
                    ),
                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert, color: Colors.grey[400]),
                      onSelected: (value) {
                        if (value == 'edit') _showServiceDialog(context, service);
                        if (value == 'delete') _confirmDelete(service);
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(value: 'edit', child: Text(ref.tr('edit'))),
                        PopupMenuItem(value: 'delete', child: Text(ref.tr('delete'), style: const TextStyle(color: Colors.red))),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  service.nom,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.grey[900],
                  ),
                ),
                const Spacer(),
                // Budget progress
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(ref.tr('budget_used'), style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                        Text(
                          '${tauxUtilisation.toStringAsFixed(0)}%',
                          style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (tauxUtilisation / 100).clamp(0.0, 1.0),
                        minHeight: 6,
                        backgroundColor: Colors.grey.withOpacity(0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(ref.tr('budget'), style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                            Text(currencyFormat.format(service.budgetMensuel), style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.grey[800], fontSize: 13)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(ref.tr('remaining'), style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                            Text(
                              currencyFormat.format(budgetRestant),
                              style: TextStyle(fontWeight: FontWeight.w600, color: statusColor, fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showServiceDialog(BuildContext context, Service? service) {
    final isEditing = service != null;
    final nomController = TextEditingController(text: service?.nom ?? '');
    final budgetController = TextEditingController(text: service?.budgetMensuel.toString() ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? ref.tr('modify_service') : ref.tr('new_service')),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomController,
                decoration: InputDecoration(
                  labelText: ref.tr('service_name'),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: budgetController,
                decoration: InputDecoration(
                  labelText: ref.tr('monthly_budget'),
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(ref.tr('cancel')),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nomController.text.isEmpty || budgetController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(ref.tr('fill_required_fields')), backgroundColor: Colors.red),
                );
                return;
              }

              final budget = double.tryParse(budgetController.text) ?? 0;
              
              try {
                if (isEditing) {
                  final updatedService = Service(
                    id: service.id,
                    nom: nomController.text,
                    budgetMensuel: budget,
                    budgetAnnuel: budget * 12,
                    coutActuel: service.coutActuel,
                  );
                  await ref.read(serviceControllerProvider.notifier).updateService(updatedService);
                } else {
                  final newService = Service(
                    id: '',
                    nom: nomController.text,
                    budgetMensuel: budget,
                    budgetAnnuel: budget * 12,
                    coutActuel: 0,
                  );
                  await ref.read(serviceControllerProvider.notifier).createService(newService);
                }
                if (context.mounted) Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isEditing ? ref.tr('service_updated') : ref.tr('service_added')),
                    backgroundColor: Colors.green,
                  ),
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
    );
  }

  void _confirmDelete(Service service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(ref.tr('confirm_delete')),
        content: Text('${ref.tr('confirm_delete_service')} "${service.nom}"'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(ref.tr('cancel')),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              try {
                await ref.read(serviceControllerProvider.notifier).deleteService(service.id);
                if (context.mounted) Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(ref.tr('service_deleted')), backgroundColor: Colors.orange),
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
