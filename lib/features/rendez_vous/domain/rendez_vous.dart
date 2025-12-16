class RendezVous {
  final String id;
  final String patientId;
  final String patientNom;
  final DateTime dateHeure;
  final String motif;
  final String statut; // 'En attente', 'Confirmé', 'Annulé', 'En cours', 'Terminé'
  final String? notes;

  RendezVous({
    required this.id,
    required this.patientId,
    required this.patientNom,
    required this.dateHeure,
    required this.motif,
    required this.statut,
    this.notes,
  });

  RendezVous copyWith({
    String? id,
    String? patientId,
    String? patientNom,
    DateTime? dateHeure,
    String? motif,
    String? statut,
    String? notes,
  }) {
    return RendezVous(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      patientNom: patientNom ?? this.patientNom,
      dateHeure: dateHeure ?? this.dateHeure,
      motif: motif ?? this.motif,
      statut: statut ?? this.statut,
      notes: notes ?? this.notes,
    );
  }
}
