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

import 'package:flutter_bloc/flutter_bloc.dart';
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
