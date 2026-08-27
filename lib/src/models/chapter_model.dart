class ChapterModel {
  const ChapterModel({
    required this.id,
    required this.sectionId,
    required this.number,
    required this.nameTamil,
    required this.nameEnglish,
    required this.startKural,
    required this.endKural,
  });

  final int id;
  final int sectionId;
  final int number;
  final String nameTamil;
  final String nameEnglish;
  final int startKural;
  final int endKural;

  factory ChapterModel.fromJson(Map<String, dynamic> json) {
    return ChapterModel(
      id: _asInt(json['id']),
      sectionId: _asInt(json['sectionId']),
      number: _asInt(json['number']),
      nameTamil: _asString(json['nameTamil']),
      nameEnglish: _asString(json['nameEnglish']),
      startKural: _asInt(json['startKural']),
      endKural: _asInt(json['endKural']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sectionId': sectionId,
      'number': number,
      'nameTamil': nameTamil,
      'nameEnglish': nameEnglish,
      'startKural': startKural,
      'endKural': endKural,
    };
  }

  String get paddedNumber => number.toString().padLeft(2, '0');

  String get kuralRangeLabel => 'குறள் $startKural – $endKural';

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value.trim()) ?? 0;
    return 0;
  }

  static String _asString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }
}
