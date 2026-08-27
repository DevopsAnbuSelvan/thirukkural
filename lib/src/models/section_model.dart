class SectionModel {
  const SectionModel({
    required this.id,
    required this.nameTamil,
    required this.nameEnglish,
  });

  final int id;
  final String nameTamil;
  final String nameEnglish;

  factory SectionModel.fromJson(Map<String, dynamic> json) {
    return SectionModel(
      id: _asInt(json['id']),
      nameTamil: _asString(json['nameTamil']),
      nameEnglish: _asString(json['nameEnglish']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameTamil': nameTamil,
      'nameEnglish': nameEnglish,
    };
  }

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
