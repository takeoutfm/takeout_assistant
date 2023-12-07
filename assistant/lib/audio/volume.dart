
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
