import 'package:flutter/material.dart';

import 'src/app/app.dart';
import 'src/data/local/kural_local_data_source.dart';
import 'src/data/repositories/kural_repository.dart';
import 'src/providers/app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dataSource = KuralLocalDataSource();
  final repository = KuralRepository(dataSource);
  final appState = AppState(repository: repository);

  runApp(ThirukkuralApp(appState: appState));
}
