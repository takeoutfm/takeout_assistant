// Copyright 2024 defsub
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

  @override
  Future<bool> authRequired() async {
    final bridges = await BridgeDiscoveryRepo.fetchSavedBridges();
    return bridges.isEmpty;
  }

  @override
  Future<void> discover({String? defaultBridge}) async {
    await _discoverBridges(defaultBridge);
  }

  @override
  Future<void> fetchNetwork() async {
    await _fetchNetwork();
  }

  @override
  List<Light> get lights => _lights;

  @override
  List<String> get rooms => _rooms;

  @override
  List<String> get zones => _zones;

  @override
  Future<void> identifyLight(Light light) async {
    hue.Device? target = _findDevice(light.name);
    if (target != null) {
      target.identifyAction = 'identify';
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

  @override
  Future<void> lightOn(Light light) async {
    return _light(light, true);
  }

  @override
  Future<void> lightOff(Light light) async {
    return _light(light, false);
  }

  @override
  Future<void> toggleLight(Light light) async {
    hue.Light? target = _findLight(light.id);
    if (target != null) {
      target.on.isOn = !target.on.isOn;
      await target.bridge?.put(target);
    }
  }

  @override
  Future<void> lightBrightness(Light light, double percentage) async {
    hue.Light? target = _findLight(light.id);
    if (target != null) {
      target.dimming.brightness = percentage;
      await target.bridge?.put(target);
    }
  }

  @override
  Future<void> lightColor(Light light, Color color) async {
    hue.Light? target = _findLight(light.id);
    if (target != null) {
      final xy = color.toXy();
      target.color.xy.x = xy[0];
      target.color.xy.y = xy[1];
      await target.bridge?.put(target);
    }
  }

  @override
  Future<void> zoneColor(String name, Color color) async {
    final groupedLight = _zoneGroupedLight(name);
    print('$name $groupedLight');
    if (groupedLight != null) {
      return _groupColor(groupedLight, color);
    }
  }

  hue.GroupedLight? _zoneGroupedLight(String name) {
    final network = _network;
    if (network == null) {
      return null;
    }
    for (var zone in network.zones) {
      print('zone ${zone.metadata.name} vs $name');
      if (zone.metadata.name == name) {
        for (var res in zone.servicesAsResources) {
          print('res $res');
          if (res is hue.GroupedLight) {
            return res;
          }
        }
      }
    }
    return null;
  }

  Future<void> _groupColor(hue.GroupedLight groupedLight, Color color) async {
    final xy = color.toXy();
    print('group color ${xy[0]} ${xy[1]}');
    groupedLight.xy = hue.LightColorXy(x: xy[0], y: xy[1]);
    print('${groupedLight.xy}');
    print('put $_network put');
    return _network?.put();
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

  Future<void> _discoverBridges(String? defaultBridge) async {
    final bridges = await BridgeDiscoveryRepo.fetchSavedBridges();
    if (bridges.isEmpty) {
      List<String> bridgeIps = [];
      try {
        bridgeIps = await BridgeDiscoveryRepo.discoverBridges();
      } catch (e) {
        print('got $e');
      }
      if (bridges.isEmpty && defaultBridge != null) {
        bridgeIps.add(defaultBridge);
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
    _populate(network);
  }

  void _populate(hue.HueNetwork network) {
    // (re)populate
    _lights.clear();
    _rooms.clear();
    _zones.clear();

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
        if (e.value.contains(light.id)) {
          zones.add(e.key);
        }
      }

      final xy = light.color.xy;
      final color = hue.ColorConverter.xy2color(xy.x, xy.y);

      _lights.add(Light(
          id: light.id,
          name: d.metadata.name,
          type: ResourceType.light,
          room: room,
          zones: zones,
          color: color,
          brightness: light.dimming.brightness,
          on: light.isOn));
    }
  }
}
