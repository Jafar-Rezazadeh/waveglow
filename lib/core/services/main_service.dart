import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/web.dart';
import 'package:super_hot_key/super_hot_key.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/core/services/settings_service.dart';

class MainService extends GetxService {
  final MusicPlayerService _musicPlayerService;
  final SettingsService _settingsService;

  HotKey? _nextMediaHotKey;
  HotKey? _playOrPauseMediaHotKey;
  HotKey? _previousMediaHotKey;
  MainService({
    required MusicPlayerService musicPlayerService,
    required SettingsService settingsService,
  }) : _musicPlayerService = musicPlayerService,
       _settingsService = settingsService;

  @override
  void onInit() {
    super.onInit();
    _setThemeModel();
    _listenKeyboardEvents();
  }

  Future<void> _setThemeModel() async {
    final result = await _settingsService.getSavedData();

    result.fold(
      (failure) => Logger().e(failure.message),
      (settings) => Get.changeThemeMode(settings.themeMode),
    );
  }

  void _listenKeyboardEvents() {
    _nextTrackHotKey();
    _playOrPauseHotKey();
    _previousTracksHotKey();
  }

  Future<void> _nextTrackHotKey() async {
    _nextMediaHotKey = await HotKey.create(
      definition: HotKeyDefinition(key: PhysicalKeyboardKey.mediaTrackNext),
      onPressed: () => _musicPlayerService.goNext(),
    );
  }

  Future<void> _playOrPauseHotKey() async {
    _playOrPauseMediaHotKey = await HotKey.create(
      definition: HotKeyDefinition(key: PhysicalKeyboardKey.mediaPlayPause),
      onPressed: () => _musicPlayerService.playOrPause(),
    );
  }

  Future<void> _previousTracksHotKey() async {
    _previousMediaHotKey = await HotKey.create(
      definition: HotKeyDefinition(key: PhysicalKeyboardKey.mediaTrackPrevious),
      onPressed: () => _musicPlayerService.goPrevious(),
    );
  }

  @override
  void onClose() {
    _nextMediaHotKey?.dispose();
    _playOrPauseMediaHotKey?.dispose();
    _previousMediaHotKey?.dispose();
    super.onClose();
  }
}
