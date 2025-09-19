import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:waveglow/core/constants/svgs.dart';
import 'package:waveglow/core/theme/color_palette.dart';

class MainTitleBarWidget extends StatelessWidget {
  MainTitleBarWidget({super.key});

  late final _colorPalette = Get.theme.extension<AppColorPalette>()!;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.only(top: 2),
      alignment: Alignment.center,
      height: 44,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(child: MoveWindow()),
          _titleActionButtons(),
        ],
      ),
    );
  }

  Widget _titleActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      textDirection: TextDirection.rtl,
      children: [
        _actionButtonStyle(
          svgPath: AssetSvgs.close,
          showHoverColor: true,
          onTap: () => appWindow.close(),
        ),
        _actionButtonStyle(
          svgPath: AssetSvgs.maximize,
          onTap: () => appWindow.maximizeOrRestore(),
        ),
        _actionButtonStyle(
          svgPath: AssetSvgs.minimize,
          onTap: () => appWindow.minimize(),
        ),
      ],
    );
  }

  Widget _actionButtonStyle({
    required String svgPath,
    required VoidCallback onTap,
    bool showHoverColor = false,
  }) {
    return SizedBox(
      width: 56,
      child: ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(_colorPalette.background),
          alignment: Alignment.center,
          padding: const WidgetStatePropertyAll(EdgeInsets.zero),
          overlayColor: WidgetStateProperty.resolveWith(
            (states) {
              if (states.contains(WidgetState.hovered) && showHoverColor) {
                return _colorPalette.danger;
              }
              return null;
            },
          ),
          shape: const WidgetStatePropertyAll(LinearBorder()),
        ),
        child: SvgPicture.asset(svgPath),
      ),
    );
  }
}
