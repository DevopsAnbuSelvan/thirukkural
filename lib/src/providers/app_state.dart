import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app/theme.dart';
import '../core/constants/app_constants.dart';
import '../data/repositories/kural_repository.dart';
import '../models/kural_model.dart';

class AppState extends ChangeNotifier {
  AppState({
    required KuralRepository repository,
    SharedPreferences? preferences,
  })  : _repository = repository,
        _preferences = preferences;

  static AppState of(BuildContext context) => AppStateScope.of(context);

  static AppState read(BuildContext context) => AppStateScope.read(context);

  final KuralRepository _repository;
  SharedPreferences? _preferences;

  bool _initializing = false;
  bool _ready = false;
  String? _errorMessage;
  ThemeMode _themeMode = ThemeMode.system;
  AppFontSize _fontSize = AppFontSize.medium;
  final Set<int> _favoriteNumbers = <int>{};

  KuralRepository get repository => _repository;
  bool get isInitializing => _initializing;
  bool get isReady => _ready;
  String? get errorMessage => _errorMessage;
  ThemeMode get themeMode => _themeMode;
  AppFontSize get fontSize => _fontSize;
  Set<int> get favoriteNumbers => Set.unmodifiable(_favoriteNumbers);

  Future<void> initialize() async {
    if (_initializing) return;
    _initializing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _preferences ??= await SharedPreferences.getInstance();
      await _repository.initialize();
      await _loadPreferences();
      _ready = true;
    } catch (error, stackTrace) {
      debugPrint('Initialization failed: $error\n$stackTrace');
      _ready = false;
      _errorMessage = 'தரவை ஏற்ற முடியவில்லை. மீண்டும் முயற்சிக்கவும்.';
    } finally {
      _initializing = false;
      notifyListeners();
    }
  }

  Future<void> retry() => initialize();

  Future<void> _loadPreferences() async {
    final prefs = _preferences;
    if (prefs == null) return;

    final themeValue = prefs.getString(AppConstants.themeModeKey);
    _themeMode = switch (themeValue) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };

    _fontSize = AppFontSizeX.fromStorage(
      prefs.getString(AppConstants.fontSizeKey),
    );

    final favorites = prefs.getStringList(AppConstants.favoritesKey) ?? const [];
    _favoriteNumbers
      ..clear()
      ..addAll(
        favorites.map(int.tryParse).whereType<int>(),
      );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await _preferences?.setString(AppConstants.themeModeKey, value);
  }

  Future<void> setFontSize(AppFontSize size) async {
    _fontSize = size;
    notifyListeners();
    await _preferences?.setString(AppConstants.fontSizeKey, size.storageValue);
  }

  bool isFavorite(int number) => _favoriteNumbers.contains(number);

  Future<void> toggleFavorite(int number) async {
    if (_favoriteNumbers.contains(number)) {
      _favoriteNumbers.remove(number);
    } else {
      _favoriteNumbers.add(number);
    }
    notifyListeners();
    await _persistFavorites();
  }

  List<KuralModel> getFavoriteKurals() {
    if (!_ready) return const [];
    final favorites = _favoriteNumbers.toList()..sort();
    return favorites
        .map(_repository.getKural)
        .whereType<KuralModel>()
        .toList(growable: false);
  }

  Future<void> _persistFavorites() async {
    try {
      final values = _favoriteNumbers.map((e) => e.toString()).toList()..sort();
      await _preferences?.setStringList(AppConstants.favoritesKey, values);
    } catch (error) {
      debugPrint('Failed to persist favorites: $error');
    }
  }
}

class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({
    super.key,
    required AppState state,
    required super.child,
  }) : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'AppStateScope not found');
    return scope!.notifier!;
  }

  static AppState read(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'AppStateScope not found');
    return scope!.notifier!;
  }
}
