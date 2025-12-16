import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/rendez_vous_repository_impl.dart';
import '../domain/rendez_vous.dart';
import '../domain/rendez_vous_repository.dart';

// Repository singleton
final _repositoryInstance = RendezVousRepositoryImpl();

// Provider pour le repository (singleton)
final rendezVousRepositoryProvider = Provider<RendezVousRepository>((ref) {
  return _repositoryInstance;
});

// Provider pour la liste des rendez-vous avec keepAlive
final rendezVousListProvider = FutureProvider<List<RendezVous>>((ref) async {
  ref.keepAlive();
  return ref.watch(rendezVousRepositoryProvider).getRendezVous();
});

// Provider pour les rendez-vous par date
final rendezVousByDateProvider = FutureProvider.family<List<RendezVous>, DateTime>((ref, date) async {
  return ref.watch(rendezVousRepositoryProvider).getRendezVousByDate(date);
});

// Provider pour un rendez-vous par ID
final rendezVousDetailProvider = FutureProvider.family<RendezVous, String>((ref, id) async {
  return ref.watch(rendezVousRepositoryProvider).getRendezVousById(id);
});

// Controller pour les opérations CRUD
class RendezVousController extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;
  
  RendezVousController(this._ref) : super(const AsyncValue.data(null));

  Future<void> createRendezVous(RendezVous rdv) async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(rendezVousRepositoryProvider).createRendezVous(rdv);
      _ref.invalidate(rendezVousListProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateRendezVous(RendezVous rdv) async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(rendezVousRepositoryProvider).updateRendezVous(rdv);
      _ref.invalidate(rendezVousListProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteRendezVous(String id) async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(rendezVousRepositoryProvider).deleteRendezVous(id);
      _ref.invalidate(rendezVousListProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateStatut(String id, String statut) async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(rendezVousRepositoryProvider).updateStatut(id, statut);
      _ref.invalidate(rendezVousListProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final rendezVousControllerProvider = StateNotifierProvider<RendezVousController, AsyncValue<void>>((ref) {
  return RendezVousController(ref);
});
