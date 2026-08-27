import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thirukkural/src/data/local/kural_local_data_source.dart';
import 'package:thirukkural/src/data/repositories/kural_repository.dart';
import 'package:thirukkural/src/providers/app_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('favorites store only kural numbers', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final repository = KuralRepository(KuralLocalDataSource());
    final state = AppState(repository: repository, preferences: prefs);

    await state.initialize();
    expect(state.isReady, isTrue);

    await state.toggleFavorite(1);
    await state.toggleFavorite(25);
    expect(state.isFavorite(1), isTrue);
    expect(state.isFavorite(25), isTrue);
    expect(state.getFavoriteKurals().map((k) => k.number), [1, 25]);

    final stored = prefs.getStringList('favorite_kural_numbers');
    expect(stored, ['1', '25']);

    await state.toggleFavorite(1);
    expect(state.isFavorite(1), isFalse);
  });
}
