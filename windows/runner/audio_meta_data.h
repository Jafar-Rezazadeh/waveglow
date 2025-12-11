#pragma once

#include <flutter/encodable_value.h>
#include <taglib/fileref.h>
#include <taglib/tag.h>
#include <taglib/audioproperties.h>
#include <taglib/mpegfile.h>
#include <taglib/id3v2tag.h>
#include <taglib/id3v2frame.h>
#include <taglib/attachedpictureframe.h>
#include <taglib/flacfile.h>
#include <taglib/mp4file.h>
#include <taglib/vorbisfile.h>
#include <taglib/oggflacfile.h>
#include <taglib/wavfile.h>

#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <Windows.h>

#include <codecvt>
#include <locale>

// Struct for raw metadata
struct AudioMetadata
{
    std::string title;
    std::string artist;
    std::string album;
    int durationMs = 0;
    int bitrate = 0;
    std::vector<unsigned char> albumArt;
};
// Main function
AudioMetadata ReadAudioMetadata(const std::string &path);

// ArtWork Extractor
std::vector<unsigned char> ExtractArtwork(const std::string &path);

// Flutter conversion helper
flutter::EncodableMap MetadataToEncodableMap(const AudioMetadata &m);

// TODO: just for debugging needs to be removed
std::string DebugingAlbumArt(const std::string &path);