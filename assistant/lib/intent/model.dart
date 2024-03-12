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

import 'package:flutter/foundation.dart';

enum IntentName {
  // takeout playlist
  playArtistSongs,
  playArtistSong,
  playArtistRadio,
  playArtistPopularSongs,
  playArtistAlbum,
  playSong,
  playAlbum,
  playRadio,
  playSearch,

  // takeout player
  playerPlay,
  playerPause,
  playerNext,

  // TODO
  // takeout movies
  playMovie,

  // volume
  volume,
  volumeUp,
  volumeDown,

  // torch/flash
  torchOn,
  torchOff,

  // alarm/timer
  setAlarm,
  setWeekdayAlarm,
  setWeekendAlarm,
  dismissAlarm,
  dismissWeekdayAlarm,
  dismissWeekendAlarm,
  setTimer,
  dismissTimer,

  // lights
  turnOnAllLights,
  turnOnLight,
  turnOffAllLights,
  turnOffLight,
  setLightBrightness,
  setLightColor,
}

enum Extra {
  artist,
  album,
  song,
  brightness,
  brightnessValue,
  name,
  color,
  colorValue,
  light,
  room,
  zone,
  volume,
  volumeValue,
  time,
  duration,
  hour,
  minutes,
  seconds,
  title,
  query,
  station;

  static Map<String,Extra> _table = <String,Extra>{};

  static Extra? toExtra(String value) {
    if (_table.isEmpty) {
      for (var v in values) {
        _table[v.name] = v;
      }
    }
    return _table[value];
  }
}

class Intent {
  final IntentName name;
  final Map<Extra, dynamic> extras;

  Intent(this.name, this.extras);

  dynamic operator [](Extra e) => extras[e];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Intent &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          mapEquals(extras, other.extras);

  @override
  int get hashCode => name.hashCode ^ extras.hashCode;
}

typedef IntentExtras = Map<Extra, dynamic>;
typedef ExtrasCallback = Function(IntentExtras extras);

class IntentModel {
  final IntentName name;
  final List<String> keywords;
  final List<String> required;
  final List<RegExp>? regexps;
  final ExtrasCallback? callback;

  IntentModel({
    required this.name,
    required this.keywords,
    required this.required,
    this.regexps,
    this.callback,
  });

  int match(String phrase) {
    var hits = 0, req = 0;
    final words = phrase.split(' ');
    for (var w in words) {
      w = w.toLowerCase();
      if (keywords.contains(w)) {
        hits++;
      }
      if (required.contains(w)) {
        req++;
      }
    }
    if (req == required.length) {
      return hits;
    }
    return 0;
  }

  Intent? toIntent(String phrase) {
    final patterns = regexps;
    if (patterns == null) {
      return Intent(name, {});
    }
    for (var r in patterns) {
      if (r.hasMatch(phrase)) {
        final extras = _extract(phrase, r);
        callback?.call(extras);
        return Intent(name, extras);
      }
    }
    return null;
  }

  Map<Extra, dynamic> _extract(String phrase, RegExp regexp) {
    final result = IntentExtras();
    final match = regexp.firstMatch(phrase);
    if (match != null) {
      for (var n in match.groupNames) {
        final e = _matchNameExtra(n);
        result[e] = match.namedGroup(n);
      }
    }
    return result;
  }

  Extra _matchNameExtra(String name) {
    final extra = Extra.toExtra(name);
    if (extra != null) {
      return extra;
    }
    throw UnsupportedError;
  }
}
