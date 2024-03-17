// Copyright 2023 defsub
//
// This file is part of Takeout.
//
// Takeout is free software: you can redistribute it and/or modify it under the
// terms of the GNU Affero General Public License as published by the Free
// Software Foundation, either version 3 of the License, or (at your option)
// any later version.
//
// Takeout is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for
// more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with Takeout.  If not, see <https://www.gnu.org/licenses/>.

import 'dart:async';
import 'dart:convert';

import 'package:assistant/settings/repository.dart';
import 'package:vosk_flutter_2/vosk_flutter_2.dart';
import 'speech.dart';

class VoskSpeechProvider implements SpeechProvider {
  final _vosk = VoskFlutterPlugin.instance();
  final StreamController<SpeechEvent> _streamController =
      StreamController.broadcast();
  SpeechService? _speechService;
  Timer? awakeTimer;

  static const _modelName = 'assets/models/vosk-model-small-en-us-0.15.zip';
  static const _sampleRate = 16000;
  static const _awakeDuration = Duration(seconds: 5);
  static const _filterWords = ['he', 'huh', 'it']; // noise words from vox

  final AssistantSettingsRepository settingsRepository;
  final Duration awakeDuration;

  VoskSpeechProvider(this.settingsRepository,
      {this.awakeDuration = _awakeDuration});

  void init() async {
    try {
      final loader = ModelLoader();
      final path = await loader.loadFromAssets(_modelName);
      final model = await _vosk.createModel(path);
      final recognizer =
          await _vosk.createRecognizer(model: model, sampleRate: _sampleRate);
      _speechService = await _vosk.initSpeechService(recognizer);
      _speechService?.onResult().listen((event) => _onResult(event));
      // _speechService?.onPartial().listen((event) {
      //   print('partial $event');
      // });
    } catch (e, stack) {
      print(e);
      print(stack);
    }
  }

  void _onResult(String event) {
    final data = jsonDecode(event) as Map<String, dynamic>;
    var text = data['text'] as String? ?? '';
    text = text.trim();
    final useWakeWords = settingsRepository.settings?.enableWakeWords ?? false;
    final wakeWords = settingsRepository.settings?.wakeWords;
    if (text.isNotEmpty) {
      if (useWakeWords && wakeWords != null && wakeWords.isNotEmpty) {
        _handleWakeWords(wakeWords, text);
      } else {
        _handleText(text);
      }
    }
  }

  void _handleText(String text) {
    final words = _processText(text);
    if (words.isNotEmpty) {
      _onText(words.join(' '));
    }
  }

  void _handleWakeWords(List<String> wakeWords, String text) {
    if (awakeTimer == null || awakeTimer?.isActive == false) {
      if (wakeWords.contains(text)) {
        // wakeWord only, text later
        print('wakeword1: $text');
        _onWakeWord();
      } else {
        // wakeWord followed by text
        final words = _processText(text);
        if (words.isNotEmpty) {
          var matched = false;
          for (var ww in wakeWords) {
            final n = ww.split(' ').length;
            if (words.length > n) {
              if (text.startsWith(ww)) {
                print('wakeword2: $text');
                _onWakeWord();
                words.removeRange(0, n);
                _onText(words.join(' '));
                matched = true;
                break;
              }
            }
          }
          if (!matched) {
            print('ignore $text');
          }
        }
      }
    } else if (awakeTimer != null && awakeTimer?.isActive == true) {
      final words = _processText(text);
      if (words.isNotEmpty) {
        _onText(words.join(' '));
      }
    }
  }

  List<String> _processText(String text) {
    final words = text.split(' ');
    if (words.isNotEmpty) {
      for (var f in _filterWords) {
        if (words.first == f) {
          words.removeAt(0);
          if (words.isEmpty) {
            break;
          }
        }
      }
    }
    return words;
  }

  void _onWakeWord() {
    _streamController.add(WakeWordEvent());
    awakeTimer = Timer(awakeDuration, () {
      _streamController.add(ListeningEvent());
    });
  }

  void _onText(String text) {
    awakeTimer?.cancel();
    _streamController.add(TextEvent(text));
    _streamController.add(ListeningEvent());
  }

  @override
  Stream<SpeechEvent> get stream => _streamController.stream;

  @override
  void start() {
    _speechService?.start();
  }

  @override
  void stop() {
    _speechService?.stop();
  }

  @override
  void pause() {
    _speechService?.setPause(paused: true);
  }

  @override
  void resume() {
    _speechService?.setPause(paused: false);
  }
}
