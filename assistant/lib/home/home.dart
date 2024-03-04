import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  HomeCubit({required this.repository}) : super(HomeState.initial()) {
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
    repository.discover().then((_) {
      _emit();
      for (var l in repository.lights) {
        repository.identifyLight(l);
      }
    });
  }

  void _emit() {
    emit(HomeState(
        lights: repository.lights,
        rooms: repository.rooms,
        zones: repository.zones));
  }

  void identifyLight(Light light) => repository.identifyLight(light);

  void toggleLight(Light light) =>
      repository.toggleLight(light).then((_) => _emit());

  void lightOn(Light light) => repository.lightOn(light).then((_) => _emit());

  void lightOff(Light light) => repository.lightOff(light).then((_) => _emit());

  void lightBrightness(Light light, double percentage) =>
      repository.lightBrightness(light, percentage).then((_) => _emit());

  void lightColor(Light light, Color color) =>
      repository.lightColor(light, color).then((_) => _emit());

  void setLights({String? room, String? zone, bool? on, Color? color}) {
    final doit = (light) {
      if (on == true) {
        return repository.lightOn(light);
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
          (light) => doit(light)).then((_) => _emit());
    }
    if (zone != null) {
      Future.forEach(
          repository.lights.where((light) => light.zones.contains(zone)),
          (light) => doit(light)).then((_) => _emit());
    }
  }

}
