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
      "areYouSureToDeleteFavoriteItem": "آیا از حذف آیتم از علاقمندی ها مطمئن هستید؟",
      "yes": "بله",
      "no": "خیر",
      "cancel": "لغو",
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
      "areYouSureToDeleteFavoriteItem": "Are you sure you want to remove the item from favorites?",
      "yes": "Yes",
      "no": "No",
      "cancel": "Cancel",
    },
  };
}
