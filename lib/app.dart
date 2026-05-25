import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:efootball_fixture_generator/core/theme/app_theme.dart';
import 'package:efootball_fixture_generator/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:efootball_fixture_generator/features/analytics/presentation/screens/analytics_screen.dart';
import 'package:efootball_fixture_generator/features/auth/presentation/providers/auth_provider.dart';
import 'package:efootball_fixture_generator/features/auth/presentation/screens/login_screen.dart';
import 'package:efootball_fixture_generator/features/auth/presentation/screens/profile_screen.dart';
import 'package:efootball_fixture_generator/features/auth/presentation/screens/register_screen.dart';
import 'package:efootball_fixture_generator/features/auth/presentation/screens/public_profile_screen.dart';
import 'package:efootball_fixture_generator/features/ocr_scanner/presentation/screens/ocr_scanner_screen.dart';
import 'package:efootball_fixture_generator/features/quick_tap/presentation/screens/quick_tap_dashboard_screen.dart';
import 'package:efootball_fixture_generator/features/squad/presentation/screens/squad_builder_screen.dart';
import 'package:efootball_fixture_generator/features/tournament/presentation/screens/create_tournament_screen.dart';
import 'package:efootball_fixture_generator/features/tournament/presentation/screens/fixture_list_screen.dart';
import 'package:efootball_fixture_generator/features/tournament/presentation/screens/standings_screen.dart';
import 'package:efootball_fixture_generator/shared/widgets/analytics_tab.dart';
import 'package:efootball_fixture_generator/shared/widgets/home_shell.dart';
import 'package:efootball_fixture_generator/shared/widgets/tournaments_tab.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _tournamentsNavKey = GlobalKey<NavigatorState>(debugLabel: 'tournaments');
final _squadNavKey = GlobalKey<NavigatorState>(debugLabel: 'squad');
final _analyticsNavKey = GlobalKey<NavigatorState>(debugLabel: 'analytics');
final _profileNavKey = GlobalKey<NavigatorState>(debugLabel: 'profile');

// ── Auth change notifier so GoRouter re-runs redirect on login/logout ──
class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(Ref ref) {
    ref.listen(authNotifierProvider, (_, __) => notifyListeners());
    ref.listen(onboardingCompletedProvider, (_, __) => notifyListeners());
  }
}

final _routerNotifierProvider = Provider<_RouterNotifier>((ref) {
  final n = _RouterNotifier(ref);
  ref.onDispose(n.dispose);
  return n;
});

// ── Router ─────────────────────────────────────────────────────
final routerProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(_routerNotifierProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home/tournaments',
    refreshListenable: notifier,
    redirect: (context, state) async {
      // Check onboarding status directly in redirect to keep router stable
      final prefs = await SharedPreferences.getInstance();
      final isFirstLaunch = !(prefs.getBool('onboarding_completed') ?? false);
      final onboardingDone = ref.read(onboardingCompletedProvider);

      if (isFirstLaunch && !onboardingDone) {
        if (state.matchedLocation == '/onboarding') return null;
        return '/onboarding';
      }

      final authState = ref.read(authNotifierProvider);
      if (authState.isLoading) return null;

      final isLoggedIn = authState.valueOrNull != null;
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      if (isLoggedIn && isAuthRoute) return '/home/tournaments';
      if (state.matchedLocation == '/home') return '/home/tournaments';
      
      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/profile/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => PublicProfileScreen(
          userId: state.pathParameters['id']!,
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            HomeShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            navigatorKey: _tournamentsNavKey,
            routes: [
              GoRoute(
                path: '/home/tournaments',
                builder: (context, state) => const TournamentsTab(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _squadNavKey,
            routes: [
              GoRoute(
                path: '/home/squad',
                builder: (context, state) => const SquadBuilderScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _analyticsNavKey,
            routes: [
              GoRoute(
                path: '/home/analytics',
                builder: (context, state) => const AnalyticsTab(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _profileNavKey,
            routes: [
              GoRoute(
                path: '/home/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/tournament/create',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CreateTournamentScreen(),
      ),
      GoRoute(
        path: '/tournament/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) =>
            FixtureListScreen(tournamentId: state.pathParameters['id']!),
        routes: [
          GoRoute(
            path: 'standings',
            builder: (context, state) =>
                StandingsScreen(tournamentId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: 'match/:matchId/scan',
            builder: (context, state) => OcrScannerScreen(
              tournamentId: state.pathParameters['id']!,
              matchId: state.pathParameters['matchId']!,
            ),
          ),
          GoRoute(
            path: 'match/:matchId/quick-tap',
            builder: (context, state) => QuickTapDashboardScreen(
              tournamentId: state.pathParameters['id']!,
              matchId: state.pathParameters['matchId']!,
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/analytics/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) =>
            AnalyticsScreen(tournamentId: state.pathParameters['id']!),
      ),
    ],
  );
});

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'eFootball Fixture Generator',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: router,
    );
  }
}
