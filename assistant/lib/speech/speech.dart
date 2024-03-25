// Copyright 2023 defsub
//
// This file is part of TakeoutFM.
//
// TakeoutFM is free software: you can redistribute it and/or modify it under the
// terms of the GNU Affero General Public License as published by the Free
// Software Foundation, either version 3 of the License, or (at your option)
// any later version.
//
// TakeoutFM is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for
// more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with TakeoutFM.  If not, see <https://www.gnu.org/licenses/>.

import 'dart:async';

import 'package:assistant/settings/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'vosk.dart';

class SpeechState {
  final bool awake;
  final String text;
  final bool paused;

  SpeechState(this.awake, this.text, {this.paused = false});

  void copyWith({bool? paused}) =>
      SpeechState(this.awake, this.text, paused: paused ?? this.paused);
}

class SpeechAsleep extends SpeechState {
  SpeechAsleep() : super(false, '');
}

class SpeechAwake extends SpeechState {
  SpeechAwake() : super(true, '');
}

class SpeechText extends SpeechState {
  SpeechText(String text) : super(true, text);
}

class SpeechPause extends SpeechState {
  SpeechPause() : super(false, '', paused: true);
}

class SpeechResume extends SpeechState {
  SpeechResume() : super(false, '', paused: false);
}

class SpeechCubit extends Cubit<SpeechState> {
  late SpeechRepository _repository;

  SpeechCubit() : super(SpeechState(false, ''));

  void init(SpeechRepository repository) {
    _repository = repository;
    _repository.stream.listen((event) {
      if (event is WakeWordEvent) {
        emit(SpeechAwake());
      } else if (event is ListeningEvent) {
        emit(SpeechAsleep());
      } else if (event is TextEvent) {
        // final text =
        //     state.text.isNotEmpty ? state.text + ' ' + event.text : event.text;
        emit(SpeechText(event.text));
      }
    });
  }

  void pause() {
    _repository.stop();
    emit(SpeechPause());
  }

  void resume() {
    _repository.start();
    emit(SpeechResume());
  }
}

abstract class SpeechEvent {}

class WakeWordEvent extends SpeechEvent {}

class ListeningEvent extends SpeechEvent {}

class TextEvent extends SpeechEvent {
  final String text;

  TextEvent(this.text);
}

class SpeechRepository {
  late SpeechProvider _provider;

  void init(AssistantSettingsRepository assistantSettingsRepository) {
    _provider = VoskSpeechProvider(assistantSettingsRepository);
    _provider.init().then((_) {
      if (assistantSettingsRepository.settings?.enableSpeechRecognition ??
          false) {
        // restore previous state
        _provider.start();
      }
    });
  }

  Stream<SpeechEvent> get stream => _provider.stream;

  void pause() => _provider.pause();

  void resume() => _provider.resume();

  void stop() => _provider.stop();

  void start() => _provider.start();
}

abstract class SpeechProvider {
  Future<void> init();

  void start();

  void pause();

  void resume();

  void stop();

  Stream<SpeechEvent> get stream;
}
