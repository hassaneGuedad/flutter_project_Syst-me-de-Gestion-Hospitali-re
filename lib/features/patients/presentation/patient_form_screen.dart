import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../domain/patient.dart';
import 'patient_providers.dart';
import '../../../core/localization/app_localizations.dart';

class PatientFormScreen extends ConsumerStatefulWidget {
  final String? id;

  const PatientFormScreen({super.key, this.id});

  @override
  ConsumerState<PatientFormScreen> createState() => _PatientFormScreenState();
}

class _PatientFormScreenState extends ConsumerState<PatientFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _secuController = TextEditingController();
  DateTime? _dateNaissance;

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _secuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id == null ? ref.tr('new_patient') : ref.tr('edit_patient')),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nomController,
              decoration: InputDecoration(labelText: ref.tr('name')),
              validator: (value) =>
                  value == null || value.isEmpty ? ref.tr('required_field') : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _prenomController,
              decoration: InputDecoration(labelText: ref.tr('first_name')),
              validator: (value) =>
                  value == null || value.isEmpty ? ref.tr('required_field') : null,
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _dateNaissance ?? DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() => _dateNaissance = date);
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(labelText: ref.tr('birth_date')),
                child: Text(
                  _dateNaissance == null
                      ? ref.tr('select_date')
                      : DateFormat('dd/MM/yyyy').format(_dateNaissance!),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _secuController,
              decoration: InputDecoration(labelText: ref.tr('social_security')),
              validator: (value) =>
                  value == null || value.isEmpty ? ref.tr('required_field') : null,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _submit,
              child: Text(ref.tr('save')),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() async {
    if (_formKey.currentState!.validate() && _dateNaissance != null) {
      final patient = Patient(
        id: widget.id ?? '', // ID ignored on create
        nom: _nomController.text,
        prenom: _prenomController.text,
        dateNaissance: _dateNaissance!,
        numeroSecuriteSociale: _secuController.text,
      );

      try {
        if (widget.id == null) {
          await ref.read(patientControllerProvider.notifier).createPatient(patient);
        } else {
          await ref.read(patientControllerProvider.notifier).updatePatient(patient);
        }
        if (mounted) context.pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${ref.tr('error')}: $e')),
        );
      }
    } else if (_dateNaissance == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ref.tr('select_date'))),
      );
    }
  }
}
