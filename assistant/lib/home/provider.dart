import 'dart:ui';

import 'model.dart';

abstract class HomeProvider {
  Future<bool> authRequired();

  Future<void> discover();

  List<Light> get lights;

  List<String> get rooms;

  List<String> get zones;

  Future<void> identifyLight(Light light);

  Future<void> toggleLight(Light light);

  Future<void> lightOn(Light light);

  Future<void> lightOff(Light light);

  Future<void> lightBrightness(Light light, double percentage);

  Future<void> lightColor(Light light, Color color);
}
