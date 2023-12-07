import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:light/light.dart';

class AmbientLightState {
  final int lux;

  AmbientLightState(this.lux);

  bool isDark() => lux < 50;

  bool isLight() => lux >= 50;

  factory AmbientLightState.initial() {
    return AmbientLightState(0);
  }
}

class AmbientLightCubit extends Cubit<AmbientLightState> {
  final AmbientLightRepository repository;
  StreamSubscription<int>? _subscription;

  AmbientLightCubit(this.repository) : super(AmbientLightState.initial()) {
    _init();
  }

  void _init() {
    _subscription =
        repository.stream.listen((lux) => emit(AmbientLightState(lux)));
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}

class AmbientLightRepository {
  final AmbientLightProvider _provider;
  StreamSubscription<int>? _subscription;
  int? _lux;

  AmbientLightRepository({AmbientLightProvider? provider})
      : _provider = provider ?? DefaultAmbientLightProvider() {
    _init(_provider.stream);
  }

  void _init(Stream<int> stream) {
    _subscription = stream.listen((lux) {
      _lux = lux;
    });
  }

  void dispose() {
    _subscription?.cancel();
  }

  Stream<int> get stream => _provider.stream;

  int? get lux => _lux;
}

abstract class AmbientLightProvider {
  Stream<int> get stream;
}

class DefaultAmbientLightProvider extends AmbientLightProvider {
  final _light = Light();

  @override
  Stream<int> get stream => _light.lightSensorStream;
}
