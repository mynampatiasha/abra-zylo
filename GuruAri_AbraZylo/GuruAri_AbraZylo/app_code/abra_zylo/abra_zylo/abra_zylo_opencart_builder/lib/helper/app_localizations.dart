import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../../constants/app_constants.dart';

class AppLocalizations {
  final Locale? locale;
  static AppLocalizations? instance;

  AppLocalizations(this.locale);

  AppLocalizations._init(this.locale) {
    instance = this;
  }

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _ApplicationLocalizationDelegate();

  Map<String, String>? localizedStrings;

  Future<bool> load() async {
    String jsonString = await rootBundle
        .loadString('assets/languages/${locale?.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });
    return true;
  }

  String translate(String key) {
    return localizedStrings?[key] ?? key;
  }
}

class _ApplicationLocalizationDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _ApplicationLocalizationDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppConstant.supportedLanguages.contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations._init(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_ApplicationLocalizationDelegate old) => false;
}

extension StringExtension on String {
  String localized() {
    return AppLocalizations.instance?.translate(this) ?? this;
  }
}
