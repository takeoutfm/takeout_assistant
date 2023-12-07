import 'dart:async';
import 'dart:convert';

import 'package:vosk_flutter/vosk_flutter.dart';
import 'speech.dart';

class VoskSpeechProvider implements SpeechProvider {
  final _vosk = VoskFlutterPlugin.instance();
  final StreamController<SpeechEvent> _streamController =
      StreamController.broadcast();
  SpeechService? _speechService;
  Timer? awakeTimer;

  static const _modelName = 'assets/models/vosk-model-small-en-us-0.15.zip';
  static const _sampleRate = 16000;

  final List<String> wakeWords;
  final Duration awakeDuration;

  VoskSpeechProvider(this.wakeWords,
      {this.awakeDuration = const Duration(seconds: 5)});

  void init() async {
    try {
      final loader = ModelLoader();
      final path = await loader.loadFromAssets(_modelName);
      print(path);
      final model = await _vosk.createModel(path);
      print(model);
      final recognizer =
          await _vosk.createRecognizer(model: model, sampleRate: _sampleRate);
      print(recognizer);
      _speechService = await _vosk.initSpeechService(recognizer);
      _speechService?.onResult().listen((event) {
        final data = jsonDecode(event) as Map<String, dynamic>;
        final text = data['text'] as String?;
        if (text != null && text.isNotEmpty) {
          if (awakeTimer == null || awakeTimer?.isActive == false) {
            if (wakeWords.contains(text)) {
              print('wakeword1: $text');
              _onWakeWord();
            } else {
              final words = text.split(' ');
              if (words.length > 1 && wakeWords.contains(words.first)) {
                print('wakeword2: $text');
                _onWakeWord();
                words.removeAt(0);
                _onText(words.join(' '));
              } else {
                print('ignore $text');
              }
            }
          } else if (awakeTimer != null && awakeTimer?.isActive == true) {
            _onText(text);
          }
        }
      });
      // _speechService?.onPartial().listen((event) {
      //   print('partial $event');
      // });
      start();
    } catch (e, stack) {
      print(e);
      print(stack);
    }
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
