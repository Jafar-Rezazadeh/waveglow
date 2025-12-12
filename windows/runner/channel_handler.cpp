#include "channel_handler.h"

CustomFlutterChannelHandler::CustomFlutterChannelHandler() {}

CustomFlutterChannelHandler::~CustomFlutterChannelHandler() {}

void CustomFlutterChannelHandler::init(std::unique_ptr<flutter::FlutterViewController> &flutterController)
{

    initEventChannel(flutterController);
    initAudioMetaDataMethodChannels(flutterController);
}

void CustomFlutterChannelHandler::initEventChannel(std::unique_ptr<flutter::FlutterViewController> &flutterController)
{
    auto eventChannel = std::make_unique<flutter::EventChannel<flutter::EncodableValue>>(
        flutterController->engine()->messenger(),
        eventChannelName,
        &flutter::StandardMethodCodec::GetInstance());

    eventChannel->SetStreamHandler(std::make_unique<AudioEventStreamer>());
}

void CustomFlutterChannelHandler::initAudioMetaDataMethodChannels(std::unique_ptr<flutter::FlutterViewController> &flutterController)
{
    auto audioMetaDataChannel = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
        flutterController->engine()->messenger(),
        audioMetaDataChannelName,
        &flutter::StandardMethodCodec::GetInstance());

    audioMetaDataChannel->SetMethodCallHandler(
        [](const flutter::MethodCall<flutter::EncodableValue> &call,
           std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
        {
            if (call.method_name() == "getMetaData")
            {
                // Check argument exists
                auto args_ptr = call.arguments();
                if (!args_ptr || !std::holds_alternative<std::string>(*args_ptr))
                {
                    result->Error("INVALID_ARGUMENT", "Expected a string argument");
                    return;
                }

                std::string path = std::get<std::string>(*args_ptr);

                auto metadata = ReadAudioMetadata(path);

                auto map = MetadataToEncodableMap(metadata);

                result->Success(flutter::EncodableValue(map));
            }
            else
            {
                result->NotImplemented();
            }
        });
}
