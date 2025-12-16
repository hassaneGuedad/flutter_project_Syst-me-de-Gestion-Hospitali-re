import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/soin_repository_impl.dart';
import '../domain/soin.dart';
import '../domain/soin_repository.dart';

// Repository singleton
final _repositoryInstance = SoinRepositoryImpl();

// Provider pour le repository (singleton)
final soinRepositoryProvider = Provider<SoinRepository>((ref) {
  return _repositoryInstance;
});

// Provider pour la liste des soins avec keepAlive
final soinsListProvider = FutureProvider<List<Soin>>((ref) async {
  ref.keepAlive();
  return ref.watch(soinRepositoryProvider).getSoins();
});

// Provider pour les soins par patient
final soinsByPatientProvider = FutureProvider.family<List<Soin>, String>((ref, patientId) async {
  return ref.watch(soinRepositoryProvider).getSoinsByPatient(patientId);
});

// Provider pour les soins par service
final soinsByServiceProvider = FutureProvider.family<List<Soin>, String>((ref, serviceId) async {
  return ref.watch(soinRepositoryProvider).getSoinsByService(serviceId);
});

// Controller pour les opérations CRUD
class SoinController extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;
  
  SoinController(this._ref) : super(const AsyncValue.data(null));

  Future<void> createSoin(Soin soin) async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(soinRepositoryProvider).createSoin(soin);
      _ref.invalidate(soinsListProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateSoin(Soin soin) async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(soinRepositoryProvider).updateSoin(soin);
      _ref.invalidate(soinsListProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteSoin(String id) async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(soinRepositoryProvider).deleteSoin(id);
      _ref.invalidate(soinsListProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final soinControllerProvider = StateNotifierProvider<SoinController, AsyncValue<void>>((ref) {
  return SoinController(ref);
});
