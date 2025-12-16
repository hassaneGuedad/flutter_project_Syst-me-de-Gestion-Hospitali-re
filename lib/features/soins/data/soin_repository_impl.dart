import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/network/api_config.dart';
import '../domain/soin.dart';
import '../domain/soin_repository.dart';

/// Implémentation du repository des soins
/// Connecté au backend Spring Boot via API REST
class SoinRepositoryImpl implements SoinRepository {
  final String _baseUrl = '${ApiConfig.baseUrl}/api/soins';

  Map<String, String> get _headers => {'Content-Type': 'application/json'};

  /// Convertit la réponse JSON du backend en objet Soin
  Soin _soinFromJson(Map<String, dynamic> json) {
    return Soin(
      id: json['id'].toString(),
      patientId:
          json['patient']?['id']?.toString() ??
          json['patientId']?.toString() ??
          '',
      serviceId:
          json['service']?['id']?.toString() ??
          json['serviceId']?.toString() ??
          '',
      typeSoin: json['typeSoin'] ?? '',
      cout: (json['cout'] ?? 0).toDouble(),
      dateSoin: json['dateSoin'] != null
          ? DateTime.parse(json['dateSoin'])
          : DateTime.now(),
      description: json['description'],
    );
  }

  /// Convertit un Soin en JSON pour le backend
  Map<String, dynamic> _soinToJson(Soin soin) {
    return {
      if (soin.id.isNotEmpty && soin.id != '0') 'id': int.tryParse(soin.id),
      'patient': {'id': int.tryParse(soin.patientId)},
      'service': {'id': int.tryParse(soin.serviceId)},
      'typeSoin': soin.typeSoin,
      'cout': soin.cout,
      'dateSoin': soin.dateSoin.toIso8601String(),
      'description': soin.description,
    };
  }

  @override
  Future<List<Soin>> getSoins() async {
    try {
      print('📡 GET $_baseUrl');
      final response = await http.get(Uri.parse(_baseUrl), headers: _headers);
      print('📥 Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => _soinFromJson(json)).toList();
      } else {
        throw Exception(
          'Erreur lors de la récupération des soins: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Erreur de connexion au serveur: $e');
    }
  }

  @override
  Future<Soin> getSoin(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/$id'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return _soinFromJson(jsonDecode(response.body));
      } else {
        throw Exception('Soin non trouvé: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion au serveur: $e');
    }
  }

  @override
  Future<Soin> createSoin(Soin soin) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: _headers,
        body: jsonEncode(_soinToJson(soin)),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return _soinFromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          'Erreur lors de la création du soin: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Erreur de connexion au serveur: $e');
    }
  }

  @override
  Future<Soin> updateSoin(Soin soin) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/${soin.id}'),
        headers: _headers,
        body: jsonEncode(_soinToJson(soin)),
      );

      if (response.statusCode == 200) {
        return _soinFromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          'Erreur lors de la mise à jour du soin: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Erreur de connexion au serveur: $e');
    }
  }

  @override
  Future<void> deleteSoin(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/$id'),
        headers: _headers,
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception(
          'Erreur lors de la suppression du soin: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Erreur de connexion au serveur: $e');
    }
  }

  @override
  Future<List<Soin>> getSoinsByPatient(String patientId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/patient/$patientId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => _soinFromJson(json)).toList();
      } else {
        throw Exception(
          'Erreur lors de la récupération des soins: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Erreur de connexion au serveur: $e');
    }
  }

  @override
  Future<List<Soin>> getSoinsByService(String serviceId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/service/$serviceId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => _soinFromJson(json)).toList();
      } else {
        throw Exception(
          'Erreur lors de la récupération des soins: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Erreur de connexion au serveur: $e');
    }
  }
}
