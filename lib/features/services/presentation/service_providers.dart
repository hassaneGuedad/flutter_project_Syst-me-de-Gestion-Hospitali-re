import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/service_repository_impl.dart';
import '../domain/service.dart';
import '../domain/service_repository.dart';

// Repository singleton
final _repositoryInstance = ServiceRepositoryImpl();

// Provider pour le repository (singleton)
final serviceRepositoryProvider = Provider<ServiceRepository>((ref) {
  return _repositoryInstance;
});

// Provider pour la liste des services avec keepAlive
final servicesListProvider = FutureProvider<List<Service>>((ref) async {
  ref.keepAlive();
  return ref.watch(serviceRepositoryProvider).getServices();
});

// Provider pour un service par ID
final serviceDetailProvider = FutureProvider.family<Service, String>((ref, id) async {
  return ref.watch(serviceRepositoryProvider).getService(id);
});

// Controller pour les opérations CRUD
class ServiceController extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;
  
  ServiceController(this._ref) : super(const AsyncValue.data(null));

  Future<void> createService(Service service) async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(serviceRepositoryProvider).createService(service);
      _ref.invalidate(servicesListProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateService(Service service) async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(serviceRepositoryProvider).updateService(service);
      _ref.invalidate(servicesListProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteService(String id) async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(serviceRepositoryProvider).deleteService(id);
      _ref.invalidate(servicesListProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final serviceControllerProvider = StateNotifierProvider<ServiceController, AsyncValue<void>>((ref) {
  return ServiceController(ref);
});
