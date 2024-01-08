# Takeout Assistant

Voice assistant app with offline speech recognition using Vosk that displays a clock and listens for 
wake-word(s) followed by voice actions that are processed internally or dispatched to other apps 
using Android intents.

Features include:

- Supports music playlist & playback commands that are dispatched to the [Takeout Mobile app](https://github.com/takeoutfm/takeout_app)
- Volume control commands
- Wake-words are optional, speak naturally, it's all offline and locally processed
- Lava Clock from the Flutter 2020 clock challenge (@jamesblasco)
- Vosk offline speech recognition (english small model)
- Torch/flashlight on/off
- [GMS](https://en.wikipedia.org/wiki/Google_Mobile_Services) is not required 
- Works with AOSP-based systems like [LineageOS](https://lineageos.org/)

See [SPEECH.md](assistant/SPEECH.md) for recognized speech commands and supported languages.

Lava Clock originally available at https://github.com/jamesblasco/flutter_lava_clock. It has been 
updated to support latest Flutter and Dart versions.

Vosk is available at https://alphacephei.com/vosk/. 