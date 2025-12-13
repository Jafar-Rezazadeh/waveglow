import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waveglow/core/constants/enums.dart';
import 'package:waveglow/features/settings/settings_export.dart';
import 'package:waveglow/shared/widgets/custom_drop_down_menu.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});
  late final _controller = Get.find<SettingsStateController>();

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
    return Obx(
      () => CustomDropDownMenu(
        label: "theme".tr,
        hintText: "selectTheme".tr,
        initialSelect: _controller.settings?.themeMode,
        items: [
          DropdownMenuEntry(
            value: ThemeMode.dark,
            label: ThemeMode.dark.name.capitalizeFirst ?? "",
          ),
          DropdownMenuEntry(
            value: ThemeMode.light,
            label: ThemeMode.light.name.capitalizeFirst ?? "",
          ),
        ],
        onSelected: (value) {
          if (value != null) {
            _controller.changeTheme(value);
          }
        },
      ),
    );
  }

  Widget _languageSelector() {
    return CustomDropDownMenu(
      label: "language".tr,
      hintText: "selectLanguage".tr,
      initialSelect: _controller.settings?.languageEnum,
      items: LanguageEnum.values
          .map((e) => DropdownMenuEntry(value: e, label: e.name.capitalizeFirst ?? e.name))
          .toList(),
      onSelected: (value) => _controller.changeLocale(value),
    );
  }
}
