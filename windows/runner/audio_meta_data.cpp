#include "audio_meta_data.h"

// Converts TagLib::String to UTF-8 std::string
static std::string ConvertToString(const TagLib::String &s)
{
    return s.toCString(true);
}

// Convert UTF-8 std::string to UTF-16 std::wstring for Windows
static std::wstring Utf8ToUtf16(const std::string &utf8)
{
    if (utf8.empty())
        return std::wstring();

    // Get required size for the UTF-16 buffer
    int size_needed = MultiByteToWideChar(CP_UTF8, 0, utf8.c_str(), (int)utf8.size(), nullptr, 0);
    if (size_needed == 0)
        return std::wstring();

    std::wstring utf16(size_needed, 0);
    MultiByteToWideChar(CP_UTF8, 0, utf8.c_str(), (int)utf8.size(), &utf16[0], size_needed);
    return utf16;
}

AudioMetadata ReadAudioMetadata(const std::string &path)
{
    AudioMetadata meta;

    // ---- File existence check ----
    std::ifstream test(path, std::ios::binary);
    if (!test.is_open())
    {
        std::cerr << "File not found or cannot be opened: " << path << std::endl;
        return meta;
    }
    test.close();

    // ---- Open file with TagLib (UTF-16) ----
    TagLib::FileRef f(Utf8ToUtf16(path).c_str());
    if (f.isNull())
    {
        std::cerr << "TagLib failed to open file: " << path << std::endl;
        return meta;
    }

    // // ---- Tags ----
    if (TagLib::Tag *tag = f.tag())
    {
        meta.title = ConvertToString(tag->title());
        meta.artist = ConvertToString(tag->artist());
        meta.album = ConvertToString(tag->album());
    }

    // // ---- Audio properties ----
    if (TagLib::AudioProperties *props = f.audioProperties())
    {
        meta.durationMs = props->lengthInSeconds();
        meta.bitrate = props->bitrate();
    }

    // Universal album art
    meta.albumArt = ExtractArtwork(path);

    return meta;
}

std::string DebugingAlbumArt(const std::string &path)
{
    std::string debugInfo;
    TagLib::MPEG::File file(Utf8ToUtf16(path).c_str());

    if (!file.isValid())
    {
        debugInfo += "File invalid\n";
    }

    debugInfo += "File valid\n";

    auto *tag = file.ID3v2Tag();
    if (!tag)
    {
        debugInfo += "ID3v2 tag = null\n";
    }

    debugInfo += "ID3v2 tag exists\n";

    // // // SAFELY get the frame map
    auto frames = tag->frameList(); // gets ALL frames, not grouped map
    debugInfo += "Raw frame count = " + std::to_string(frames.size()) + "\n";

    // TagLib::ID3v2::AttachedPictureFrame *bestPic = nullptr;

    // for (auto frame : frames)
    // {
    //     if (frame->frameID() != "APIC" && frame->frameID() != "PIC")
    //         continue;

    //     auto *pic = static_cast<TagLib::ID3v2::AttachedPictureFrame *>(frame);

    //     debugInfo += "Found picture! mime=" + std::string(pic->mimeType().toCString(true)) + " size=" + std::to_string(pic->picture().size()) + " type=" + std::to_string(pic->type()) + "\n";

    // if (pic->type() == TagLib::ID3v2::AttachedPictureFrame::FrontCover)
    // {
    //     bestPic = pic;
    //     break;
    // }

    // if (!bestPic)
    //     bestPic = pic;
    // }

    // Check APIC key exists
    // if (!map.contains("APIC"))
    // {
    //     debugInfo += "No APIC key in map\n";
    //     goto end;
    // }

    // const TagLib::ID3v2::FrameList &frames = map["APIC"];

    // debugInfo += "APIC count = " + std::to_string(frames.size()) + "\n";

    // if (frames.isEmpty())
    // {
    //     debugInfo += "APIC list exists but empty\n";
    //     goto end;
    // }

    // for (auto f : frames)
    // {
    //     auto *p = dynamic_cast<TagLib::ID3v2::AttachedPictureFrame *>(f);
    //     if (!p)
    //         continue;

    //     debugInfo +=
    //         "Type=" + std::to_string(p->type()) +
    //         " Mime=" + std::string(p->mimeType().toCString(true)) +
    //         " Size=" + std::to_string(p->picture().size()) + "\n";
    // }

    // Also return actual artwork if we find FrontCover
    // for (auto f : frames)
    // {
    //     auto *p = dynamic_cast<TagLib::ID3v2::AttachedPictureFrame *>(f);
    //     if (!p)
    //         continue;

    //     if (p->type() == TagLib::ID3v2::AttachedPictureFrame::FrontCover)
    //     {
    //         const auto &data = p->picture();
    //         art.assign(data.begin(), data.end());
    //         break;
    //     }
    // }

    return debugInfo;
}

