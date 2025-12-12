import 'package:flutter/services.dart';

class TagLib {
  final _methodChannel = MethodChannel("com.waveglow.methodChannel/audio_meta_data");
  final _methodName = "getMetaData";

  Future<Map<String, dynamic>> getMetaData(String audioPath) async {
    final result = await _methodChannel.invokeMethod<Map>(_methodName, audioPath);

    final map = result?.map((key, value) => MapEntry(key.toString(), value)) ?? {};

    return map;
  }
}
