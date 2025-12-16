import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/auth_providers.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/items/presentation/items_list_screen.dart';
import '../../features/items/presentation/item_detail_screen.dart';
import '../../features/patients/presentation/patients_list_screen.dart';
import '../../features/patients/presentation/patient_detail_screen.dart';
import '../../features/patients/presentation/patient_form_screen.dart';
import '../../features/services/presentation/services_list_screen.dart';
import '../../features/soins/presentation/soins_list_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/rendez_vous/presentation/rendez_vous_screen.dart';
import '../../features/rapports/presentation/rapports_screen.dart';
import '../../features/finance/presentation/finance_screen.dart';
import '../../features/parametres/presentation/parametres_screen.dart';
import '../layout/main_layout.dart';

part 'app_router.g.dart';

class _RouterRefreshStream extends ChangeNotifier {
  _RouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  // Écoute du flux d'auth pour déclencher les redirections et rafraîchir le router
  final authState = ref.watch(authStateProvider);
  final authStateChanges = ref.watch(authStateProvider.stream);
  final refreshListenable = _RouterRefreshStream(authStateChanges);
  ref.onDispose(refreshListenable.dispose);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: refreshListenable,
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return MainLayout(currentRoute: state.uri.path, child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/items',
            builder: (context, state) => const ItemsListScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return ItemDetailScreen(id: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/patients',
            builder: (context, state) => const PatientsListScreen(),
            routes: [
              GoRoute(
                path: 'new',
                builder: (context, state) => const PatientFormScreen(),
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return PatientDetailScreen(id: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/services',
            builder: (context, state) => const ServicesListScreen(),
          ),
          GoRoute(
            path: '/soins',
            builder: (context, state) => const SoinsListScreen(),
          ),
          GoRoute(
            path: '/notifications',
            builder: (context, state) => const NotificationsScreen(),
          ),
          GoRoute(
            path: '/rendez-vous',
            builder: (context, state) => const RendezVousScreen(),
          ),
          GoRoute(
            path: '/rapports',
            builder: (context, state) => const RapportsScreen(),
          ),
          GoRoute(
            path: '/finance',
            builder: (context, state) => const FinanceScreen(),
          ),
          GoRoute(
            path: '/parametres',
            builder: (context, state) => const ParametresScreen(),
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      if (authState.isLoading) {
        // Ne pas rediriger pendant le chargement, surtout en dehors de /login
        return null;
      }

      final user = authState.valueOrNull;
      final isLoggedIn = user != null;
      final isLoginRoute = state.uri.path == '/login';

      if (isLoggedIn && isLoginRoute) {
        return '/';
      }
      if (!isLoggedIn && !isLoginRoute) {
        return '/login';
      }
      return null;
    },
  );
}
