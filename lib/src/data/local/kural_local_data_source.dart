import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/date_utils.dart';
import '../../models/chapter_model.dart';
import '../../models/kural_model.dart';
import '../../models/section_model.dart';

class KuralLocalDataSource {
  List<KuralModel>? _kurals;
  List<ChapterModel>? _chapters;
  List<SectionModel>? _sections;
  Map<int, KuralModel>? _kuralByNumber;
  Map<int, ChapterModel>? _chapterById;
  bool _loaded = false;

  bool get isLoaded => _loaded;

  Future<void> loadKurals() async {
    if (_kurals != null) return;

    final raw = await rootBundle.loadString(AppConstants.kuralAssetPath);
    final decoded = json.decode(raw);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Invalid Thirukkural JSON root');
    }

    final list = decoded['kural'];
    if (list is! List) {
      throw const FormatException('Missing kural array');
    }

    final parsed = <KuralModel>[];
    for (final item in list) {
      if (item is Map<String, dynamic>) {
        parsed.add(KuralModel.fromJson(item));
      } else if (item is Map) {
        parsed.add(KuralModel.fromJson(Map<String, dynamic>.from(item)));
      }
    }

    parsed.sort((a, b) => a.number.compareTo(b.number));
    _kurals = List.unmodifiable(parsed);
    _kuralByNumber = {
      for (final kural in parsed) kural.number: kural,
    };
  }

  Future<void> loadChapters() async {
    if (_chapters != null && _sections != null) return;

    final raw = await rootBundle.loadString(AppConstants.chaptersAssetPath);
    final decoded = json.decode(raw);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Invalid chapters JSON root');
    }

    final sectionsRaw = decoded['sections'];
    final chaptersRaw = decoded['chapters'];
    if (sectionsRaw is! List || chaptersRaw is! List) {
      throw const FormatException('Missing sections or chapters arrays');
    }

    final sections = <SectionModel>[];
    for (final item in sectionsRaw) {
      if (item is Map<String, dynamic>) {
        sections.add(SectionModel.fromJson(item));
      } else if (item is Map) {
        sections.add(SectionModel.fromJson(Map<String, dynamic>.from(item)));
      }
    }

    final chapters = <ChapterModel>[];
    for (final item in chaptersRaw) {
      if (item is Map<String, dynamic>) {
        chapters.add(ChapterModel.fromJson(item));
      } else if (item is Map) {
        chapters.add(ChapterModel.fromJson(Map<String, dynamic>.from(item)));
      }
    }

    chapters.sort((a, b) => a.number.compareTo(b.number));
    _sections = List.unmodifiable(sections);
    _chapters = List.unmodifiable(chapters);
    _chapterById = {
      for (final chapter in chapters) chapter.id: chapter,
    };
  }

  Future<void> loadSections() async {
    await loadChapters();
  }

  Future<void> initialize() async {
    if (_loaded) return;
    await Future.wait([loadKurals(), loadChapters()]);
    _loaded = true;
  }

  List<KuralModel> getAllKurals() {
    _ensureLoaded();
    return _kurals!;
  }

  KuralModel? getKuralByNumber(int number) {
    _ensureLoaded();
    return _kuralByNumber![number];
  }

  ChapterModel? getChapterById(int id) {
    _ensureLoaded();
    return _chapterById![id];
  }

  List<KuralModel> getChapterKurals(int chapterId) {
    final chapter = getChapterById(chapterId);
    if (chapter == null) return const [];
    return getAllKurals()
        .where(
          (kural) =>
              kural.number >= chapter.startKural &&
              kural.number <= chapter.endKural,
        )
        .toList(growable: false);
  }

  List<ChapterModel> getAllChapters() {
    _ensureLoaded();
    return _chapters!;
  }

  List<ChapterModel> getChaptersBySection(int sectionId) {
    return getAllChapters()
        .where((chapter) => chapter.sectionId == sectionId)
        .toList(growable: false);
  }

  List<SectionModel> getAllSections() {
    _ensureLoaded();
    return _sections!;
  }

  List<KuralModel> searchKurals(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return const [];

    final asNumber = int.tryParse(trimmed);
    if (asNumber != null) {
      final exact = getKuralByNumber(asNumber);
      return exact == null ? const [] : [exact];
    }

    final needle = trimmed.toLowerCase();
    return getAllKurals().where((kural) {
      return kural.number.toString().contains(needle) ||
          kural.line1.toLowerCase().contains(needle) ||
          kural.line2.toLowerCase().contains(needle) ||
          kural.translation.toLowerCase().contains(needle) ||
          kural.mv.toLowerCase().contains(needle) ||
          kural.sp.toLowerCase().contains(needle) ||
          kural.mk.toLowerCase().contains(needle) ||
          kural.explanation.toLowerCase().contains(needle) ||
          kural.couplet.toLowerCase().contains(needle) ||
          kural.transliteration1.toLowerCase().contains(needle) ||
          kural.transliteration2.toLowerCase().contains(needle);
    }).toList(growable: false);
  }

  KuralModel getRandomKural([Random? random]) {
    final kurals = getAllKurals();
    if (kurals.isEmpty) {
      throw StateError('No kurals available');
    }
    final rng = random ?? Random();
    return kurals[rng.nextInt(kurals.length)];
  }

  KuralModel getDailyKural([DateTime? date]) {
    final kurals = getAllKurals();
    if (kurals.isEmpty) {
      throw StateError('No kurals available');
    }
    final dayIndex = AppDateUtils.dayOfYear(date ?? DateTime.now());
    final index = (dayIndex - 1) % kurals.length;
    return kurals[index];
  }

  void _ensureLoaded() {
    if (!_loaded || _kurals == null || _chapters == null || _sections == null) {
      throw StateError('Local data has not been loaded yet');
    }
  }
}
