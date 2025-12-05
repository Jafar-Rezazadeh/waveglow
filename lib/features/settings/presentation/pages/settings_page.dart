import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waveglow/shared/widgets/custom_drop_down_menu.dart';

// TODO: implement storing the settings

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.only(top: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 24,
        children: [_themeSelector(), _languageSelector()],
      ),
    );
  }

  Widget _themeSelector() {
    return CustomDropDownMenu(
      label: "theme".capitalizeFirst,
      hintText: "selectTheme",
      initialSelect: Get.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      items: [
        DropdownMenuEntry(value: ThemeMode.dark, label: ThemeMode.dark.name.capitalizeFirst ?? ""),
        DropdownMenuEntry(
          value: ThemeMode.light,
          label: ThemeMode.light.name.capitalizeFirst ?? "",
        ),
      ],
      onSelected: (value) {
        if (value != null) {
          Get.changeThemeMode(value);
        }
      },
    );
  }

  Widget _languageSelector() {
    return CustomDropDownMenu(
      label: "language".capitalizeFirst,
      hintText: "selectLanguage",
      items: [DropdownMenuEntry(value: "value", label: "label")],
      onSelected: (value) {},
    );
  }
}
