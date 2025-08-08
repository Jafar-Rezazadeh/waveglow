#include "channel_handler.h"

CustomFlutterChannelHandler::CustomFlutterChannelHandler(/* args */) {}

CustomFlutterChannelHandler::~CustomFlutterChannelHandler() {}

void CustomFlutterChannelHandler::init(std::unique_ptr<flutter::FlutterViewController> &flutterController)
{

    initEventChannel(flutterController);
}

void CustomFlutterChannelHandler::initEventChannel(std::unique_ptr<flutter::FlutterViewController> &flutterController)
{
    auto eventChannel = std::make_unique<flutter::EventChannel<flutter::EncodableValue>>(
        flutterController->engine()->messenger(),
        eventChannelName,
        &flutter::StandardMethodCodec::GetInstance());

    eventChannel->SetStreamHandler(std::make_unique<AudioEventStreamer>());
}
