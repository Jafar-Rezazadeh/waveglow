import 'package:flutter/material.dart';
import 'package:flutter_handy_utils/extensions/widgets_separator_.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:waveglow/core/constants/app_sizes.dart';
import 'package:waveglow/core/constants/svgs.dart';
import 'package:waveglow/core/theme/color_palette.dart';

class MainNavigatorWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int index) onTab;
  MainNavigatorWidget({
    super.key,
    required this.currentIndex,
    required this.onTab,
  });

  late final _colorPalette = Get.theme.extension<AppColorPalette>()!;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      alignment: Alignment.topCenter,
      constraints: const BoxConstraints(minHeight: 100),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _colorPalette.backgroundLow,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMax),
      ),
      child: Column(
        children: [
          _home(),
          _playlist(),
          _likedMusics(),
          _settings(),
        ].withGapInBetween(10),
      ),
    );
  }

  Widget _home() {
    return _navigatorItem(
      svgPath: AssetSvgs.home,
      onTap: () {
        onTab(0);
      },
      active: currentIndex == 0,
    );
  }

  _navigatorItem({
    required String svgPath,
    required VoidCallback onTap,
    required bool active,
  }) {
    return IconButton(
      onPressed: onTap,
      icon: SvgPicture.asset(
        svgPath,
        colorFilter: ColorFilter.mode(
          active ? _colorPalette.surface : _colorPalette.neutral400.withValues(alpha: 0.5),
          BlendMode.srcIn,
        ),
      ),
    );
  }

  Widget _playlist() {
    return _navigatorItem(
      svgPath: AssetSvgs.musicPlaylist,
      onTap: () {
        onTab(1);
      },
      active: currentIndex == 1,
    );
  }

  Widget _likedMusics() {
    return _navigatorItem(
      svgPath: AssetSvgs.heart,
      onTap: () {
        onTab(2);
      },
      active: currentIndex == 2,
    );
  }

  Widget _settings() {
    return _navigatorItem(
      svgPath: AssetSvgs.setting,
      onTap: () {
        onTab(3);
      },
      active: currentIndex == 3,
    );
  }
}
