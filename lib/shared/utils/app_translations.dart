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
      "pleaseSelectFolder": "لطفا پوشه مورد نظر را انتخاب کنید",
      "favoriteSongsNotSelected": "شما هنوز آهنگ های مورد علاقه تان را انتخاب نکرده اید.",
    },
    LanguageEnum.english.value: {
      "delete": "Delete",
      "favorites": "Favorites",
      "theme": "Theme",
      "language": "Language",
      "selectLanguage": "Select Language",
      "selectTheme": "Select Theme",
      "pleaseSelectFolder": "Please Selected a Folder",
      "favoriteSongsNotSelected": "You haven't chosen your favorite songs yet.",
    },
  };
}
