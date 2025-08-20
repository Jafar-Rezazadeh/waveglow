#include "audio_event_streamer.h"

AudioEventStreamer::AudioEventStreamer() {}
AudioEventStreamer::~AudioEventStreamer()
{
    stop();
}

std::unique_ptr<flutter::StreamHandlerError<flutter::EncodableValue>> AudioEventStreamer::OnListenInternal(
    const flutter::EncodableValue *arguments,
    std::unique_ptr<flutter::EventSink<flutter::EncodableValue>> &&events)
{

    sink_ = std::move(events);
    running_ = true;

    // Start the audio capture + FFT in a background thread
    if (arguments && std::holds_alternative<std::string>(*arguments))
    {
        const std::string &arg_str = std::get<std::string>(*arguments);

        // Check if argument equals "bands"
        if (arg_str == "all-bars")
        {
            stream_thread_ = std::thread([this]()
                                         {
                                             if (!InitializeWASAPILoopback())
                                             {
                                                 return; // If WASAPI setup failed, exit thread
                                             }

                                             CaptureAndSendAllBars(); });
        }
        else if (arg_str == "perceptual-bands")
        {
            stream_thread_ = std::thread([this]()
                                         {
                                             if (!InitializeWASAPILoopback())
                                             {
                                                 return; // If WASAPI setup failed, exit thread
                                             }

                                             CaptureAndSendBandsAsMap(); });
        }

        else
        {
            sink_->Error("Argument is NOT bands\n");
        }
    }
    else
    {
        sink_->Error("Argument is missing or not a string\n");
    }

    return nullptr;
}

std::unique_ptr<flutter::StreamHandlerError<flutter::EncodableValue>> AudioEventStreamer::OnCancelInternal(
    const flutter::EncodableValue *arguments)
{
    stop();
    return nullptr;
}

void AudioEventStreamer::stop()
{
    running_ = false;
    if (stream_thread_.joinable())
    {
        stream_thread_.join();
    }
    sink_ = nullptr;

    if (pAudioClient)
    {
        pAudioClient->Stop();
        pAudioClient->Release();
        pAudioClient = nullptr;
    }
    if (pCaptureClient)
    {
        pCaptureClient->Release();
        pCaptureClient = nullptr;
    }
    if (pDevice)
    {
        pDevice->Release();
        pDevice = nullptr;
    }
    CoUninitialize(); // Shut down COM for this thread
}

bool AudioEventStreamer::InitializeWASAPILoopback()
{
    HRESULT hr = CoInitialize(nullptr); // Initialize COM
    IMMDeviceEnumerator *pEnumerator = nullptr;

    // Create device enumerator
    hr = CoCreateInstance(__uuidof(MMDeviceEnumerator), nullptr, CLSCTX_ALL,
                          __uuidof(IMMDeviceEnumerator), (void **)&pEnumerator);
    if (FAILED(hr))
        return false;

    // Get the default playback device
    hr = pEnumerator->GetDefaultAudioEndpoint(eRender, eConsole, &pDevice);
    if (FAILED(hr))
        return false;

    // Activate the audio client
    hr = pDevice->Activate(__uuidof(IAudioClient), CLSCTX_ALL, nullptr, (void **)&pAudioClient);
    if (FAILED(hr))
        return false;

    // Get audio format
    hr = pAudioClient->GetMixFormat(&pwfx);
    if (FAILED(hr))
        return false;

    // Initialize audio client for loopback mode
    hr = pAudioClient->Initialize(AUDCLNT_SHAREMODE_SHARED,
                                  AUDCLNT_STREAMFLAGS_LOOPBACK,
                                  0, 0, pwfx, nullptr);
    if (FAILED(hr))
        return false;

    // Get capture client
    hr = pAudioClient->GetService(__uuidof(IAudioCaptureClient), (void **)&pCaptureClient);
    if (FAILED(hr))
        return false;

    pEnumerator->Release();

    // Start capturing
    pAudioClient->Start();
    return true;
}

void AudioEventStreamer::ApplyHannWindow(std::vector<double> &samples)
{
    size_t N = samples.size();
    for (size_t i = 0; i < N; ++i)
    {
        samples[i] *= 0.5 * (1 - cos(2 * M_PI * i / (N - 1)));
    }
}

