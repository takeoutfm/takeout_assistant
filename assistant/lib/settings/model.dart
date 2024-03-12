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

import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

enum DisplayType {
  clock,
  basic,
}

@JsonSerializable()
class AssistantSettings {
  static const defaultWakeWords = <String>[];
  static const defaultLanguage = 'en';

  final bool enableWakeWords;
  final List<String> wakeWords;
  final bool use24HourClock;
  final String language;
  final DisplayType displayType;
  final String? homeRoom;
  final bool enableMusicZone;
  final String? musicZone;
  final String? bridgeAddress;
  final bool showPlayer;

  AssistantSettings(
      {required this.enableWakeWords,
      required this.wakeWords,
      required this.use24HourClock,
      required this.displayType,
      this.language = AssistantSettings.defaultLanguage,
      this.homeRoom,
      this.enableMusicZone = false,
      this.musicZone,
      this.bridgeAddress,
      this.showPlayer = true});

  factory AssistantSettings.initial() => AssistantSettings(
        enableWakeWords: false,
        wakeWords: defaultWakeWords,
        use24HourClock: false,
        displayType: DisplayType.clock,
        language: defaultLanguage,
      );

  AssistantSettings copyWith({
    bool? enableWakeWords,
    List<String>? wakeWords,
    bool? use24HourClock,
    DisplayType? displayType,
    String? language,
    String? homeRoom,
    bool? enableMusicZone,
    String? musicZone,
    String? bridgeAddress,
    bool? showPlayer,
  }) {
    return AssistantSettings(
      enableWakeWords: enableWakeWords ?? this.enableWakeWords,
      wakeWords: _checkWords(wakeWords ?? this.wakeWords),
      use24HourClock: use24HourClock ?? this.use24HourClock,
      displayType: displayType ?? this.displayType,
      language: language ?? this.language,
      homeRoom: homeRoom ?? this.homeRoom,
      enableMusicZone: enableMusicZone ?? this.enableMusicZone,
      musicZone: musicZone ?? this.musicZone,
      bridgeAddress: bridgeAddress ?? this.bridgeAddress,
      showPlayer: showPlayer ?? this.showPlayer,
    );
  }

  factory AssistantSettings.fromJson(Map<String, dynamic> json) =>
      _$AssistantSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$AssistantSettingsToJson(this);

  List<String> _checkWords(List<String> words) {
    final list = List<String>.from(words.map((w) => w.trim()));
    list.retainWhere((w) => w.isNotEmpty);
    return list;
  }
}
