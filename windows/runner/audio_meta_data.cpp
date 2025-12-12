#include "audio_meta_data.h"

// Converts TagLib::String to UTF-8 std::string
static std::string ConvertToString(const TagLib::String &s)
{
    return s.toCString(true);
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
    TagLib::FileRef f(path.c_str());
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
        meta.durationInSeconds = props->lengthInSeconds();
        meta.bitrate = props->bitrate();
    }

    // Universal album art
    // meta.albumArt = ExtractArtwork(path);

    return meta;
}

// INFO this is not working consider make it work or remove it
std::vector<unsigned char> ExtractArtwork(const std::string &path)
{
    std::vector<unsigned char> art;

    // Build a wide string for TagLib::FileName (Windows)

    TagLib::FileName filename(path.c_str());

    // ----------------------------------------------------------------------
    //                     MP3 (ID3v2)
    // ----------------------------------------------------------------------
    {
        TagLib::MPEG::File mp3file(filename);

        if (mp3file.isValid())
        {
            TagLib::ID3v2::Tag *tag = mp3file.ID3v2Tag();
            if (tag)
            {
                TagLib::ID3v2::AttachedPictureFrame *bestPic = nullptr;

                // Collect ID3v2.3/2.4 APIC frames
                auto framesAPIC = tag->frameListMap()["APIC"];

                // Collect ID3v2.2 PIC frames
                auto framesPIC = tag->frameListMap()["PIC"];

                // Combine:
                TagLib::ID3v2::FrameList frames = framesAPIC;
                frames.append(framesPIC);

                // Fallback: GEOB (some encoders store art here)
                auto framesGEOB = tag->frameListMap()["GEOB"];

                // ---- First: APIC/PIC selection ----
                for (auto frame : frames)
                {
                    auto *pic = dynamic_cast<TagLib::ID3v2::AttachedPictureFrame *>(frame);
                    if (!pic)
                        continue;

                    // Prefer front cover (type = 3)
                    if (pic->type() == TagLib::ID3v2::AttachedPictureFrame::FrontCover)
                    {
                        bestPic = pic;
                        break;
                    }

                    // Otherwise keep first one
                    if (!bestPic)
                        bestPic = pic;
                }

                if (bestPic)
                {
                    const TagLib::ByteVector &data = bestPic->picture();
                    art.assign(data.begin(), data.end());
                    if (!art.empty())
                        return art;
                }

                // ---- Check METADATA_BLOCK_PICTURE (FLAC type stored in MP3) ----
                auto mbpFrames = tag->frameListMap()["METADATA_BLOCK_PICTURE"];
                if (!mbpFrames.isEmpty())
                {
                    // These frames contain raw FLAC picture blocks.
                    // TagLib does not parse them automatically, but the raw block starts after first 4 bytes.
                    TagLib::ByteVector raw = mbpFrames.front()->render();

                    // The FLAC META_PICTURE header length is stored in first 4 bytes big-endian
                    if (raw.size() > 8)
                    {
                        uint32_t len = (uint8_t)raw[4] << 24 |
                                       (uint8_t)raw[5] << 16 |
                                       (uint8_t)raw[6] << 8 |
                                       (uint8_t)raw[7];

                        if (raw.size() >= 8 + len)
                        {
                            TagLib::ByteVector data = raw.mid(8, len);
                            art.assign(data.begin(), data.end());
                            if (!art.empty())
                                return art;
                        }
                    }
                }

                // ---- GEOB (some apps store artwork here) ----
                for (auto frame : framesGEOB)
                {
                    auto *geob = dynamic_cast<TagLib::ID3v2::GeneralEncapsulatedObjectFrame *>(frame);
                    if (geob)
                    {
                        const TagLib::ByteVector &data = geob->object();
                        if (!data.isEmpty())
                        {
                            art.assign(data.begin(), data.end());
                            if (!art.empty())
                                return art;
                        }
                    }
                }
            }
        }
    }

    // ----------------------------------------------------------------------
    //                     FLAC
    // ----------------------------------------------------------------------
    {
        TagLib::FLAC::File flacFile(filename);
        if (flacFile.isValid())
        {
            auto pics = flacFile.pictureList();
            if (!pics.isEmpty())
            {
                auto *pic = pics.front();
                const auto &data = pic->data();
                art.assign(data.begin(), data.end());
                if (!art.empty())
                    return art;
            }
        }
    }

    // ----------------------------------------------------------------------
    //                     MP4 / M4A
    // ----------------------------------------------------------------------
    {
        TagLib::MP4::File mp4File(filename);
        if (mp4File.isValid() && mp4File.tag())
        {
            auto &items = mp4File.tag()->itemMap();
            if (items.contains("covr"))
            {
                auto covr = items["covr"].toCoverArtList();
                if (!covr.isEmpty())
                {
                    const auto &data = covr.front().data();
                    art.assign(data.begin(), data.end());
                    if (!art.empty())
                        return art;
                }
            }
        }
    }

    // ----------------------------------------------------------------------
    //                     OGG Vorbis
    // ----------------------------------------------------------------------
    {
        TagLib::Ogg::Vorbis::File oggFile(filename);
        if (oggFile.isValid() && oggFile.tag())
        {
            auto pics = oggFile.tag()->pictureList();
            if (!pics.isEmpty())
            {
                auto *pic = pics.front();
                const auto &data = pic->data();
                art.assign(data.begin(), data.end());
                if (!art.empty())
                    return art;
            }
        }
    }

    // ----------------------------------------------------------------------
    //                     OGG FLAC
    // ----------------------------------------------------------------------
    {
        TagLib::Ogg::FLAC::File oggFlacFile(filename);
        if (oggFlacFile.isValid() && oggFlacFile.tag())
        {
            auto pics = oggFlacFile.tag()->pictureList();
            if (!pics.isEmpty())
            {
                auto *pic = pics.front();
                const auto &data = pic->data();
                art.assign(data.begin(), data.end());
                if (!art.empty())
                    return art;
            }
        }
    }

    // ----------------------------------------------------------------------
    //                     WAV (ID3v2)
    // ----------------------------------------------------------------------
    {
        TagLib::RIFF::WAV::File wavFile(filename);
        if (wavFile.isValid())
        {
            if (auto *tag = wavFile.ID3v2Tag())
            {
                auto frames = tag->frameListMap()["APIC"];
                if (!frames.isEmpty())
                {
                    auto *pic = dynamic_cast<TagLib::ID3v2::AttachedPictureFrame *>(frames.front());
                    if (pic)
                    {
                        const auto &data = pic->picture();
                        art.assign(data.begin(), data.end());
                        if (!art.empty())
                            return art;
                    }
                }
            }
        }
    }

    return art; // empty = not found
}

flutter::EncodableMap MetadataToEncodableMap(const AudioMetadata &m)
{
    flutter::EncodableMap map;

    map[flutter::EncodableValue("title")] = flutter::EncodableValue(m.title);
    map[flutter::EncodableValue("artist")] = flutter::EncodableValue(m.artist);
    map[flutter::EncodableValue("album")] = flutter::EncodableValue(m.album);
    map[flutter::EncodableValue("duration")] = flutter::EncodableValue((int64_t)m.durationInSeconds);
    map[flutter::EncodableValue("bitrate")] = flutter::EncodableValue((int64_t)m.bitrate);

    // album art: byte list
    map[flutter::EncodableValue("albumArt")] = flutter::EncodableValue(std::vector<uint8_t>(m.albumArt.begin(), m.albumArt.end()));

    return map;
}