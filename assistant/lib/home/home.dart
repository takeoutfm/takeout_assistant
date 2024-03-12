import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:assistant/settings/repository.dart';
import 'model.dart';
import 'repository.dart';

class HomeState {
  final List<Light> lights;
  final List<String> rooms;
  final List<String> zones;

  factory HomeState.initial() => HomeState(lights: [], rooms: [], zones: []);

  HomeState({required this.lights, required this.rooms, required this.zones});

  bool get isEmpty => lights.isEmpty && zones.isEmpty && zones.isEmpty;
}

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository repository;
  final AssistantSettingsRepository assistantSettingsRepository;

  HomeCubit(
      {required this.repository, required this.assistantSettingsRepository})
      : super(HomeState.initial()) {
    _load();
  }

  void _load() {
    repository.authRequired().then((result) {
      if (result) {
        // TODO moved - use state for this
        Fluttertoast.showToast(
            msg: 'Press Hue Bridge Button',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 16.0);
      }
    });
    repository.discover().then((_) => _fetchNetwork());
  }

  void _fetchNetwork() {
    repository.fetchNetwork().then((_) => _emit());
  }

  void _emit() {
    print('emit ${repository.lights.length}');
    emit(HomeState(
        lights: repository.lights,
        rooms: repository.rooms,
        zones: repository.zones));
  }

  void _update() {
    _emit();
  }

  void _updateLight(Light light) {
    for (int i = 0; i < state.lights.length; i++) {
      if (state.lights[i].id == light.id) {
        state.lights[i] = light;
        break;
      }
    }
  }

  void identifyLight(Light light) => repository.identifyLight(light);

  void toggleLight(Light light) => repository.toggleLight(light).then((_) {
        _updateLight(light.copyWith(on: !light.on));
        _update();
      });

  void lightOn(Light light) => repository.lightOn(light).then((_) {
        _updateLight(light.copyWith(on: true));
        _update();
      });

  void lightOff(Light light) => repository.lightOff(light).then((_) {
        _updateLight(light.copyWith(on: false));
        _update();
      });

  void lightBrightness(Light light, double percentage) =>
      repository.lightBrightness(light, percentage).then((_) {
        _updateLight(light.copyWith(brightness: percentage));
        _update();
      });

  void lightColor(Light light, Color color) =>
      repository.lightColor(light, color).then((_) {
        _updateLight(light.copyWith(color: color));
        _update();
      });

  void zoneColor(String name, Color color) =>
      repository.zoneColor(name, color).then((_) {
        _update();
      });

  void setLights({String? room, String? zone, bool? on, Color? color}) {
    final doit = (light) {
      if (on == true) {
        repository.lightOn(light);
      } else if (on == false) {
        return repository.lightOff(light);
      } else if (color != null) {
        return repository.lightColor(light, color);
      } else {
        return Future.value(false);
      }
    };
    if (room != null) {
      Future.forEach(repository.lights.where((light) => light.room == room),
          (light) => doit(light)).then((_) => _update());
    }
    if (zone != null) {
      Future.forEach(
          repository.lights.where((light) => light.zones.contains(zone)),
          (light) => doit(light)).then((_) => _update());
    }
  }
}
