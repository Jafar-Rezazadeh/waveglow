import 'package:flutter/material.dart';
import 'package:flutter_handy_utils/flutter_handy_utils.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

class TracksListAudioItemWidget extends StatelessWidget {
  final AudioItemEntity item;
  TracksListAudioItemWidget({super.key, required this.item});

  late final _colorPalette = Get.theme.extension<AppColorPalette>()!;
  late final _controller = Get.find<TracksListStateController>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppSizes.borderRadius1),
      onTap: () {
        _controller.playTrack(item);
      },
      child: Container(
        decoration: BoxDecoration(
          color: _colorPalette.backgroundLow,
          borderRadius: BorderRadius.circular(AppSizes.borderRadius1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _leading(),
            const Gap(16),
            IconButton(onPressed: () {}, icon: SvgPicture.asset(AssetSvgs.heart)),
            const Gap(32),
            _titleAndSubTitle(),
            const Spacer(),
            _duration(),
          ],
        ),
      ),
    );
  }

  Widget _titleAndSubTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.trackName?.ellipsSize(maxLength: 50) ?? "",
          style: TextStyle(fontSize: AppSizes.fontSizeMedium),
        ),
        Text(
          item.artistsNames?.join(" , ").ellipsSize(maxLength: 50) ?? "",
          style: TextStyle(fontSize: AppSizes.fontSizeSmall, color: _colorPalette.neutral300),
        ),
      ],
    );
  }

  Widget _leading() {
    return Stack(
      children: [
        _albumArt(),
        // _actionButtons(),
      ],
    );
  }

  Container _albumArt() {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppSizes.borderRadius1)),
      width: 39,
      height: 39,
      child: item.albumArt == null
          ? Container(color: _colorPalette.neutral600)
          : Image.memory(item.albumArt!, fit: BoxFit.cover),
    );
  }

  Widget _duration() {
    final duration = Duration(seconds: item.durationInSeconds ?? 0);
    return Text(
      "${duration.inMinutes.remainder(60).toString().padLeft(2, "0")}:${duration.inSeconds.remainder(60).toString().padLeft(2, "0")}",
    );
  }
}
