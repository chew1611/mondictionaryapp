import 'dart:convert';
import 'package:flutter/services.dart';
import 'translation_model.dart';

class TranslationService {
  Future<List<Translation>> loadTranslations() async {
    final String response = await rootBundle.loadString('assets/translations.json');
    final data = await json.decode(response);
    List<Translation> translations = (data['translations'] as List)
        .map((item) => Translation.fromJson(item))
        .toList();
    return translations;
  }
}
