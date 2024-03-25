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

import 'package:assistant/settings/model.dart';
import 'package:assistant/settings/repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'basic.dart';
import 'lava.dart';

class ClockState {
  final bool paused;

  ClockState({required this.paused});

  ClockState copyWith({bool? paused}) =>
      ClockState(paused: paused ?? this.paused);

  factory ClockState.initial() {
    return ClockState(paused: false);
  }
}

class ClockPause extends ClockState {
  ClockPause.from(ClockState state) : super(paused: true);
}

class ClockResume extends ClockState {
  ClockResume.from(ClockState state) : super(paused: false);
}

class ClockCubit extends Cubit<ClockState> {
  final ClockRepository repository;

  ClockCubit(this.repository) : super(ClockState.initial()) {
    repository.listen(stream);
  }

  void pause() {
    repository.setPaused(true);
    emit(ClockPause.from(state));
  }

  void resume() {
    repository.setPaused(false);
    emit(ClockResume.from(state));
  }

  Widget? build(BuildContext context, {Widget? child}) =>
      repository.build(context, child: child);
}

class ClockRepository {
  ClockProvider? _provider;
  DisplayType _displayType;

  ClockRepository({DisplayType? displayType})
      : _displayType = DisplayType.basic {
    _updateProvider();
  }

  void init(AssistantSettingsRepository settingsRepository) {
    _updateSettings(settingsRepository.settings);
    settingsRepository.stream?.listen((settings) {
      _updateSettings(settings);
    });
  }

  void _updateSettings(AssistantSettings? settings) {
    if (settings != null) {
      if (settings.displayType != _displayType) {
        _displayType = settings.displayType;
        _updateProvider();
      }
    }
  }

  void _updateProvider() {
    switch (_displayType) {
      case DisplayType.lava:
        _provider = LavaClockProvider();
      case DisplayType.basic:
        _provider = BasicClockProvider();
    }
  }

  void listen(Stream<ClockState> stream) {
    stream.listen((event) {
      if (event is ClockPause) {
        _provider?.setPaused(true);
      } else if (event is ClockResume) {
        _provider?.setPaused(false);
      }
    });
  }

  void setPaused(bool paused) => _provider?.setPaused(paused);

  Widget? build(BuildContext context, {Widget? child}) {
    return _provider?.build(context, child: child);
  }
}

abstract class ClockProvider {
  Widget build(BuildContext context, {Widget? child});

  void setPaused(bool paused);
}