void AudioEventStreamer::CaptureAndSendAllBars()
{
    UINT32 packetLength = 0;
    std::vector<float> samples_f(FFT_SIZE);  // Temporary float buffer
    std::vector<double> samples_d(FFT_SIZE); // Double buffer for FFT

    // FFTW setup
    fftw_complex *out = (fftw_complex *)fftw_malloc(sizeof(fftw_complex) * FFT_SIZE);
    fftw_plan plan = fftw_plan_dft_r2c_1d(FFT_SIZE, samples_d.data(), out, FFTW_ESTIMATE);

    // dB normalization parameters
    const double MIN_DB = -60.0; // Quietest level we care about
    const double REF_DB = 0.0;   // Reference (max) level

    while (running_)
    {
        // See if there’s any audio data available
        pCaptureClient->GetNextPacketSize(&packetLength);
        while (packetLength != 0)
        {
            BYTE *pData = nullptr;
            UINT32 numFramesAvailable = 0;
            DWORD flags = 0;

            // Get buffer from WASAPI
            HRESULT hr = pCaptureClient->GetBuffer(&pData, &numFramesAvailable, &flags, nullptr, nullptr);
            if (FAILED(hr) || pData == nullptr || numFramesAvailable == 0)
            {
                pCaptureClient->ReleaseBuffer(0);
                break;
            }

            int numChannels = pwfx->nChannels;
            int samplesToCopy = std::min((int)numFramesAvailable, FFT_SIZE);

            // Copy only the first channel (mono)
            const float *floatData = (const float *)pData;
            for (int i = 0; i < samplesToCopy; ++i)
            {
                samples_f[i] = floatData[i * numChannels];
            }

            pCaptureClient->ReleaseBuffer(numFramesAvailable);

            // Convert float → double
            for (int i = 0; i < samplesToCopy; ++i)
            {
                samples_d[i] = static_cast<double>(samples_f[i]);
            }
            // Zero-fill if less than FFT_SIZE
            for (int i = samplesToCopy; i < FFT_SIZE; ++i)
            {
                samples_d[i] = 0.0;
            }

            // Apply window function
            ApplyHannWindow(samples_d);

            // Perform FFT
            fftw_execute(plan);

            // Compute magnitude spectrum
            // std::vector<double> magnitudes(FFT_SIZE / 2);
            // for (int i = 0; i < FFT_SIZE / 2; ++i)
            // {
            //     magnitudes[i] = sqrt(out[i][0] * out[i][0] + out[i][1] * out[i][1]) / (FFT_SIZE / 2);
            // }
            // Compute magnitudes in dB and normalize to 0–1
            std::vector<double> magnitudes(FFT_SIZE / 2);
            for (int i = 0; i < FFT_SIZE / 2; ++i)
            {
                double mag = sqrt(out[i][0] * out[i][0] + out[i][1] * out[i][1]) / (FFT_SIZE / 2);
                double dbVal = 20.0 * log10(mag + 1e-12); // Convert to dB, avoid log(0)
                if (dbVal < MIN_DB)
                    dbVal = MIN_DB; // Clamp low
                if (dbVal > REF_DB)
                    dbVal = REF_DB;                                   // Clamp high
                magnitudes[i] = (dbVal - MIN_DB) / (REF_DB - MIN_DB); // Normalize 0–1
            }
            // Boost higher frequencies visually
            int boostStart = 10; // start boosting after this bar index
            for (int i = boostStart; i < magnitudes.size(); ++i)
            {
                double boostFactor = 1.0 + ((double)(i - boostStart) / (magnitudes.size() - boostStart)) * 0.8;
                magnitudes[i] *= boostFactor;
                if (magnitudes[i] > 1.0)
                    magnitudes[i] = 1.0; // clamp
            }

            flutter::EncodableList barData;
            barData.reserve(magnitudes.size());
            for (size_t i = 0; i < magnitudes.size(); ++i)
            {
                barData.push_back(flutter::EncodableValue(magnitudes[i]));
            }

            // Send to Flutter via EventChannel
            if (sink_)
            {
                sink_->Success(flutter::EncodableValue(barData));
            }

            // Check for more data
            pCaptureClient->GetNextPacketSize(&packetLength);
        }
        std::this_thread::sleep_for(std::chrono::milliseconds(15)); // ~66 FPS
    }

    // Cleanup FFT resources
    fftw_destroy_plan(plan);
    fftw_free(out);
}

