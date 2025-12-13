# 🎵 WaveGlow

**WaveGlow** is a Windows music player built with **Flutter**, featuring **real-time audio visualization**, **native Windows audio processing**, and a **clean architecture** design.

---

## ✨ Features

- 🎶 Play music from user-selected local folders
- 📊 Real-time audio spectrum visualization (60 FPS)
- ⌨️ Media hotkey support (Play / Pause / Next / Previous)
- 🌗 Light & Dark themes
- 🌍 Multi-language support (English & Persian)

---

## 🏗 Architecture

- **Clean Architecture**
- Clear separation of Presentation, Domain, and Data layers
- Scalable and maintainable codebase

---

## 🔌 Platform Integration

- **MethodChannel**

  - Playback control
  - Media key handling

- **EventChannel**
  - Streams live audio frequency data to Flutter

---

## 🧠 Native Audio Processing (C++)

- **WASAPI** for capturing system audio (PCM)
- **FFT** for converting audio samples into frequency bands
- Frequency data is sent to Flutter in real time via EventChannel

---

## 📊 Audio Visualization

- Implemented using Flutter **CustomPaint**
- Renders frequency bands at **60 FPS**
- Driven by native FFT audio data

---

## 🧠 State Management

- **GetX**
  - State management
  - Dependency injection

---

## 🎨 Themes & 🌍 Localization

- Light / Dark theme support
- English and Persian languages
- Runtime switching supported

---

## 🛠 Tech Stack

- Flutter (Dart)
- C++ (Windows)
- WASAPI
- FFT
- MethodChannel & EventChannel
- GetX
- CustomPaint

---

## 🪟 Platform

- Windows Desktop

---

## 📄 License

MIT License
