import 'package:go_router/go_router.dart';

import '../features/chapters/chapter_detail_screen.dart';
import '../features/chapters/chapters_screen.dart';
import '../features/favorites/favorites_screen.dart';
import '../features/home/home_screen.dart';
import '../features/kural/kural_detail_screen.dart';
import '../features/search/search_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/splash/splash_screen.dart';
import '../providers/app_state.dart';
import 'shell_scaffold.dart';

GoRouter createRouter(AppState appState) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: appState,
    redirect: (context, state) {
      final loc = state.matchedLocation;
      final ready = appState.isReady;

      if (!ready && loc != '/') {
        return '/';
      }
      if (ready && loc == '/') {
        return '/home';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return ShellScaffold(
            location: state.matchedLocation,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: '/chapters',
            pageBuilder: (context, state) {
              final section = int.tryParse(
                state.uri.queryParameters['section'] ?? '',
              );
              return NoTransitionPage(
                child: ChaptersScreen(initialSectionId: section),
              );
            },
          ),
          GoRoute(
            path: '/search',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SearchScreen(),
            ),
          ),
          GoRoute(
            path: '/favorites',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: FavoritesScreen(),
            ),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsScreen(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/chapter/:id',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          return ChapterDetailScreen(chapterId: id);
        },
      ),
      GoRoute(
        path: '/kural/:number',
        builder: (context, state) {
          final number =
              int.tryParse(state.pathParameters['number'] ?? '') ?? 0;
          return KuralDetailScreen(number: number);
        },
      ),
    ],
  );
}