void AudioEventStreamer::CaptureAndSendBandsAsMap()
{
    UINT32 packetLength = 0;
    std::vector<float> samples_f(FFT_SIZE);
    std::vector<double> samples_d(FFT_SIZE);

    // FFTW setup
    fftw_complex *out = (fftw_complex *)fftw_malloc(sizeof(fftw_complex) * FFT_SIZE);
    fftw_plan plan = fftw_plan_dft_r2c_1d(FFT_SIZE, samples_d.data(), out, FFTW_ESTIMATE);

    // dB normalization parameters
    const double MIN_DB = -60.0;
    const double REF_DB = 0.0;

    // Define perceptual bands
    struct BandDef
    {
        const char *name;
        double low;
        double high;
    };
    static const BandDef bands[] = {
        {"Sub-bass", 20.0, 60.0},
        {"Bass", 60.0, 250.0},
        {"Low-mid", 250.0, 500.0},
        {"Mid", 500.0, 2000.0},
        {"High-mid", 2000.0, 4000.0},
        {"Presence", 4000.0, 6000.0},
        {"Brilliance", 6000.0, 20000.0}};

    int numBands = (int)std::size(bands);

    // Smoothing buffers
    std::vector<double> smoothedBands(numBands, 0.0);
    double smoothedLoudness = 0.0;

    // Smoothing factors
    const double attack = 0.5; // fast rise
    const double decay = 0.2;  // slow fall

    while (running_)
    {
        pCaptureClient->GetNextPacketSize(&packetLength);
        while (packetLength != 0)
        {
            BYTE *pData = nullptr;
            UINT32 numFramesAvailable = 0;
            DWORD flags = 0;

            HRESULT hr = pCaptureClient->GetBuffer(&pData, &numFramesAvailable, &flags, nullptr, nullptr);
            if (FAILED(hr) || pData == nullptr || numFramesAvailable == 0)
            {
                pCaptureClient->ReleaseBuffer(0);
                break;
            }

            int numChannels = pwfx->nChannels;
            int samplesToCopy = std::min((int)numFramesAvailable, FFT_SIZE);

            // Copy mono
            const float *floatData = (const float *)pData;
            for (int i = 0; i < samplesToCopy; ++i)
                samples_f[i] = floatData[i * numChannels];

            pCaptureClient->ReleaseBuffer(numFramesAvailable);

            // Convert float → double and zero-pad
            for (int i = 0; i < samplesToCopy; ++i)
                samples_d[i] = static_cast<double>(samples_f[i]);
            for (int i = samplesToCopy; i < FFT_SIZE; ++i)
                samples_d[i] = 0.0;

            // Apply window
            ApplyHannWindow(samples_d);

            // Perform FFT
            fftw_execute(plan);

            // Compute normalized magnitudes
            std::vector<double> magnitudes(FFT_SIZE / 2);
            for (int i = 0; i < FFT_SIZE / 2; ++i)
            {
                double mag = sqrt(out[i][0] * out[i][0] + out[i][1] * out[i][1]) / (FFT_SIZE / 2);
                double dbVal = 20.0 * log10(mag + 1e-12);
                if (dbVal < MIN_DB)
                    dbVal = MIN_DB;
                if (dbVal > REF_DB)
                    dbVal = REF_DB;
                magnitudes[i] = (dbVal - MIN_DB) / (REF_DB - MIN_DB);
            }

            // Compute band energies
            std::vector<double> bandValues;
            bandValues.reserve(numBands);

            int numBins = FFT_SIZE / 2;
            double sampleRate = pwfx->nSamplesPerSec;

            for (auto &band : bands)
            {
                int binLow = static_cast<int>(band.low * FFT_SIZE / sampleRate);
                int binHigh = static_cast<int>(band.high * FFT_SIZE / sampleRate);
                if (binLow < 0)
                    binLow = 0;
                if (binHigh >= numBins)
                    binHigh = numBins - 1;

                double sum = 0.0;
                int count = 0;
                for (int i = binLow; i <= binHigh; ++i)
                {
                    sum += magnitudes[i];
                    ++count;
                }
                double avg = (count > 0) ? (sum / count) : 0.0;
                bandValues.push_back(avg);
            }

            // Compute overall loudness = average of all magnitudes
            double loudness = 0.0;
            for (double m : magnitudes)
                loudness += m;
            loudness /= magnitudes.size();

            // ---- Apply smoothing ----
            for (int i = 0; i < numBands; i++)
            {
                double newVal = bandValues[i];
                if (newVal > smoothedBands[i])
                    smoothedBands[i] = smoothedBands[i] * (1.0 - attack) + newVal * attack;
                else
                    smoothedBands[i] = smoothedBands[i] * (1.0 - decay) + newVal * decay;
            }

            if (loudness > smoothedLoudness)
                smoothedLoudness = smoothedLoudness * (1.0 - attack) + loudness * attack;
            else
                smoothedLoudness = smoothedLoudness * (1.0 - decay) + loudness * decay;

            // ---- Send map to Flutter ----
            flutter::EncodableMap bandMap;
            for (int i = 0; i < numBands; i++)
            {
                bandMap[flutter::EncodableValue(std::string(bands[i].name))] =
                    flutter::EncodableValue(smoothedBands[i]);
            }
            bandMap[flutter::EncodableValue("Loudness")] =
                flutter::EncodableValue(smoothedLoudness);

            if (sink_)
                sink_->Success(flutter::EncodableValue(bandMap));

            pCaptureClient->GetNextPacketSize(&packetLength);
        }
        std::this_thread::sleep_for(std::chrono::milliseconds(15)); // ~66 FPS
    }

    fftw_destroy_plan(plan);
    fftw_free(out);
}
