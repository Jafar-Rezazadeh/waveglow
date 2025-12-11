import 'package:flutter/services.dart';

class CustomAudioMetaDataExtractor {
  final methodChannel = MethodChannel("com.waveglow.methodChannel/audio_meta_data");
  final _methodName = "getMetaData";

  Future<void> getMetaData(String audioPath) async {
    try {
      final result = await methodChannel.invokeMethod(_methodName, audioPath);
      print(result.toString());
    } catch (e) {
      print(e);
    }
  }
}
