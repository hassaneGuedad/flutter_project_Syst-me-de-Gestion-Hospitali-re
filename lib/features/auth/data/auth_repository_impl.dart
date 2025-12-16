import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/auth_repository.dart';
import '../domain/user.dart';
import '../../../core/network/api_config.dart';

/// Implémentation du repository d'authentification
/// TOUTES les vérifications sont faites côté BACKEND
/// Le frontend n'a AUCUNE logique de validation de mot de passe
class AuthRepositoryImpl implements AuthRepository {
  final _controller = StreamController<User?>.broadcast();
  User? _currentUser;
  String? _token;

  @override
  Stream<User?> get authStateChanges => _controller.stream;

  @override
  User? get currentUser => _currentUser;

  /// Token JWT actuel
  String? get token => _token;

  @override
  Future<User> login(String email, String password) async {
    // Appel au backend pour l'authentification
    // AUCUNE vérification de mot de passe côté frontend
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _token = data['token'];
      
      final user = User(
        id: data['email'],
        email: data['email'],
        name: '${data['prenom'] ?? ''} ${data['nom'] ?? ''}'.trim(),
        role: data['role'],
      );
      
      _currentUser = user;
      _controller.add(user);
      return user;
    } else if (response.statusCode == 428) {
      // 428 Precondition Required - Mot de passe à configurer
      final error = jsonDecode(response.body);
      throw PasswordSetupRequiredException(
        error['message'] ?? 'Veuillez configurer votre mot de passe',
        email: error['email'] ?? email,
      );
    } else if (response.statusCode == 401) {
      // 401 Unauthorized - Identifiants incorrects
      final error = jsonDecode(response.body);
      throw AuthException(
        error['message'] ?? 'Identifiants incorrects',
        statusCode: 401,
      );
    } else {
      throw AuthException(
        'Erreur serveur: ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }
  }

  /// Configure le mot de passe initial (premier login)
  Future<User> setupPassword(String email, String newPassword) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/api/auth/setup-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'newPassword': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _token = data['token'];
      
      final user = User(
        id: data['email'],
        email: data['email'],
        name: '${data['prenom'] ?? ''} ${data['nom'] ?? ''}'.trim(),
        role: data['role'],
      );
      
      _currentUser = user;
      _controller.add(user);
      return user;
    } else if (response.statusCode == 409) {
      // Mot de passe déjà configuré
      final error = jsonDecode(response.body);
      throw AuthException(
        error['message'] ?? 'Mot de passe déjà configuré',
        statusCode: 409,
      );
    } else {
      throw AuthException(
        'Erreur lors de la configuration du mot de passe',
        statusCode: response.statusCode,
      );
    }
  }

  /// Change le mot de passe via le backend
  /// Invalide automatiquement les anciens tokens
  Future<void> changePassword(String currentPassword, String newPassword) async {
    if (_token == null) {
      throw AuthException('Non authentifié', statusCode: 401);
    }

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/api/auth/change-password'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode({
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      // Mot de passe changé avec succès
      // Le token actuel est invalidé, il faut se reconnecter
      _token = null;
      _currentUser = null;
      _controller.add(null);
    } else if (response.statusCode == 401) {
      final error = jsonDecode(response.body);
      throw AuthException(
        error['message'] ?? 'Mot de passe actuel incorrect',
        statusCode: 401,
      );
    } else {
      throw AuthException(
        'Erreur lors du changement de mot de passe',
        statusCode: response.statusCode,
      );
    }
  }

  /// Vérifie si le token est toujours valide
  Future<bool> verifyToken() async {
    if (_token == null) return false;

    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/auth/verify'),
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        // Token invalide (expiré ou mot de passe changé)
        _token = null;
        _currentUser = null;
        _controller.add(null);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> logout() async {
    try {
      if (_token != null) {
        await http.post(
          Uri.parse('${ApiConfig.baseUrl}/api/auth/logout'),
          headers: {
            'Authorization': 'Bearer $_token',
          },
        );
      }
    } catch (e) {
      // Ignore les erreurs de déconnexion
    } finally {
      _token = null;
      _currentUser = null;
      _controller.add(null);
    }
  }
}

/// Exception personnalisée pour l'authentification
class AuthException implements Exception {
  final String message;
  final int statusCode;

  AuthException(this.message, {required this.statusCode});

  @override
  String toString() => message;
}

/// Exception pour mot de passe à configurer (premier login)
class PasswordSetupRequiredException implements Exception {
  final String message;
  final String email;

  PasswordSetupRequiredException(this.message, {required this.email});

  @override
  String toString() => message;
}

