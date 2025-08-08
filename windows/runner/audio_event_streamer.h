#pragma once
#ifndef NOMINMAX
#define NOMINMAX
#endif
#include <flutter/method_channel.h>
#include <flutter/event_channel.h>
#include <flutter/standard_method_codec.h>
#include <thread>
#include <atomic>
#include <vector>
#include <string>
#include <chrono>
#include <mmdeviceapi.h>
#include <audioclient.h>
#include <fftw3.h>
#include <corecrt_math_defines.h>
#include <algorithm>

class AudioEventStreamer : public flutter::StreamHandler<flutter::EncodableValue>
{
private:
    // Number of audio samples used for each FFT
    const int FFT_SIZE = 1024;

    // Flutter's EventSink to send data to Dart
    std::unique_ptr<flutter::EventSink<flutter::EncodableValue>> sink_;

    // Background thread for capturing audio & processing FFT
    std::thread stream_thread_;

    // Flag to stop the capture loop
    std::atomic<bool> running_{false};

    // WASAPI COM interface pointers
    IMMDevice *pDevice = nullptr;
    IAudioClient *pAudioClient = nullptr;
    IAudioCaptureClient *pCaptureClient = nullptr;
    WAVEFORMATEX *pwfx = nullptr;

    // Initialize WASAPI loopback capture
    bool InitializeWASAPILoopback();

    void ApplyHannWindow(std::vector<double> &samples);
    void CaptureAndSend();

    // Stop capturing and clean up resources
    void stop();

public:
    // Called when Dart starts listening to the EventChannel
    std::unique_ptr<flutter::StreamHandlerError<flutter::EncodableValue>> OnListenInternal(
        const flutter::EncodableValue *arguments,
        std::unique_ptr<flutter::EventSink<flutter::EncodableValue>> &&events) override;

    // Called when Dart cancels the EventChannel subscription
    std::unique_ptr<flutter::StreamHandlerError<flutter::EncodableValue>> OnCancelInternal(
        const flutter::EncodableValue *arguments) override;

    AudioEventStreamer(/* args */);
    ~AudioEventStreamer();
};
