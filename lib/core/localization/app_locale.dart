enum AppLocale { indonesian, english }

extension AppLocaleLabel on AppLocale {
  String get label => switch (this) {
    AppLocale.indonesian => 'Bahasa Indonesia',
    AppLocale.english => 'English',
  };
}
