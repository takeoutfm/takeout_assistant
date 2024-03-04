
import 'dart:ui';

import 'package:flutter_hue/domain/repos/bridge_discovery_repo.dart';
import 'package:flutter_hue/flutter_hue.dart' as hue;

import 'model.dart';
import 'provider.dart';

class HueHomeProvider extends HomeProvider {
  List<hue.Bridge>? _bridges;
  hue.HueNetwork? _network;
  List<Light> _lights = [];
  List<String> _rooms = [];
  List<String> _zones = [];

  Future<bool> authRequired() async {
    final bridges = await BridgeDiscoveryRepo.fetchSavedBridges();
    return bridges.isEmpty;
  }

  Future<void> discover() async {
    await _discoverBridges();
    await _fetchNetwork();
  }

  List<Light> get lights => _lights;

  List<String> get rooms => _rooms;

  List<String> get zones => _zones;

  Future<void> identifyLight(Light light) async {
    hue.Device? target = _findDevice(light.name);
    if (target != null) {
      target.identifyAction = "identify";
      await target.bridge?.put(target);
    }
  }

  Future<void> _light(Light light, bool on) async {
    hue.Light? target = _findLight(light.id);
    if (target != null) {
      target.on.isOn = on;
      await target.bridge?.put(target);
    }
  }

  Future<void> lightOn(Light light) async {
    return _light(light, true);
  }

  Future<void> lightOff(Light light) async {
    return _light(light, false);
  }

  Future<void> toggleLight(Light light) async {
    hue.Light? target = _findLight(light.id);
    if (target != null) {
      target.on.isOn = !target.on.isOn;
      await target.bridge?.put(target);
    }
  }

  Future<void> lightBrightness(Light light, double percentage) async {
    hue.Light? target = _findLight(light.id);
    if (target != null) {
      target.dimming.brightness = percentage;
      await target.bridge?.put(target);
    }
  }

  Future<void> lightColor(Light light, Color color) async {
    hue.Light? target = _findLight(light.id);
    if (target != null) {
      final list = hue.ColorConverter.color2xy(color);
      print('set $light color to $color with $list');
      target.color.xy.x = list[0];
      target.color.xy.y = list[1];
      target.dimming.brightness = list[2]*100;
      await target.bridge?.put(target);
    }
  }

  hue.Device? _findDevice(String name) {
    final network = _network;
    if (network != null) {
      for (var d in network.devices) {
        if (d.metadata.name == name) {
          return d;
        }
      }
    }
    return null;
  }

  hue.Light? _findLight(String id) {
    final network = _network;
    if (network != null) {
      for (var d in network.lights) {
        if (d.id == id) {
          return d;
        }
      }
    }
    return null;
  }

  // hue.Room? _findRoom(String id) {
  //   final network = _network;
  //   if (network != null) {
  //     for (var r in network.rooms) {
  //       if (r.id == id) {
  //         return r;
  //       }
  //     }
  //   }
  //   return null;
  // }
  //
  // hue.Zone? _findZone(String id) {
  //   final network = _network;
  //   if (network != null) {
  //     for (var z in network.zones) {
  //       if (z.id == id) {
  //         return z;
  //       }
  //     }
  //   }
  //   return null;
  // }

  Future<void> _discoverBridges() async {
    final bridges = await BridgeDiscoveryRepo.fetchSavedBridges();
    print('saved is $bridges');
    if (bridges.isEmpty) {
      List<String> bridgeIps = [];
      try {
        bridgeIps = await BridgeDiscoveryRepo.discoverBridges();
      } catch (e) {
        print('got $e');
      }
      if (bridges.isEmpty) {
        bridgeIps.add("192.168.86.46");
      }
      for (var ipAddress in bridgeIps) {
        final bridge =
            await BridgeDiscoveryRepo.firstContact(bridgeIpAddr: ipAddress);
        print('connected $bridge');
        if (bridge != null) {
          bridges.add(bridge);
        }
      }
    }
    _bridges = bridges;
  }

  Future<void> _fetchNetwork() async {
    final bridges = _bridges ?? [];

    final network = hue.HueNetwork(bridges: bridges);
    await network.fetchAll();
    _network = network;

    // (re)populate
    _lights.clear();
    _rooms.clear();
    _zones.clear();

    for (var s in network.scenes) {
      print('scene ${s.metadata.name}');
    }

    // map rooms
    final roomMap = <String, List<String>>{};
    for (var r in network.rooms) {
      _rooms.add(r.metadata.name);
      roomMap[r.metadata.name] = [];
      for (var c in r.children) {
        roomMap[r.metadata.name]?.add(c.id);
      }
    }

    // map zones
    final zoneMap = <String, List<String>>{};
    for (var z in network.zones) {
      _zones.add(z.metadata.name);
      zoneMap[z.metadata.name] = [];
      for (var c in z.children) {
        zoneMap[z.metadata.name]?.add(c.id);
      }
    }

    for (var d in network.devices) {
      final services = <hue.ResourceType, hue.Relative>{};
      for (var s in d.services) {
        services[s.type] = s;
      }

      final lightService = services[hue.ResourceType.light];
      if (lightService == null) {
        continue;
      }
      final light = _findLight(lightService.id);
      if (light == null) {
        continue;
      }

      String? room;
      for (var e in roomMap.entries) {
        if (e.value.contains(d.id)) {
          room = e.key;
        }
      }

      List<String> zones = [];
      for (var e in zoneMap.entries) {
        if (e.value.contains(d.id)) {
          zones.add(e.key);
        }
      }

      _lights.add(Light(
          id: light.id,
          name: d.metadata.name,
          type: ResourceType.light,
          room: room,
          zones: zones,
          on: light.isOn));
      print(_lights);
    }
  }
}
