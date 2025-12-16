import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/network/api_config.dart';
import '../domain/patient.dart';
import '../domain/patient_repository.dart';

/// Implémentation du repository des patients
/// Connecté au backend Spring Boot via API REST
class PatientRepositoryImpl implements PatientRepository {
  final String _baseUrl = '${ApiConfig.baseUrl}/api/patients';

  Map<String, String> get _headers => {'Content-Type': 'application/json'};

  /// Convertit la réponse JSON du backend en objet Patient
  Patient _patientFromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'].toString(),
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      dateNaissance: json['dateNaissance'] != null
          ? DateTime.parse(json['dateNaissance'])
          : DateTime.now(),
      numeroSecuriteSociale: json['numeroSecuriteSociale'] ?? '',
      coutTotal: (json['coutTotal'] ?? 0).toDouble(),
      soinIds: json['soinIds'] != null
          ? List<String>.from(json['soinIds'].map((e) => e.toString()))
          : [],
    );
  }

  /// Convertit un Patient en JSON pour le backend
  Map<String, dynamic> _patientToJson(Patient patient) {
    return {
      if (patient.id.isNotEmpty && patient.id != '0')
        'id': int.tryParse(patient.id),
      'nom': patient.nom,
      'prenom': patient.prenom,
      'dateNaissance': patient.dateNaissance.toIso8601String().split('T')[0],
      'numeroSecuriteSociale': patient.numeroSecuriteSociale,
      'coutTotal': patient.coutTotal,
    };
  }

  @override
  Future<List<Patient>> getPatients() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl), headers: _headers);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => _patientFromJson(json)).toList();
      } else {
        throw Exception(
          'Erreur lors de la récupération des patients: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Erreur de connexion au serveur: $e');
    }
  }

  @override
  Future<Patient> getPatient(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/$id'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return _patientFromJson(jsonDecode(response.body));
      } else {
        throw Exception('Patient non trouvé: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion au serveur: $e');
    }
  }

  @override
  Future<Patient> createPatient(Patient patient) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: _headers,
        body: jsonEncode(_patientToJson(patient)),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return _patientFromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          'Erreur lors de la création du patient: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Erreur de connexion au serveur: $e');
    }
  }

  @override
  Future<Patient> updatePatient(Patient patient) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/${patient.id}'),
        headers: _headers,
        body: jsonEncode(_patientToJson(patient)),
      );

      if (response.statusCode == 200) {
        return _patientFromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          'Erreur lors de la mise à jour du patient: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Erreur de connexion au serveur: $e');
    }
  }

  @override
  Future<void> deletePatient(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/$id'),
        headers: _headers,
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception(
          'Erreur lors de la suppression du patient: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Erreur de connexion au serveur: $e');
    }
  }

  @override
  Future<List<Patient>> searchPatients(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/search?q=$query'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => _patientFromJson(json)).toList();
      } else {
        throw Exception('Erreur lors de la recherche: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion au serveur: $e');
    }
  }
}
