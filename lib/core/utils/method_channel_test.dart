import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ChannelTest extends GetxController {
  final _eventChannel = const EventChannel("com.waveglow.eventChannel/live_audio_fft");

  StreamSubscription<dynamic>? _eventSubscription;

  final _eventData = RxString("");

  String get eventChannelData => _eventData.value;

  void startListeningToEvent() {
    _eventSubscription = _eventChannel.receiveBroadcastStream().listen(
      (event) {
        _eventData.value = event.toString();
      },
    );
  }

  void stopListeningToEvent() {
    _eventSubscription?.cancel();
    _eventSubscription = null;
  }
}
