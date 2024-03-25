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

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torch_light/torch_light.dart';

class TorchLightState {
  final bool? enabled;

  TorchLightState({this.enabled});

  factory TorchLightState.initial() {
    return TorchLightState();
  }

  bool get on => enabled ?? false;

  bool get off => enabled ?? false;
}

class TorchLightError extends TorchLightState {
  Object? error;
  StackTrace? stackTrace;

  TorchLightError({this.error, this.stackTrace});
}

class TorchLightEnable extends TorchLightState {
  TorchLightEnable() : super(enabled: true);
}

class TorchLightDisable extends TorchLightState {
  TorchLightDisable() : super(enabled: false);
}

class TorchLightCubit extends Cubit<TorchLightState> {
  final TorchLightRepository repository;

  TorchLightCubit(this.repository) : super(TorchLightState.initial());

  void enable() {
    repository.enable().then((_) => emit(TorchLightEnable())).onError(
        (error, stackTrace) =>
            emit(TorchLightError(error: error, stackTrace: stackTrace)));
  }

  void disable() {
    repository.disable().then((_) => emit(TorchLightDisable())).onError(
            (error, stackTrace) =>
            emit(TorchLightError(error: error, stackTrace: stackTrace)));
  }
}

class TorchLightRepository {
  final TorchLightProvider _provider;

  TorchLightRepository({TorchLightProvider? provider})
      : _provider = provider ?? DefaultTorchLightProvider();

  Future<void> enable() async => _provider.enable();

  Future<void> disable() async => _provider.disable();
}

abstract class TorchLightProvider {
  Future<void> enable();

  Future<void> disable();
}

class DefaultTorchLightProvider extends TorchLightProvider {
  @override
  Future<void> enable() async {
    try {
      return TorchLight.enableTorch();
    } catch (e, stack) {
      return Future.error(e, stack);
    }
  }

  @override
  Future<void> disable() async {
    try {
      return TorchLight.disableTorch();
    } catch (e, stack) {
      return Future.error(e, stack);
    }
  }
}
