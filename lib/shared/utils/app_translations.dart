import 'package:get/get.dart';
import 'package:waveglow/core/constants/enums.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    LanguageEnum.persian.value: {
      "delete": "حذف",
      "favorites": "علاقمندی ها",
      "theme": "تم",
      "language": "زبان",
      "selectLanguage": "انتخاب زبان",
      "selectTheme": "انتخاب تم",
    },
    LanguageEnum.english.value: {
      "delete": "Delete",
      "favorites": "Favorites",
      "theme": "Theme",
      "language": "Language",
      "selectLanguage": "Select Language",
      "selectTheme": "Select Theme",
    },
  };
}
