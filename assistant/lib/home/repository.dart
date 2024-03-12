import 'dart:ui';

import 'package:assistant/home/hue_provider.dart';

import 'model.dart';
import 'provider.dart';

class HomeRepository {
  final HomeProvider _provider;

  HomeRepository({HomeProvider? provider})
      : _provider = provider ?? HueHomeProvider();

  Future<bool> authRequired() async => _provider.authRequired();

  Future<void> discover({String? defaultBridge}) async => _provider.discover(defaultBridge: defaultBridge);

  Future<void> fetchNetwork() async => _provider.fetchNetwork();

  List<Light> get lights => _provider.lights;

  List<String> get rooms => _provider.rooms;

  List<String> get zones => _provider.zones;

  Future<void> lightOn(Light light) async => _provider.lightOn(light);

  Future<void> lightOff(Light light) async => _provider.lightOff(light);

  Future<void> identifyLight(Light light) async =>
      _provider.identifyLight(light);

  Future<void> toggleLight(Light light) async => _provider.toggleLight(light);

  Future<void> lightBrightness(Light light, double percentage) =>
      _provider.lightBrightness(light, percentage);

  Future<void> lightColor(Light light, Color color) =>
      _provider.lightColor(light, color);

  Future<void> zoneColor(String name, Color color) =>
      _provider.zoneColor(name, color);
}
