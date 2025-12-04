import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:waveglow/core/core_exports.dart';

class CustomDropDownMenu<T> extends StatelessWidget {
  final List<DropdownMenuEntry<T>> items;
  final T? initialSelect;
  final void Function(T? value)? onSelected;
  final String? label;
  final String? hintText;
  CustomDropDownMenu({
    super.key,
    required this.items,
    required this.onSelected,
    this.label,
    this.initialSelect,
    this.hintText,
  });

  late final _colorPalette = Get.theme.extension<AppColorPalette>()!;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        ?(label != null ? Text(label!, style: TextStyle(color: _colorPalette.neutral400)) : null),
        DropdownMenu<T>(
          hintText: hintText,
          width: 150.sp,
          initialSelection: initialSelect,
          trailingIcon: Icon(Icons.keyboard_arrow_down),
          selectedTrailingIcon: Icon(Icons.keyboard_arrow_up),
          dropdownMenuEntries: items,
          onSelected: onSelected,
        ),
      ],
    );
  }
}
