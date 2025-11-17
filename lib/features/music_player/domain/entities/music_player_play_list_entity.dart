import 'package:waveglow/core/core_exports.dart';

class MusicPlayerPlayListEntity {
  /// [id] can be a directoryId or any key that represent where the audios belongs
  final String id;
  final List<AudioItemEntity> audios;

  MusicPlayerPlayListEntity({required this.id, required this.audios});
}
