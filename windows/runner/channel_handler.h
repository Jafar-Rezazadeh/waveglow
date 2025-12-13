#pragma once
#include <iostream>
#include "flutter_window.h"
#include <flutter/method_channel.h>
#include <flutter/event_channel.h>
#include <flutter/standard_method_codec.h>
#include "Runner/audio_event_streamer.h"
#include "audio_meta_data.h"

class CustomFlutterChannelHandler
{
private:
    const std::string eventChannelName = "com.waveglow.eventChannel/live_audio_fft";
    const std::string audioMetaDataChannelName = "com.waveglow.methodChannel/audio_meta_data";

public:
    CustomFlutterChannelHandler(/* args */);
    ~CustomFlutterChannelHandler();

    void init(std::unique_ptr<flutter::FlutterViewController> &flutterController);
    void initEventChannel(std::unique_ptr<flutter::FlutterViewController> &flutterController);
    void initAudioMetaDataMethodChannels(std::unique_ptr<flutter::FlutterViewController> &flutterController);
};
