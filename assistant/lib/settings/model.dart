// Copyright 2023 defsub
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

import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable()
class Settings {
  final List<String> wakeWords;
  final bool use24HourClock;

  Settings({required this.wakeWords, required this.use24HourClock});

  factory Settings.initial() => Settings(
        wakeWords: ['computer'],
        use24HourClock: false,
      );

  Settings copyWith({
    List<String>? wakeWords,
    bool? use24HourClock,
  }) =>
      Settings(
        wakeWords: wakeWords ?? this.wakeWords,
        use24HourClock: use24HourClock ?? this.use24HourClock,
      );

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsToJson(this);
}
