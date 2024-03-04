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

enum DisplayType {
  clock,
  basic,
}

@JsonSerializable()
class Settings {
  static const defaultWakeWords = <String>[];
  static const defaultLanguage = 'en';

  final List<String> wakeWords;
  final bool use24HourClock;
  final String language;
  final DisplayType displayType;
  final String? homeRoom;

  Settings(
      {required this.wakeWords,
      required this.use24HourClock,
      required this.displayType,
      this.language = Settings.defaultLanguage,
      this.homeRoom});

  factory Settings.initial() => Settings(
        wakeWords: defaultWakeWords,
        use24HourClock: false,
        displayType: DisplayType.clock,
        language: defaultLanguage,
      );

  Settings copyWith({
    List<String>? wakeWords,
    bool? use24HourClock,
    DisplayType? displayType,
    String? language,
    String? homeRoom,
  }) {
    return Settings(
      wakeWords: _checkWords(wakeWords ?? this.wakeWords),
      use24HourClock: use24HourClock ?? this.use24HourClock,
      displayType: displayType ?? this.displayType,
      language: language ?? this.language,
      homeRoom: homeRoom ?? this.homeRoom,
    );
  }

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsToJson(this);

  List<String> _checkWords(List<String> words) {
    final list = List<String>.from(words.map((w) => w.trim()));
    list.retainWhere((w) => w.isNotEmpty);
    return list;
  }
}
