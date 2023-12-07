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
import 'package:volume_controller/volume_controller.dart';

class VolumeState {
  final double volume;
  final double previousVolume;

  VolumeState(this.volume, this.previousVolume);

  factory VolumeState.initial() {
    return VolumeState(0, 0);
  }
}

class VolumeCubit extends Cubit<VolumeState> {
  final VolumeRepository repository;

  VolumeCubit(this.repository) : super(VolumeState.initial()) {
    _init();
  }

  void _init() {
    repository.listener((volume) {
      if (volume != state.volume) {
        emit(VolumeState(volume, state.volume));
      }
    });
  }

  void setVolume(double volume) => repository.setVolume(volume);
}

class VolumeRepository {
  final VolumeProvider _provider;

  VolumeRepository({VolumeProvider? provider})
      : _provider = provider ?? DefaultVolumeProvider() {
  }

  void listener(Function(double) callback) =>
    _provider.listener(callback);

  void setVolume(double volume) => _provider.setVolume(volume);

  Future<double> getVolume() => _provider.getVolume();
}

abstract class VolumeProvider {
  void listener(Function(double) callback);

  void setVolume(double volume);

  Future<double> getVolume();
}

class DefaultVolumeProvider extends VolumeProvider {
  final _controller = VolumeController();

  @override
  void listener(Function(double) callback) {
    _controller.listener(callback);
  }

  @override
  void setVolume(double volume) => _controller.setVolume(volume);

  @override
  Future<double> getVolume() => _controller.getVolume();
}
