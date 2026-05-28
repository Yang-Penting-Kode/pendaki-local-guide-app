// lib/features/settings/data/language_model.dart
// Model data untuk pilihan bahasa. Ditempatkan di feature settings (DDD-Lite).

class LanguageModel {
  final String name;
  final String code;
  final String flagUrl;

  const LanguageModel({
    required this.name,
    required this.code,
    required this.flagUrl,
  });
}
