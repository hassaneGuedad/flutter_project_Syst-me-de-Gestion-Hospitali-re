import 'service.dart';

abstract class ServiceRepository {
  Future<List<Service>> getServices();
  Future<Service> getService(String id);
  Future<Service> createService(Service service);
  Future<Service> updateService(Service service);
  Future<void> deleteService(String id);
  Future<double> getCoutActuel(String serviceId);
  Future<double> getBudgetRestant(String serviceId);
}
