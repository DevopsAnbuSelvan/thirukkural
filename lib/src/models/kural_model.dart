class KuralModel {
  const KuralModel({
    required this.number,
    required this.line1,
    required this.line2,
    required this.translation,
    required this.mv,
    required this.sp,
    required this.mk,
    required this.explanation,
    required this.couplet,
    required this.transliteration1,
    required this.transliteration2,
  });

  final int number;
  final String line1;
  final String line2;
  final String translation;
  final String mv;
  final String sp;
  final String mk;
  final String explanation;
  final String couplet;
  final String transliteration1;
  final String transliteration2;

  factory KuralModel.fromJson(Map<String, dynamic> json) {
    return KuralModel(
      number: _asInt(json['Number']),
      line1: _asString(json['Line1']),
      line2: _asString(json['Line2']),
      translation: _asString(json['Translation']),
      mv: _asString(json['mv']),
      sp: _asString(json['sp']),
      mk: _asString(json['mk']),
      explanation: _asString(json['explanation']),
      couplet: _asString(json['couplet']),
      transliteration1: _asString(json['transliteration1']),
      transliteration2: _asString(json['transliteration2']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Number': number,
      'Line1': line1,
      'Line2': line2,
      'Translation': translation,
      'mv': mv,
      'sp': sp,
      'mk': mk,
      'explanation': explanation,
      'couplet': couplet,
      'transliteration1': transliteration1,
      'transliteration2': transliteration2,
    };
  }

  String get tamilText => '$line1\n$line2';

  String get transliteration =>
      '$transliteration1\n$transliteration2'.trim();

  String get copyText => 'குறள் $number\n\n$line1\n$line2';

  String get shareText => 'திருக்குறள்\n\nகுறள் $number\n\n$line1\n$line2';

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
