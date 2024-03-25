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

enum ResourceType {
  light,
}

abstract class Resource {
  final String id;
  final String name;
  final String? room;
  final List<String> zones;
  final ResourceType type;

  Resource(
      {required this.id,
      required this.name,
      required this.type,
      this.room,
      this.zones = const []});

  List<String> get qualifiedNames {
    return [
      if (room != null) '${room!.toLowerCase()} ${name.toLowerCase()}',
      ...zones.map((zone) => '${zone.toLowerCase()} ${name.toLowerCase()}'),
    ];
  }
}

class Light extends Resource {
  final bool on;
  final Color color;
  final double brightness;

  Light(
      {required super.id,
      required super.name,
      required super.type,
      required this.on,
      required this.color,
      required this.brightness,
      super.room,
      super.zones});

  Light copyWith({bool? on, Color? color, double? brightness}) => Light(
        id: id,
        name: name,
        type: type,
        room: this.room,
        zones: this.zones,
        on: on ?? this.on,
        color: color ?? this.color,
        brightness: brightness ?? this.brightness,
      );
}
