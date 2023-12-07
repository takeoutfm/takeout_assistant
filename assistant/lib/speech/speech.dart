import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'picovoice.dart';
import 'vosk.dart';

class SpeechState {
  final bool awake;
  final String text;

  SpeechState(this.awake, this.text);
}

class SpeechCubit extends Cubit<SpeechState> {
  final SpeechRepository repository;

  SpeechCubit(this.repository) : super(SpeechState(false, '')) {
    _init();
  }

  void _init() {
    repository.stream.listen((event) {
      if (event is WakeWordEvent) {
        emit(SpeechState(true, ''));
      } else if (event is ListeningEvent) {
        emit(SpeechState(false, state.text));
      } else if (event is TextEvent) {
        final text =
            state.text.isNotEmpty ? state.text + ' ' + event.text : event.text;
        emit(SpeechState(true, text));
      }
    });
  }

  void awake() {
    emit(SpeechState(true, ''));
  }

  void text(String text) {
    emit(SpeechState(false, text));
  }

  void start() {}

  void stop() {}
}

abstract class SpeechEvent {}

class WakeWordEvent extends SpeechEvent {}

class ListeningEvent extends SpeechEvent {}

class TextEvent extends SpeechEvent {
  final String text;

  TextEvent(this.text);
}

class SpeechRepository {
  final SpeechProvider _provider;

  SpeechRepository({SpeechProvider? provider})
      // : _provider = provider ?? PicovoiceSpeechProvider() {
      : _provider =
            provider ?? VoskSpeechProvider(['computer', 'alexa']) {
    _init();
  }

  void _init() {
    _provider.init();
  }

  Stream<SpeechEvent> get stream => _provider.stream;
}

abstract class SpeechProvider {
  void init();

  void start();

  void pause();

  void resume();

  void stop();

  Stream<SpeechEvent> get stream;
}
