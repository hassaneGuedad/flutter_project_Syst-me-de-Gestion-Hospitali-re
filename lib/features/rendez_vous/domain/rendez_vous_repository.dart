import 'rendez_vous.dart';

abstract class RendezVousRepository {
  Future<List<RendezVous>> getRendezVous();
  Future<RendezVous> getRendezVousById(String id);
  Future<List<RendezVous>> getRendezVousByDate(DateTime date);
  Future<List<RendezVous>> getRendezVousByPatient(String patientId);
  Future<RendezVous> createRendezVous(RendezVous rdv);
  Future<RendezVous> updateRendezVous(RendezVous rdv);
  Future<void> deleteRendezVous(String id);
  Future<RendezVous> updateStatut(String id, String statut);
}
