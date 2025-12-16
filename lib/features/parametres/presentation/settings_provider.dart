import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_provider.g.dart';

/// Clés pour le stockage persistant
class SettingsKeys {
  static const String language = 'settings_language';
  static const String dateFormat = 'settings_date_format';
  static const String pushNotifications = 'settings_push_notifications';
  static const String emailNotifications = 'settings_email_notifications';
  static const String smsNotifications = 'settings_sms_notifications';
  static const String twoFactorEnabled = 'settings_two_factor_enabled';
}

/// Modèle pour les paramètres utilisateur
class UserSettings {
  final String language;
  final String dateFormat;
  final bool pushNotifications;
  final bool emailNotifications;
  final bool smsNotifications;
  final bool twoFactorEnabled;

  const UserSettings({
    this.language = 'Français',
    this.dateFormat = 'DD/MM/YYYY',
    this.pushNotifications = true,
    this.emailNotifications = true,
    this.smsNotifications = false,
    this.twoFactorEnabled = false,
  });

  UserSettings copyWith({
    String? language,
    String? dateFormat,
    bool? pushNotifications,
    bool? emailNotifications,
    bool? smsNotifications,
    bool? twoFactorEnabled,
  }) {
    return UserSettings(
      language: language ?? this.language,
      dateFormat: dateFormat ?? this.dateFormat,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      smsNotifications: smsNotifications ?? this.smsNotifications,
      twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
    );
  }
}

@Riverpod(keepAlive: true)
class SettingsNotifier extends _$SettingsNotifier {
  SharedPreferences? _prefs;

  @override
  UserSettings build() {
    // Charger les paramètres sauvegardés au démarrage
    _loadSettings();
    return const UserSettings();
  }

  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();
    
    final language = _prefs?.getString(SettingsKeys.language) ?? 'Français';
    final dateFormat = _prefs?.getString(SettingsKeys.dateFormat) ?? 'DD/MM/YYYY';
    final pushNotifications = _prefs?.getBool(SettingsKeys.pushNotifications) ?? true;
    final emailNotifications = _prefs?.getBool(SettingsKeys.emailNotifications) ?? true;
    final smsNotifications = _prefs?.getBool(SettingsKeys.smsNotifications) ?? false;
    final twoFactorEnabled = _prefs?.getBool(SettingsKeys.twoFactorEnabled) ?? false;
    
    state = UserSettings(
      language: language,
      dateFormat: dateFormat,
      pushNotifications: pushNotifications,
      emailNotifications: emailNotifications,
      smsNotifications: smsNotifications,
      twoFactorEnabled: twoFactorEnabled,
    );
  }

  Future<void> setLanguage(String language) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs?.setString(SettingsKeys.language, language);
    state = state.copyWith(language: language);
  }

  Future<void> setDateFormat(String format) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs?.setString(SettingsKeys.dateFormat, format);
    state = state.copyWith(dateFormat: format);
  }

  Future<void> setPushNotifications(bool value) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs?.setBool(SettingsKeys.pushNotifications, value);
    state = state.copyWith(pushNotifications: value);
  }

  Future<void> setEmailNotifications(bool value) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs?.setBool(SettingsKeys.emailNotifications, value);
    state = state.copyWith(emailNotifications: value);
  }

  Future<void> setSmsNotifications(bool value) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs?.setBool(SettingsKeys.smsNotifications, value);
    state = state.copyWith(smsNotifications: value);
  }

  Future<void> setTwoFactorEnabled(bool value) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs?.setBool(SettingsKeys.twoFactorEnabled, value);
    state = state.copyWith(twoFactorEnabled: value);
  }

  /// Réinitialise tous les paramètres
  Future<void> resetSettings() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs?.clear();
    state = const UserSettings();
  }
}
