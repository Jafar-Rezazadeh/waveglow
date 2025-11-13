import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:waveglow/features/tracks_list/init_tracks_list_hive.dart';
import 'package:waveglow/shared/models/audio_item_model.dart';

Future<void> hiveInitialization() async {
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  Hive.registerAdapter(AudioItemModelAdapter());
  await initTracksListHive(Hive);
}
