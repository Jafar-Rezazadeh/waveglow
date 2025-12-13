import 'package:flutter/material.dart';

enum SortTypeEnum { byModifiedDate, byTitle, byFavorite }

enum HiveBoxEnum {
  musicPlayer("music_player"),
  tracksList("tracks_list_directory_box");

  final String value;
  const HiveBoxEnum(this.value);
}

enum LanguageEnum {
  persian("fa_IR", Locale("fa", "IR")),
  english("en_US", Locale("en", "US"));

  final String value;
  final Locale locale;
  const LanguageEnum(this.value, this.locale);
}
