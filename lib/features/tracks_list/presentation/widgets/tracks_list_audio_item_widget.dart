import 'package:flutter/material.dart';
import 'package:flutter_handy_utils/flutter_handy_utils.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

class TracksListAudioItemWidget extends StatelessWidget {
  final AudioItemEntity item;
  final String dirId;
  TracksListAudioItemWidget({super.key, required this.item, required this.dirId});

  late final _colorPalette = Get.theme.extension<AppColorPalette>()!;
  late final _controller = Get.find<TracksListStateController>();
  late final _musicPlayer = Get.find<MusicPlayerService>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppSizes.borderRadius1),
      onTap: () => _controller.playTrack(item, dirId),
      child: Obx(
        () => AnimatedContainer(
          duration: Durations.long2,
          curve: Curves.easeInOut,
          decoration: _decoration(),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _albumArt(),
              Gap(AppSizes.spaceNormal),
              _favoriteToggleButton(),
              Gap(AppSizes.spaceLarge),
              _titleAndSubTitle(),
              const Spacer(),
              _duration(),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _decoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(AppSizes.borderRadius1),
      gradient: _isCurrentlyPlaying
          ? LinearGradient(colors: [_colorPalette.primary900, _colorPalette.primary800])
          : null,
    );
  }

  Widget _favoriteToggleButton() {
    return IconButton(
      onPressed: () => _controller.toggleAudioFavorite(
        TracksListToggleAudioFavoriteParams(dirId: dirId, audioPath: item.path),
      ),
      icon: SvgPicture.asset(
        AssetSvgs.heart,
        colorFilter: ColorFilter.mode(
          item.isFavorite ? _colorPalette.hotMagenta : _colorPalette.neutral100,
          BlendMode.srcIn,
        ),
      ),
    );
  }

  bool get _isCurrentlyPlaying => _musicPlayer.currentTrack?.path == item.path;

  Widget _albumArt() {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppSizes.borderRadius1)),
      width: 39,
      height: 39,
      child: item.albumArt == null
          ? Container(color: _colorPalette.neutral600, child: Icon(Icons.music_note_outlined))
          : Image.memory(item.albumArt!, fit: BoxFit.cover),
    );
  }

  Widget _titleAndSubTitle() {
    final artistNames = item.artistsNames?.join(" , ").ellipsSize(maxLength: 50) ?? "";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          item.trackName?.ellipsSize(maxLength: 50) ?? "",
          style: TextStyle(fontSize: AppSizes.fontSizeMedium),
        ),
        if (artistNames.isNotEmpty)
          Text(
            artistNames,
            style: TextStyle(fontSize: AppSizes.fontSizeSmall, color: _colorPalette.neutral300),
          ),
      ],
    );
  }

  Widget _duration() {
    final duration = Duration(seconds: item.durationInSeconds ?? 0);
    return Text(
      "${duration.inMinutes.remainder(60).toString().padLeft(2, "0")}:${duration.inSeconds.remainder(60).toString().padLeft(2, "0")}",
    );
  }
}
