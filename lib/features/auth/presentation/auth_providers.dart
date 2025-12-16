import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_repository_impl.dart';
import '../domain/auth_repository.dart';
import '../domain/user.dart';

/// ════════════════════════════════════════════════════════════════════════════
/// PROVIDERS D'AUTHENTIFICATION - SÉCURITÉ BACKEND
/// ════════════════════════════════════════════════════════════════════════════
/// 
/// IMPORTANT: Toute l'authentification est gérée par le BACKEND
/// Le frontend NE vérifie JAMAIS le mot de passe lui-même
/// Le backend retourne:
/// - 200 OK + token JWT si les identifiants sont corrects
/// - 401 Unauthorized si les identifiants sont incorrects
/// - 403 Forbidden si le token est invalide/expiré
/// ════════════════════════════════════════════════════════════════════════════

/// Provider pour le repository d'authentification (singleton)
final authRepositoryProvider = Provider<AuthRepositoryImpl>((ref) {
  return AuthRepositoryImpl();
});

/// Provider pour l'état d'authentification (stream)
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

/// Provider pour le contrôleur de login
final loginControllerProvider = StateNotifierProvider<LoginControllerNotifier, AsyncValue<void>>((ref) {
  return LoginControllerNotifier(ref);
});

/// Notifier pour gérer la logique de connexion
/// AUCUNE validation de mot de passe côté frontend
class LoginControllerNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;
  
  LoginControllerNotifier(this._ref) : super(const AsyncData(null));

  /// Tentative de connexion via le BACKEND
  /// Le backend vérifie le mot de passe avec BCrypt
  /// Le frontend ne fait QUE transmettre les identifiants
  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    
    try {
      // Appel au backend - SEUL le backend décide si l'accès est autorisé
      await _ref.read(authRepositoryProvider).login(email, password);
      state = const AsyncData(null);
    } on PasswordSetupRequiredException catch (e) {
      // 428 - Mot de passe à configurer (premier login)
      state = AsyncError(e, StackTrace.current);
    } on AuthException catch (e) {
      // Erreur d'authentification (401, 403, etc.)
      state = AsyncError(e.message, StackTrace.current);
    } catch (e, stack) {
      // Erreur réseau ou autre
      state = AsyncError('Erreur de connexion au serveur', stack);
    }
  }

  /// Changement de mot de passe via le BACKEND
  /// Invalide automatiquement tous les anciens tokens
  Future<bool> changePassword(String currentPassword, String newPassword) async {
    try {
      await _ref.read(authRepositoryProvider).changePassword(currentPassword, newPassword);
      return true;
    } on AuthException {
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Déconnexion
  Future<void> logout() async {
    state = const AsyncLoading();
    try {
      await _ref.read(authRepositoryProvider).logout();
      state = const AsyncData(null);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }
}

