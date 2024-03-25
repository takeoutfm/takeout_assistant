// Copyright 2024 defsub
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

import 'dart:ui';

import 'model.dart';

abstract class HomeProvider {
  Future<bool> authRequired();

  Future<void> discover({String? defaultBridge});

  Future<void> fetchNetwork();

  List<Light> get lights;

  List<String> get rooms;

  List<String> get zones;

  Future<void> identifyLight(Light light);

  Future<void> toggleLight(Light light);

  Future<void> lightOn(Light light);

  Future<void> lightOff(Light light);

  Future<void> lightBrightness(Light light, double percentage);

  Future<void> lightColor(Light light, Color color);

  Future<void> zoneColor(String name, Color color);
}
