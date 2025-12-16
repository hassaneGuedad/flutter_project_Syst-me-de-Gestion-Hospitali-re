import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/network/api_config.dart';
import '../domain/service.dart';
import '../domain/service_repository.dart';

/// Implémentation du repository des services
/// Connecté au backend Spring Boot via API REST
class ServiceRepositoryImpl implements ServiceRepository {
  final String _baseUrl = '${ApiConfig.baseUrl}/api/services';

  /// Headers pour les requêtes HTTP
  Map<String, String> get _headers => {'Content-Type': 'application/json'};

  /// Convertit la réponse JSON du backend en objet Service
  Service _serviceFromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'].toString(),
      nom: json['nom'] ?? '',
      budgetMensuel: (json['budgetMensuel'] ?? 0).toDouble(),
      budgetAnnuel: (json['budgetAnnuel'] ?? 0).toDouble(),
      coutActuel: (json['coutActuel'] ?? 0).toDouble(),
    );
  }

  /// Convertit un Service en JSON pour le backend
  Map<String, dynamic> _serviceToJson(Service service) {
    return {
      if (service.id.isNotEmpty && service.id != '0')
        'id': int.tryParse(service.id),
      'nom': service.nom,
      'budgetMensuel': service.budgetMensuel,
      'budgetAnnuel': service.budgetAnnuel,
      'coutActuel': service.coutActuel,
    };
  }

  @override
  Future<List<Service>> getServices() async {
    try {
      print('�🔵🔵 APPEL API: GET $_baseUrl');
      final response = await http.get(Uri.parse(_baseUrl), headers: _headers);
      print('🟢🟢🟢 REPONSE: ${response.statusCode}');
      print('🟢🟢🟢 BODY: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        final services = jsonList
            .map((json) => _serviceFromJson(json))
            .toList();
        print('🟢🟢🟢 SERVICES CHARGES: ${services.length}');
        return services;
      } else {
        print('🔴🔴🔴 ERREUR STATUS: ${response.statusCode}');
        throw Exception(
          'Erreur lors de la récupération des services: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('🔴🔴🔴 ERREUR EXCEPTION: $e');
      throw Exception('Erreur de connexion au serveur: $e');
    }
  }

  @override
  Future<Service> getService(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/$id'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return _serviceFromJson(jsonDecode(response.body));
      } else {
        throw Exception('Service non trouvé: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion au serveur: $e');
    }
  }

  @override
  Future<Service> createService(Service service) async {
    try {
      final jsonData = _serviceToJson(service);
      print('�🟡🟡 CREATION SERVICE: POST $_baseUrl');
      print('🟡🟡🟡 DONNEES ENVOYEES: $jsonData');

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: _headers,
        body: jsonEncode(jsonData),
      );

      print('🟡🟡🟡 REPONSE STATUS: ${response.statusCode}');
      print('🟡🟡🟡 REPONSE BODY: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final createdService = _serviceFromJson(jsonDecode(response.body));
        print('🟢🟢🟢 SERVICE CREE AVEC ID: ${createdService.id}');
        return createdService;
      } else {
        print('🔴🔴🔴 ECHEC CREATION: ${response.statusCode}');
        throw Exception(
          'Erreur lors de la création du service: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('🔴🔴🔴 EXCEPTION CREATION: $e');
      throw Exception('Erreur de connexion au serveur: $e');
    }
  }

  @override
  Future<Service> updateService(Service service) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/${service.id}'),
        headers: _headers,
        body: jsonEncode(_serviceToJson(service)),
      );

      if (response.statusCode == 200) {
        return _serviceFromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          'Erreur lors de la mise à jour du service: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Erreur de connexion au serveur: $e');
    }
  }

  @override
  Future<void> deleteService(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/$id'),
        headers: _headers,
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception(
          'Erreur lors de la suppression du service: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Erreur de connexion au serveur: $e');
    }
  }

  @override
  Future<double> getBudgetRestant(String serviceId) async {
    final service = await getService(serviceId);
    return service.budgetMensuel - service.coutActuel;
  }

  @override
  Future<double> getCoutActuel(String serviceId) async {
    final service = await getService(serviceId);
    return service.coutActuel;
  }
}
