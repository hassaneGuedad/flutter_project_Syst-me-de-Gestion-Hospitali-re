import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/network/api_config.dart';
import '../domain/rendez_vous.dart';
import '../domain/rendez_vous_repository.dart';

/// Implémentation du repository des rendez-vous
/// Connecté au backend Spring Boot via API REST
class RendezVousRepositoryImpl implements RendezVousRepository {
  final String _baseUrl = '${ApiConfig.baseUrl}/api/rendez-vous';

  Map<String, String> get _headers => {'Content-Type': 'application/json'};

  /// Convertit la réponse JSON du backend en objet RendezVous
  RendezVous _rendezVousFromJson(Map<String, dynamic> json) {
    final patient = json['patient'];
    return RendezVous(
      id: json['id'].toString(),
      patientId:
          patient?['id']?.toString() ?? json['patientId']?.toString() ?? '',
      patientNom: patient != null
          ? '${patient['prenom'] ?? ''} ${patient['nom'] ?? ''}'.trim()
          : json['patientNom'] ?? '',
      dateHeure: json['dateHeure'] != null
          ? DateTime.parse(json['dateHeure'])
          : DateTime.now(),
      motif: json['motif'] ?? '',
      statut: json['statut'] ?? 'En attente',
      notes: json['notes'],
    );
  }

  /// Convertit un RendezVous en JSON pour le backend
  Map<String, dynamic> _rendezVousToJson(RendezVous rdv) {
    return {
      if (rdv.id.isNotEmpty && rdv.id != '0') 'id': int.tryParse(rdv.id),
      'patient': {'id': int.tryParse(rdv.patientId)},
      'dateHeure': rdv.dateHeure.toIso8601String(),
      'motif': rdv.motif,
      'statut': rdv.statut,
      'notes': rdv.notes,
    };
  }

  @override
  Future<List<RendezVous>> getRendezVous() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl), headers: _headers);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => _rendezVousFromJson(json)).toList();
      } else {
        throw Exception(
          'Erreur lors de la récupération des rendez-vous: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Erreur de connexion au serveur: $e');
    }
  }

  @override
  Future<RendezVous> getRendezVousById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/$id'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return _rendezVousFromJson(jsonDecode(response.body));
      } else {
        throw Exception('Rendez-vous non trouvé: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion au serveur: $e');
    }
  }

  @override
  Future<List<RendezVous>> getRendezVousByDate(DateTime date) async {
    try {
      final dateStr =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final response = await http.get(
        Uri.parse('$_baseUrl/date/$dateStr'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => _rendezVousFromJson(json)).toList();
      } else {
        throw Exception(
          'Erreur lors de la récupération des rendez-vous: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Erreur de connexion au serveur: $e');
    }
  }

  @override
  Future<List<RendezVous>> getRendezVousByPatient(String patientId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/patient/$patientId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => _rendezVousFromJson(json)).toList();
      } else {
        throw Exception(
          'Erreur lors de la récupération des rendez-vous: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Erreur de connexion au serveur: $e');
    }
  }

  @override
  Future<RendezVous> createRendezVous(RendezVous rdv) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: _headers,
        body: jsonEncode(_rendezVousToJson(rdv)),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return _rendezVousFromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          'Erreur lors de la création du rendez-vous: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Erreur de connexion au serveur: $e');
    }
  }

  @override
  Future<RendezVous> updateRendezVous(RendezVous rdv) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/${rdv.id}'),
        headers: _headers,
        body: jsonEncode(_rendezVousToJson(rdv)),
      );

      if (response.statusCode == 200) {
        return _rendezVousFromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          'Erreur lors de la mise à jour du rendez-vous: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Erreur de connexion au serveur: $e');
    }
  }

  @override
  Future<void> deleteRendezVous(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/$id'),
        headers: _headers,
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception(
          'Erreur lors de la suppression du rendez-vous: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Erreur de connexion au serveur: $e');
    }
  }

  @override
  Future<RendezVous> updateStatut(String id, String statut) async {
    try {
      final response = await http.patch(
        Uri.parse('$_baseUrl/$id/statut'),
        headers: _headers,
        body: jsonEncode({'statut': statut}),
      );

      if (response.statusCode == 200) {
        return _rendezVousFromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          'Erreur lors de la mise à jour du statut: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Erreur de connexion au serveur: $e');
    }
  }
}
