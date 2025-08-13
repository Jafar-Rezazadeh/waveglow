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
    stream_thread_ = std::thread([this]()
                                 {
            if (!InitializeWASAPILoopback()) {
                return; // If WASAPI setup failed, exit thread
            }
            CaptureAndSendAllBars(); });

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
            std::vector<double> magnitudes(FFT_SIZE / 2);
            for (int i = 0; i < FFT_SIZE / 2; ++i)
            {
                magnitudes[i] = sqrt(out[i][0] * out[i][0] + out[i][1] * out[i][1]) / (FFT_SIZE / 2);
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

void AudioEventStreamer::CaptureAndSend64Bar()
{
    UINT32 packetLength = 0;
    std::vector<float> samples_f(FFT_SIZE);  // Temporary float buffer
    std::vector<double> samples_d(FFT_SIZE); // Double buffer for FFT

    // FFTW setup
    fftw_complex *out = (fftw_complex *)fftw_malloc(sizeof(fftw_complex) * FFT_SIZE);
    fftw_plan plan = fftw_plan_dft_r2c_1d(FFT_SIZE, samples_d.data(), out, FFTW_ESTIMATE);

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
            std::vector<double> magnitudes(FFT_SIZE / 2);
            for (int i = 0; i < FFT_SIZE / 2; ++i)
            {
                magnitudes[i] = sqrt(out[i][0] * out[i][0] + out[i][1] * out[i][1]) / (FFT_SIZE / 2);
            }

            // Downsample FFT bins into 64 bars for visualization
            int bars = 64;
            size_t bin_size = magnitudes.size() / bars;
            flutter::EncodableList barData;
            barData.reserve(bars);
            for (int i = 0; i < bars; ++i)
            {
                double sum = 0;
                for (int j = 0; j < bin_size; ++j)
                {
                    sum += magnitudes[i * bin_size + j];
                }
                barData.push_back(flutter::EncodableValue(sum / bin_size)); // Average magnitude for this bar
            }

            // Send to Flutter via EventChannel
            if (sink_)
            {
                sink_->Success(flutter::EncodableValue(barData));
            }

            // Check for more data
            pCaptureClient->GetNextPacketSize(&packetLength);
        }
        std::this_thread::sleep_for(std::chrono::milliseconds(30)); // ~33 FPS
    }

    // Cleanup FFT resources
    fftw_destroy_plan(plan);
    fftw_free(out);
}

void AudioEventStreamer::CaptureAndSend128WithMoreLowFrequenciesBar()
{
    UINT32 packetLength = 0;
    std::vector<float> samples_f(FFT_SIZE);  // Temporary float buffer for raw WASAPI audio
    std::vector<double> samples_d(FFT_SIZE); // Double buffer for FFT input

    // === FFTW setup ===
    fftw_complex *out = (fftw_complex *)fftw_malloc(sizeof(fftw_complex) * FFT_SIZE);
    fftw_plan plan = fftw_plan_dft_r2c_1d(FFT_SIZE, samples_d.data(), out, FFTW_ESTIMATE);

    // Get the sample rate from WASAPI format
    double sampleRate = static_cast<double>(pwfx->nSamplesPerSec);
    double freqPerBin = sampleRate / FFT_SIZE; // Frequency step between FFT bins

    while (running_)
    {
        // Check if audio data is available
        pCaptureClient->GetNextPacketSize(&packetLength);
        while (packetLength != 0)
        {
            BYTE *pData = nullptr;
            UINT32 numFramesAvailable = 0;
            DWORD flags = 0;

            // Retrieve audio buffer from WASAPI
            HRESULT hr = pCaptureClient->GetBuffer(&pData, &numFramesAvailable, &flags, nullptr, nullptr);
            if (FAILED(hr) || pData == nullptr || numFramesAvailable == 0)
            {
                pCaptureClient->ReleaseBuffer(0);
                break;
            }

            int numChannels = pwfx->nChannels;
            int samplesToCopy = std::min((int)numFramesAvailable, FFT_SIZE);

            // === Step 1: Copy only the first channel (mono) ===
            const float *floatData = (const float *)pData;
            for (int i = 0; i < samplesToCopy; ++i)
            {
                samples_f[i] = floatData[i * numChannels];
            }

            pCaptureClient->ReleaseBuffer(numFramesAvailable);

            // === Step 2: Convert float → double for FFT ===
            for (int i = 0; i < samplesToCopy; ++i)
            {
                samples_d[i] = static_cast<double>(samples_f[i]);
            }

            // Zero-fill the rest if less than FFT_SIZE
            for (int i = samplesToCopy; i < FFT_SIZE; ++i)
            {
                samples_d[i] = 0.0;
            }

            // === Step 3: Apply window function (reduces spectral leakage) ===
            ApplyHannWindow(samples_d);

            // === Step 4: Perform FFT ===
            fftw_execute(plan);

            // === Step 5: Compute magnitude spectrum ===
            std::vector<double> magnitudes(FFT_SIZE / 2);
            double maxMagnitude = 0.0;
            for (int i = 0; i < FFT_SIZE / 2; ++i)
            {
                double mag = sqrt(out[i][0] * out[i][0] + out[i][1] * out[i][1]) / (FFT_SIZE / 2);
                magnitudes[i] = mag;
                if (mag > maxMagnitude)
                    maxMagnitude = mag; // Track max for normalization
            }

            // === Step 6: Logarithmic binning to 128 bars ===
            int bars = 128;
            double minFreq = 20.0;             // Lower bound for visualization
            double maxFreq = sampleRate / 2.0; // Nyquist frequency
            double logMin = log10(minFreq);
            double logMax = log10(maxFreq);

            flutter::EncodableList barData;
            barData.reserve(bars);

            for (int i = 0; i < bars; ++i)
            {
                // Calculate frequency range for this bar (logarithmic spacing)
                double startFreq = pow(10.0, logMin + (logMax - logMin) * (static_cast<double>(i) / bars));
                double endFreq = pow(10.0, logMin + (logMax - logMin) * (static_cast<double>(i + 1) / bars));

                int startBin = static_cast<int>(std::floor(startFreq / freqPerBin));
                int endBin = static_cast<int>(std::ceil(endFreq / freqPerBin));

                if (startBin < 0)
                    startBin = 0;
                if (endBin > static_cast<int>(magnitudes.size()))
                    endBin = static_cast<int>(magnitudes.size());

                // Average magnitudes in this frequency range
                double sum = 0.0;
                int count = 0;
                for (int bin = startBin; bin < endBin; ++bin)
                {
                    sum += magnitudes[bin];
                    ++count;
                }

                double avgMagnitude = (count > 0) ? (sum / count) : 0.0;

                // === Step 7: Normalize to range 0–1 ===
                double normalized = (maxMagnitude > 0) ? (avgMagnitude / maxMagnitude) : 0.0;

                barData.push_back(flutter::EncodableValue(normalized));
            }

            // === Step 8: Send normalized bar data to Flutter ===
            if (sink_)
            {
                sink_->Success(flutter::EncodableValue(barData));
            }

            // Check for more data
            pCaptureClient->GetNextPacketSize(&packetLength);
        }

        // Limit update rate (~33 FPS)
        std::this_thread::sleep_for(std::chrono::milliseconds(30));
    }

    // Cleanup FFT resources
    fftw_destroy_plan(plan);
    fftw_free(out);
}
