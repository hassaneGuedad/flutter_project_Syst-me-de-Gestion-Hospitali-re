import 'soin.dart';

abstract class SoinRepository {
  Future<List<Soin>> getSoins();
  Future<List<Soin>> getSoinsByPatient(String patientId);
  Future<List<Soin>> getSoinsByService(String serviceId);
  Future<Soin> getSoin(String id);
  Future<Soin> createSoin(Soin soin);
  Future<Soin> updateSoin(Soin soin);
  Future<void> deleteSoin(String id);
}
