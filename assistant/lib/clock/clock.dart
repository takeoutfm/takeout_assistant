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

import 'package:assistant/settings/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lava_clock/frame.dart';
import 'package:lava_clock/lava_clock.dart';
import 'package:lava_clock/model.dart';

class ClockState {
  final bool enabled;
  final bool paused;

  ClockState({required this.enabled, required this.paused});

  ClockState copyWith({bool? enabled, bool? paused}) => ClockState(
      enabled: enabled ?? this.enabled, paused: paused ?? this.paused);

  factory ClockState.initial() {
    return ClockState(enabled: true, paused: false);
  }
}

class ClockEnable extends ClockState {
  ClockEnable.from(ClockState state)
      : super(enabled: true, paused: state.paused);
}

class ClockDisable extends ClockState {
  ClockDisable.from(ClockState state)
      : super(enabled: false, paused: state.paused);
}

class ClockPause extends ClockState {
  ClockPause.from(ClockState state)
      : super(enabled: state.enabled, paused: true);
}

class ClockResume extends ClockState {
  ClockResume.from(ClockState state)
      : super(enabled: state.enabled, paused: false);
}

class ClockCubit extends Cubit<ClockState> {
  final ClockRepository repository;

  ClockCubit(this.repository) : super(ClockState.initial()) {
    repository.listen(stream);
  }

  void enable() {
    repository.setEnabled(true);
    emit(ClockEnable.from(state));
  }

  void disable() {
    repository.setEnabled(false);
    emit(ClockDisable.from(state));
  }

  void pause() {
    repository.setPaused(true);
    emit(ClockPause.from(state));
  }

  void resume() {
    repository.setPaused(false);
    emit(ClockResume.from(state));
  }
}

class ClockRepository {
  final ClockProvider _provider;

  ClockRepository({ClockProvider? provider})
      : _provider = provider ?? LavaClockProvider();

  void init(SettingsCubit settings) {
    settings.stream.listen((event) {
      _provider.use24HourClock(event.settings.use24HourClock);
    });
  }

  void listen(Stream<ClockState> stream) {
    stream.listen((event) {
      if (event is ClockPause) {
        _provider.setPaused(true);
      } else if (event is ClockResume) {
        _provider.setPaused(false);
      }
    });
  }

  void setEnabled(bool enabled) => _provider.setEnabled(enabled);

  void setPaused(bool paused) => _provider.setPaused(paused);

  Widget build(BuildContext context) => _provider.build(context);
}

abstract class ClockProvider {
  Widget build(BuildContext context);

  void setEnabled(bool enabled);

  void setPaused(bool paused);

  void use24HourClock(bool enabled);
}

class LavaClockProvider extends ClockProvider {
  late ClockFrame clock;
  final model = ClockModel();

  @override
  Widget build(BuildContext context) {
    clock = ClockFrame(
        key: clockFrameKey,
        child: (controller) =>
            LavaClock(model, animationController: controller));
    return clock;
  }

  @override
  void use24HourClock(bool enable) {
    model.is24HourFormat = enable;
  }

  @override
  void setEnabled(bool enabled) {}

  @override
  void setPaused(bool paused) {
    final controller = clockFrameKey.currentState?.animationController;
    if (paused) {
      if (controller?.isAnimating == true) {
        controller?.stop();
      }
    } else {
      if (controller?.isAnimating == false) {
        controller?.repeat();
      }
    }
  }
}
