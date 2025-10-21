import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/tracks_list/init_tracks_list_hive.dart';

Future<void> hiveInitialization() async {
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  Hive.registerAdapter(AudioItemEntityAdapter());
  await initTracksListHive(Hive);
}
