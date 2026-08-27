import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../providers/app_state.dart';
import 'routes.dart';
import 'theme.dart';

class ThirukkuralApp extends StatefulWidget {
  const ThirukkuralApp({
    super.key,
    required this.appState,
  });

  final AppState appState;

  @override
  State<ThirukkuralApp> createState() => _ThirukkuralAppState();
}

class _ThirukkuralAppState extends State<ThirukkuralApp> {
  late final GoRouter _router = createRouter(widget.appState);

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      state: widget.appState,
      child: ListenableBuilder(
        listenable: widget.appState,
        builder: (context, _) {
          return MaterialApp.router(
            title: 'திருக்குறள்',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(widget.appState.fontSize),
            darkTheme: AppTheme.dark(widget.appState.fontSize),
            themeMode: widget.appState.themeMode,
            routerConfig: _router,
          );
        },
      ),
    );
  }
}
