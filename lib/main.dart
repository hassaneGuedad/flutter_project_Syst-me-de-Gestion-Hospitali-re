import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/localization/app_localizations.dart';

Future<void> _initLocales() async {
  // Initialise les locales pour fr, en, ar
  for (final locale in ['fr_FR', 'fr', 'en_US', 'en', 'ar']) {
    try {
      await initializeDateFormatting(locale, null);
    } catch (_) {
      // Ignore les erreurs pour les locales non disponibles
    }
  }
  Intl.defaultLocale = 'fr_FR';
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initLocales();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final themeMode = ref.watch(themeNotifierProvider);
    final language = ref.watch(languageProvider);
    
    // Définit la locale pour Intl en fonction de la langue
    _updateIntlLocale(language);

    return MaterialApp.router(
      title: 'Hôpital Central - Système de Gestion',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      // Support des langues
      locale: _getLocale(language),
      supportedLocales: const [
        Locale('fr', 'FR'),
        Locale('en', 'US'),
        Locale('ar', ''),
      ],
    );
  }
  
  /// Retourne la Locale correspondant à la langue
  Locale _getLocale(String language) {
    switch (language) {
      case 'English':
        return const Locale('en', 'US');
      case 'العربية':
        return const Locale('ar', '');
      default:
        return const Locale('fr', 'FR');
    }
  }
  
  /// Met à jour la locale Intl pour les formats de date/nombre
  void _updateIntlLocale(String language) {
    switch (language) {
      case 'English':
        Intl.defaultLocale = 'en_US';
        break;
      case 'العربية':
        Intl.defaultLocale = 'ar';
        break;
      default:
        Intl.defaultLocale = 'fr_FR';
    }
  }
}
