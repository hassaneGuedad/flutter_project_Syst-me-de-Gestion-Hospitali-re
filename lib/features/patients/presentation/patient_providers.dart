import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/patient_repository_impl.dart';
import '../domain/patient.dart';
import '../domain/patient_repository.dart';

// Repository singleton
final _repositoryInstance = PatientRepositoryImpl();

// Provider pour le repository (singleton)
final patientRepositoryProvider = Provider<PatientRepository>((ref) {
  return _repositoryInstance;
});

// Provider pour la liste des patients avec keepAlive
final patientsListProvider = FutureProvider<List<Patient>>((ref) async {
  ref.keepAlive();
  return ref.watch(patientRepositoryProvider).getPatients();
});

// Provider pour un patient par ID
final patientDetailProvider = FutureProvider.family<Patient, String>((
  ref,
  id,
) async {
  return ref.watch(patientRepositoryProvider).getPatient(id);
});

// Controller pour les opérations CRUD
class PatientController extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  PatientController(this._ref) : super(const AsyncValue.data(null));

  Future<void> createPatient(Patient patient) async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(patientRepositoryProvider).createPatient(patient);
      _ref.invalidate(patientsListProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> updatePatient(Patient patient) async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(patientRepositoryProvider).updatePatient(patient);
      _ref.invalidate(patientsListProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> deletePatient(String id) async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(patientRepositoryProvider).deletePatient(id);
      _ref.invalidate(patientsListProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

final patientControllerProvider =
    StateNotifierProvider<PatientController, AsyncValue<void>>((ref) {
      return PatientController(ref);
    });
