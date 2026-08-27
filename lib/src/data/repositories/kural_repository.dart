import '../local/kural_local_data_source.dart';
import '../../models/chapter_model.dart';
import '../../models/kural_model.dart';
import '../../models/section_model.dart';

class KuralRepository {
  KuralRepository(this._dataSource);

  final KuralLocalDataSource _dataSource;

  Future<void> initialize() => _dataSource.initialize();

  bool get isReady => _dataSource.isLoaded;

  List<KuralModel> getKurals() => _dataSource.getAllKurals();

  KuralModel? getKural(int number) => _dataSource.getKuralByNumber(number);

  List<ChapterModel> getChapters() => _dataSource.getAllChapters();

  ChapterModel? getChapter(int id) => _dataSource.getChapterById(id);

  List<KuralModel> getChapterKurals(int chapterId) =>
      _dataSource.getChapterKurals(chapterId);

  List<ChapterModel> getChaptersBySection(int sectionId) =>
      _dataSource.getChaptersBySection(sectionId);

  List<SectionModel> getSections() => _dataSource.getAllSections();

  List<KuralModel> search(String query) => _dataSource.searchKurals(query);

  KuralModel getRandomKural() => _dataSource.getRandomKural();

  KuralModel getDailyKural() => _dataSource.getDailyKural();
}