std::vector<unsigned char> ExtractArtwork(const std::string &path)
{
    std::vector<unsigned char> art;

    // ---- MP3 (ID3v2 APIC) ----

    TagLib::MPEG::File mp3file(Utf8ToUtf16(path).c_str());
    if (mp3file.isValid())
    {
        if (auto *tag = mp3file.ID3v2Tag())
        {
            auto frames = tag->frameListMap()["APIC"];

            if (!frames.isEmpty())
            {
                TagLib::ID3v2::AttachedPictureFrame *bestPic = nullptr;

                // Iterate all APIC frames
                for (auto frame : frames)
                {
                    auto *pic = dynamic_cast<TagLib::ID3v2::AttachedPictureFrame *>(frame);
                    if (!pic)
                        continue;

                    // Prefer front cover (type 3)
                    if (pic->type() == TagLib::ID3v2::AttachedPictureFrame::FrontCover)
                    {
                        bestPic = pic;
                        break;
                    }

                    // If no front cover exists, fall back to the first pic
                    if (!bestPic)
                        bestPic = pic;
                }

                if (bestPic)
                {
                    const auto &data = bestPic->picture();
                    art.assign(data.begin(), data.end());
                    return art;
                }
            }
        }
    }

    // ---- FLAC ----

    TagLib::FLAC::File flacFile(Utf8ToUtf16(path).c_str());
    if (flacFile.isValid())
    {
        auto pictures = flacFile.pictureList();
        if (!pictures.isEmpty())
        {
            auto *pic = pictures.front();
            const auto &data = pic->data();
            art.assign(data.begin(), data.end());
            return art;
        }
    }

    // ---- MP4 / M4A ----

    TagLib::MP4::File mp4File(Utf8ToUtf16(path).c_str());
    if (mp4File.isValid())
    {
        auto &items = mp4File.tag()->itemMap();
        if (items.contains("covr"))
        {
            auto covr = items["covr"].toCoverArtList();
            if (!covr.isEmpty())
            {
                const TagLib::MP4::CoverArt &cover = covr.front();
                const TagLib::ByteVector &data = cover.data();
                art.assign(data.begin(), data.end());
                return art;
            }
        }
    }

    // ---- OGG / Vorbis ----

    TagLib::Ogg::Vorbis::File oggFile(Utf8ToUtf16(path).c_str());
    if (oggFile.isValid())
    {
        if (auto *tag = oggFile.tag())
        {
            auto pics = tag->pictureList();
            if (!pics.isEmpty())
            {
                auto *pic = pics.front();
                const auto &data = pic->data();
                art.assign(data.begin(), data.end());
                return art;
            }
        }
    }

    // ---- OGG / FLAC (Xiph) ----

    TagLib::Ogg::FLAC::File oggXiphFile(Utf8ToUtf16(path).c_str());
    if (oggXiphFile.isValid())
    {
        if (auto *tag = oggXiphFile.tag())
        {
            auto pics = tag->pictureList();
            if (!pics.isEmpty())
            {
                auto *pic = pics.front();
                const auto &data = pic->data();
                art.assign(data.begin(), data.end());
                return art;
            }
        }
    }

    // ---- WAV with ID3v2 ----

    TagLib::RIFF::WAV::File wavFile(Utf8ToUtf16(path).c_str());
    if (wavFile.isValid())
    {
        if (auto *tag = wavFile.ID3v2Tag())
        {
            auto frames = tag->frameListMap()["APIC"];
            if (!frames.isEmpty())
            {
                if (auto *pic = dynamic_cast<TagLib::ID3v2::AttachedPictureFrame *>(frames.front()))
                {
                    const auto &data = pic->picture();
                    art.assign(data.begin(), data.end());
                    return art;
                }
            }
        }
    }

    return art; // empty if no artwork found
}

flutter::EncodableMap MetadataToEncodableMap(const AudioMetadata &m)
{
    flutter::EncodableMap map;

    map[flutter::EncodableValue("title")] = flutter::EncodableValue(m.title);
    map[flutter::EncodableValue("artist")] = flutter::EncodableValue(m.artist);
    map[flutter::EncodableValue("album")] = flutter::EncodableValue(m.album);
    map[flutter::EncodableValue("duration")] = flutter::EncodableValue((int64_t)m.durationMs);
    map[flutter::EncodableValue("bitrate")] = flutter::EncodableValue((int64_t)m.bitrate);

    // album art: byte list
    map[flutter::EncodableValue("albumArt")] = flutter::EncodableValue(std::vector<uint8_t>(m.albumArt.begin(), m.albumArt.end()));

    return map;
}