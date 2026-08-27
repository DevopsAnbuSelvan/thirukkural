import 'package:flutter_test/flutter_test.dart';
import 'package:thirukkural/src/core/utils/date_utils.dart';
import 'package:thirukkural/src/data/local/kural_local_data_source.dart';
import 'package:thirukkural/src/models/chapter_model.dart';
import 'package:thirukkural/src/models/kural_model.dart';
import 'package:thirukkural/src/models/section_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('KuralModel', () {
    final sample = {
      'Number': 1,
      'Line1': 'அகர முதல எழுத்தெல்லாம் ஆதி',
      'Line2': 'பகவன் முதற்றே உலகு.',
      'Translation': 'English translation',
      'mv': 'mv text',
      'sp': 'sp text',
      'mk': 'mk text',
      'explanation': 'explanation text',
      'couplet': 'couplet text',
      'transliteration1': 'Akara',
      'transliteration2': 'Pakavan',
    };

    test('fromJson maps exact JSON keys', () {
      final model = KuralModel.fromJson(sample);
      expect(model.number, 1);
      expect(model.line1, 'அகர முதல எழுத்தெல்லாம் ஆதி');
      expect(model.line2, 'பகவன் முதற்றே உலகு.');
      expect(model.translation, 'English translation');
      expect(model.mv, 'mv text');
      expect(model.sp, 'sp text');
      expect(model.mk, 'mk text');
      expect(model.explanation, 'explanation text');
      expect(model.couplet, 'couplet text');
      expect(model.transliteration1, 'Akara');
      expect(model.transliteration2, 'Pakavan');
    });

    test('toJson restores exact JSON keys', () {
      final json = KuralModel.fromJson(sample).toJson();
      expect(json.keys, containsAll([
        'Number',
        'Line1',
        'Line2',
        'Translation',
        'mv',
        'sp',
        'mk',
        'explanation',
        'couplet',
        'transliteration1',
        'transliteration2',
      ]));
      expect(json['Number'], 1);
      expect(json['Line1'], sample['Line1']);
    });

    test('fromJson handles missing values safely', () {
      final model = KuralModel.fromJson({'Number': '12'});
      expect(model.number, 12);
      expect(model.line1, isEmpty);
      expect(model.translation, isEmpty);
    });
  });

  group('ChapterModel / SectionModel', () {
    test('chapter fromJson/toJson', () {
      final chapter = ChapterModel.fromJson({
        'id': 1,
        'sectionId': 1,
        'number': 1,
        'nameTamil': 'கடவுள் வாழ்த்து',
        'nameEnglish': 'The Praise of God',
        'startKural': 1,
        'endKural': 10,
      });
      expect(chapter.paddedNumber, '01');
      expect(chapter.toJson()['nameTamil'], 'கடவுள் வாழ்த்து');
    });

    test('section fromJson/toJson', () {
      final section = SectionModel.fromJson({
        'id': 1,
        'nameTamil': 'அறத்துப்பால்',
        'nameEnglish': 'Virtue',
      });
      expect(section.toJson()['id'], 1);
    });
  });

  group('AppDateUtils', () {
    test('dayOfYear is 1-based', () {
      expect(AppDateUtils.dayOfYear(DateTime(2026, 1, 1)), 1);
      expect(AppDateUtils.dayOfYear(DateTime(2026, 1, 2)), 2);
    });
  });

  group('KuralLocalDataSource', () {
    late KuralLocalDataSource dataSource;

    setUp(() async {
      dataSource = KuralLocalDataSource();
      await dataSource.initialize();
    });

    test('loads 1330 kurals, 133 chapters, 3 sections', () {
      expect(dataSource.getAllKurals(), hasLength(1330));
      expect(dataSource.getAllChapters(), hasLength(133));
      expect(dataSource.getAllSections(), hasLength(3));
    });

    test('kural numbers are unique and complete 1-1330', () {
      final numbers = dataSource.getAllKurals().map((k) => k.number).toList();
      expect(numbers.toSet(), hasLength(1330));
      expect(numbers.first, 1);
      expect(numbers.last, 1330);
    });

    test('lookup by number', () {
      final kural = dataSource.getKuralByNumber(1);
      expect(kural, isNotNull);
      expect(kural!.line1, isNotEmpty);
      expect(dataSource.getKuralByNumber(9999), isNull);
    });

    test('search by text and number', () {
      final byNumber = dataSource.searchKurals('1330');
      expect(byNumber, hasLength(1));
      expect(byNumber.first.number, 1330);

      final byText = dataSource.searchKurals('அற');
      expect(byText, isNotEmpty);
    });

    test('random kural returns a valid kural', () {
      final kural = dataSource.getRandomKural();
      expect(kural.number, inInclusiveRange(1, 1330));
    });

    test('daily kural is deterministic', () {
      final date = DateTime(2026, 1, 1);
      final a = dataSource.getDailyKural(date);
      final b = dataSource.getDailyKural(date);
      expect(a.number, b.number);
      expect(a.number, 1);
    });

    test('chapter filtering and mapping', () {
      final chapters = dataSource.getChaptersBySection(1);
      expect(chapters, hasLength(38));
      expect(dataSource.getChaptersBySection(2), hasLength(70));
      expect(dataSource.getChaptersBySection(3), hasLength(25));

      final chapter = dataSource.getChapterById(1)!;
      final kurals = dataSource.getChapterKurals(1);
      expect(kurals, hasLength(10));
      expect(kurals.first.number, chapter.startKural);
      expect(kurals.last.number, chapter.endKural);
    });
  });
}
